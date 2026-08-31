%% explore04_iq_time.m
%  ------------------------------------------------------------------
%  ONE IDEA: what I and Q actually look like, before any FFT.
%
%  A real radio does not record one number per sample. It records TWO:
%  I (in-phase) and Q (quadrature). MATLAB keeps them together as one
%  complex number, a + bi.
%
%  Why two? With one number you cannot tell a signal 100 kHz ABOVE the
%  tuned frequency from one 100 kHz BELOW it - they look identical.
%  The second number carries the extra information that separates them.
%  That is why the spectrum of radio data has a left half and a right
%  half, while the spectrum of an ordinary audio recording does not.
%
%  Run this from the TOP folder of the repo (the one with README.md).
%  Needs: plain MATLAB. No toolbox.
%  ------------------------------------------------------------------

clear; clc;
load('data/fm_capture_98MHz.mat');
iq = double(iq);

n_show = 400;                      % how many samples to draw
t_us = (0:n_show-1)/fs*1e6;        % their time, in microseconds
I = real(iq(1:n_show));
Q = imag(iq(1:n_show));

clf
subplot(3,1,1); plot(t_us, I); grid on
ylabel('I'); title('I and Q are two DIFFERENT signals')
subplot(3,1,2); plot(t_us, Q); grid on
ylabel('Q')
subplot(3,1,3); plot(t_us, abs(iq(1:n_show))); grid on
ylabel('size'); xlabel('Time (microseconds)')
title('abs(iq) - how strong the radio wave is, moment by moment')

fprintf('Showing the first %d samples = %.1f microseconds.\n\n', n_show, n_show/fs*1e6);
fprintf('  first sample        : %.4f %+.4fi\n', real(iq(1)), imag(iq(1)));
fprintf('  biggest size        : %.4f   (near 1.0 would mean clipping)\n', max(abs(iq)));
fprintf('  typical size (rms)  : %.4f\n\n', sqrt(mean(abs(iq).^2)));

% The average of I and Q should be zero for a pure radio signal. It is
% not, and that offset is a real hardware fault called DC OFFSET.
mI = mean(real(iq));
mQ = mean(imag(iq));
fprintf('  average of I        : %+.4f\n', mI);
fprintf('  average of Q        : %+.4f\n', mQ);
fprintf('  size of that offset : %.4f, which is %.2f dB\n\n', ...
        abs(mI + 1i*mQ), 20*log10(abs(mI + 1i*mQ)));
disp('That number is exactly the height of the spike you see at the');
disp('very centre of the spectrum. A steady offset in time is a spike');
disp('at zero frequency - and zero frequency is the tuned frequency.');

%% ================== TRY THIS ==================
%  1) Change n_show to 40 and run again.
%     Expect: you can now follow individual wiggles. I and Q clearly
%     rise and fall at similar speeds but never at the same moment -
%     they are about a quarter of a cycle apart. That quarter-cycle
%     shift is what the word "quadrature" means.
%
%  2) Subtract the DC offset and check the centre spike disappears:
%        iq2 = iq - mean(iq);
%        N = numel(iq2);
%        plot((fc + (-N/2:N/2-1)*(fs/N))/1e6, 20*log10(abs(fftshift(fft(iq2)))/N))
%     Expect: exactly the same picture as before, except the thin spike
%     at 98.000 MHz has gone completely - that point drops from about
%     -24.6 dB to below -300 dB, which is MATLAB's way of saying zero.
%     One line of code fixes a hardware fault.
%
%  3) Load the low-gain file instead (data/fm_capture_98MHz_lowgain.mat).
%     Expect: the same shapes, but everything about 30 dB smaller -
%     biggest size drops from about 0.83 to about 0.11. Same radio wave,
%     less amplification.
