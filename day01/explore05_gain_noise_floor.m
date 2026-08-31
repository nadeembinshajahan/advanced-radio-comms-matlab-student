%% explore05_gain_noise_floor.m
%  ------------------------------------------------------------------
%  ONE IDEA: turning up the receiver gain does NOT lift everything by
%  the same amount.
%
%  Two recordings of exactly the same piece of band, taken seconds
%  apart, with only one thing changed: the receiver's gain setting.
%  One is at 50 dB, one at 20 dB - a 30 dB difference.
%
%  Watch the stations, then watch the noise floor underneath them. The
%  stations move 30 dB. The floor moves about 10 dB. The difference is
%  free clarity, and it comes from the fact that some of the noise is
%  made INSIDE the receiver, after the gain, so the gain cannot amplify
%  it. That is the idea behind NOISE FIGURE.
%
%  Run this from the TOP folder of the repo (the one with README.md).
%  Needs: plain MATLAB. No toolbox.
%  ------------------------------------------------------------------

clear; clc;
hi = load('data/fm_capture_98MHz.mat');
lo = load('data/fm_capture_98MHz_lowgain.mat');

fs = hi.fs;  fc = hi.fc;
N  = numel(hi.iq);
f_MHz = (fc + (-N/2:N/2-1)*(fs/N)) / 1e6;

S_hi = 20*log10(abs(fftshift(fft(double(hi.iq))))/N);
S_lo = 20*log10(abs(fftshift(fft(double(lo.iq))))/N);

clf
plot(f_MHz, S_hi, f_MHz, S_lo); grid on
legend(sprintf('gain %g dB', hi.gain_dB), sprintf('gain %g dB', lo.gain_dB))
xlabel('Frequency (MHz)'); ylabel('Level (dB)')
title('Same band, same antenna, two gain settings')

quiet = (f_MHz > 98.55) & (f_MHz < 98.70);   % a piece of band with nothing in it
floor_hi = median(S_hi(quiet));
floor_lo = median(S_lo(quiet));

fprintf('gain difference between the two files : %g dB\n\n', hi.gain_dB - lo.gain_dB);
fprintf('noise floor at gain %g dB : %7.2f dB\n',   hi.gain_dB, floor_hi);
fprintf('noise floor at gain %g dB : %7.2f dB\n',   lo.gain_dB, floor_lo);
fprintf('so the noise floor moved  : %7.2f dB\n\n', floor_hi - floor_lo);

fprintf('%-10s %10s %10s %10s %10s %10s\n', ...
        'station', 'peak hi', 'above', 'peak lo', 'above', 'gained');
for st = [97.2 97.4 97.8 98.2 98.4 98.8]
    near = abs(f_MHz - st) < 0.02;
    p_hi = max(S_hi(near));   p_lo = max(S_lo(near));
    fprintf('%7.1f MHz %10.2f %10.1f %10.2f %10.1f %10.1f\n', ...
            st, p_hi, p_hi - floor_hi, p_lo, p_lo - floor_lo, ...
            (p_hi - floor_hi) - (p_lo - floor_lo));
end
disp(' ');
disp('Every station gained about the same 19 to 20 dB. The gain does');
disp('not pick favourites. But look at the weakest station: it started');
disp('close to the noise, so those 19 dB are the difference between a');
disp('signal you can use and one you cannot.');

%% ================== TRY THIS ==================
%  1) Change the quiet window to  (f_MHz > 98.15) & (f_MHz < 98.25)
%     and run again.
%     Expect: the "noise floor" reads about -52.4 dB instead of
%     -74.3 dB, so it jumps about 22 dB, and every "above" number
%     collapses. You have measured the strongest station and called it
%     noise. Always pick a piece of band that is EMPTY.
%
%  2) Change the 0.02 in  near  to 0.002 (a 4 kHz window instead of
%     40 kHz).
%     Expect: almost identical peak numbers. The carrier spike is very
%     narrow, so a tight window still finds it - and a tight window is
%     safer when two stations are close together.
%
%  3) Work out the ratio yourself: the stations rose 30 dB and the
%     floor rose 10 dB. In power terms that is 1000 times versus 10
%     times. Every station ended up 100 times clearer for free.
