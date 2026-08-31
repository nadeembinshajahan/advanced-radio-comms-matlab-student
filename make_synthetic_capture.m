%% ====================================================================
%  make_synthetic_capture.m
%  ------------------------------------------------------------------
%  Builds the sample IQ capture files that ship in data/. You do NOT
%  need to run this - the files are already there. It is here so you
%  can see exactly what the sample data is, and change it if you want
%  a different band plan to practise on.
%
%  Output    : data/fm_capture_98MHz.mat          (receiver gain 50 dB)
%              data/fm_capture_98MHz_lowgain.mat  (receiver gain 20 dB)
%              about 0.97 MB each.
%  Run time  : about 3 seconds. No hardware, no toolbox, no internet.
%  Run it from the TOP folder of this repo.
%
%  If you re-run this, the noise is drawn again, so noise-floor numbers
%  move by a few tenths of a dB. Every station frequency and every
%  station level stays exactly the same.
%
%  What is in the sample capture, and why:
%   - six FM stations on the 200 kHz channel grid, at different
%     strengths, so you can measure spacing and dB differences
%   - each station is a carrier plus real modulation sidebands, so it
%     looks like a hump with a spike on top, not a bare line
%   - a realistic noise floor about 58 dB below the strongest station
%   - a small DC spike exactly at the tuned frequency, like every real
%     zero-IF receiver has. It is NOT a station.
%   - a second file at 30 dB less receiver gain, so you can watch the
%     noise floor move
% ====================================================================

%% Section 1 - the band plan
clear; clc;
fs = 2e6;          % sample rate: 2 MSa/s, so we see a 2 MHz slice of band
fc = 98e6;         % the frequency the "radio" is tuned to
N  = 131072;       % 8 frames of 16384, a typical Pluto capture size

station_MHz = [97.2  97.4  97.8  98.2  98.4  98.8];  % six stations, 200 kHz grid
station_dB  = [ -25   -21   -11     0    -6   -16];  % how strong each one is

audio_bw = 45e3;   % how wide the modulation on each station is
pidx     = 1.1;    % how hard each station is modulated (radians, rms)

dc        = 0.16 + 0.11i;   % the receiver's own DC offset (a fixed complex number)
sigma_in  = 0.2618;         % noise picked up at the antenna (gets amplified)
sigma_adc = 27.59;          % noise made inside the receiver (does NOT get amplified)
SCALE     = 9.6e-4;         % fixed scale so the high-gain file peaks near 0.8
gains_dB  = [50 20];        % the two receiver gain settings to save

rng(7);            % same random numbers every time this script is run
t   = (0:N-1)/fs;  % time, one row
amp = 10.^(station_dB/20);

%% Section 2 - build the six stations
% Each station is a carrier that is phase-modulated by a slice of
% low-frequency noise. That is a fair model of a broadcast station:
% a strong line at the channel centre, with a hump of modulation
% spread either side of it.
kmax = round(audio_bw*N/fs);        % how many FFT bins the modulation fills
s    = zeros(1, N);

for k = 1:numel(station_MHz)
    w = randn(1, N);                % white noise
    W = fft(w);
    W(kmax+2 : N-kmax) = 0;         % throw away everything above audio_bw
    m = real(ifft(W));              % what is left is slow, smooth noise
    m = m / sqrt(mean(m.^2));       % scale it to an rms of 1

    foff = station_MHz(k)*1e6 - fc; % where this station sits, relative to fc
    s = s + amp(k) * exp(1i*(2*pi*foff*t + pidx*m));
end

%% Section 3 - the two noise sources
% Complex noise, because the signal is complex. Dividing by sqrt(2)
% splits the power evenly between the I part and the Q part.
n_in  = sigma_in  * (randn(1,N) + 1i*randn(1,N)) / sqrt(2);
n_adc = sigma_adc * (randn(1,N) + 1i*randn(1,N)) / sqrt(2);

%% Section 4 - apply each gain setting and save a file
for g_i = 1:numel(gains_dB)
    gain_dB = gains_dB(g_i);
    g       = 10^(gain_dB/20);

    % Antenna signal and antenna noise both go through the gain.
    % The receiver's own noise is added AFTER the gain, so turning the
    % gain up lifts the wanted signal further above it. That is the
    % whole point of the comparison at the end of Exercise 6.
    x = SCALE * ( g*(s + dc + n_in) + n_adc );

    iq           = single(x);                 % single = 8 bytes per sample
    capture_time = char(datetime('now','Format','yyyy-MM-dd HH:mm:ss'));
    source       = 'synthetic';

    if gain_dB == max(gains_dB)
        outfile = 'data/fm_capture_98MHz.mat';
    else
        outfile = 'data/fm_capture_98MHz_lowgain.mat';
    end
    save(outfile, 'iq', 'fs', 'fc', 'gain_dB', 'capture_time', 'source');

    d = dir(outfile);
    fprintf('%-38s gain %2g dB   biggest |iq| %.4f   %.2f MB\n', ...
            outfile, gain_dB, max(abs(x)), d.bytes/1e6);
end

fprintf('\nDone. %d samples each, %.3f ms long, %.3f MHz wide, centred on %.3f MHz.\n', ...
        N, 1000*N/fs, fs/1e6, fc/1e6);
