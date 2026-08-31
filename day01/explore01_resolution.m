%% explore01_resolution.m
%  ------------------------------------------------------------------
%  ONE IDEA: how many samples you use decides how FINE your frequency
%  picture is, and how far DOWN you can see.
%
%  The gap between two neighbouring points of an FFT is  fs / N.
%  Use more samples and that gap gets smaller, so you can tell apart
%  two signals that are very close together. You also collect more of
%  the signal, so the signal stands taller above the noise.
%
%  Run this from the TOP folder of the repo (the one with README.md).
%  Needs: plain MATLAB. No toolbox.
%  ------------------------------------------------------------------

clear; clc;
load('data/fm_capture_98MHz.mat');     % gives iq, fs, fc, ...
iq = double(iq);

N_list = [1024 8192 131072];           % three different amounts of data
clf

for i = 1:numel(N_list)
    N = N_list(i);
    x = iq(1:N);                       % just the first N samples

    S_dB = 20*log10(abs(fftshift(fft(x)))/N);
    f_MHz = (fc + (-N/2:N/2-1)*(fs/N)) / 1e6;

    % how tall is the 98.2 MHz station, and how low is the noise floor?
    near_station = abs(f_MHz - 98.2)  < 0.02;
    quiet        = (f_MHz > 98.55) & (f_MHz < 98.70);
    peak  = max(S_dB(near_station));
    floor_dB = median(S_dB(quiet));

    fprintf('N = %6d : %7.3f ms of data, points are %8.2f Hz apart\n', N, 1000*N/fs, fs/N);
    fprintf('             station peak %7.2f dB, noise floor %7.2f dB, gap %5.1f dB\n\n', ...
            peak, floor_dB, peak - floor_dB);

    subplot(3,1,i)
    plot(f_MHz, S_dB); grid on; ylim([-100 0])
    ylabel('dB'); title(sprintf('N = %d samples  (%.0f Hz per point)', N, fs/N))
end
xlabel('Frequency (MHz)')

disp('Look at the three pictures. The stations sit at the same height.')
disp('It is the NOISE FLOOR that drops as you use more samples.')

%% ================== TRY THIS ==================
%  1) Change N_list to [256 4096 65536] and run again.
%     Expect: at N = 256 the points are 7812 Hz apart and the whole
%     picture is coarse and lumpy. The noise floor reads about
%     -44.6 dB, roughly 26 dB higher than the -71.1 dB you get at
%     N = 65536, and the weak stations are lost in it.
%
%  2) Add up the rule: every time you multiply N by 8, the noise floor
%     should drop by 10*log10(8) = 9.0 dB. Check it against the numbers
%     printed above: 1024 -> 8192 gives -53.5 to -62.2, which is 8.7 dB.
%     Close to 9. The small difference is just noise being noisy.
%
%  3) Change the 98.2 in near_station to 97.2 (the weakest station).
%     Expect: at N = 1024 the gap is only about 10.7 dB - the station
%     is there, but barely. At N = 131072 the gap is about 32.9 dB and
%     it is obvious. More data finds weak signals.
