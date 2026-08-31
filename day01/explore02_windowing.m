%% explore02_windowing.m
%  ------------------------------------------------------------------
%  ONE IDEA: SPECTRAL LEAKAGE, and the window that cures it.
%
%  An FFT quietly assumes your block of samples repeats forever. If a
%  signal does not fit a whole number of times into the block, the join
%  is a jump, and that jump smears energy sideways across the whole
%  picture. That smear is called LEAKAGE. It can bury a weak signal
%  sitting next to a strong one.
%
%  The cure is a WINDOW: fade the block in at the start and out at the
%  end so there is no jump. Here we build a Hann window by hand out of
%  a cosine - no toolbox needed:
%        w = 0.5 - 0.5*cos(2*pi*(0:N-1)/N)
%
%  Run this from the TOP folder of the repo (the one with README.md).
%  Needs: plain MATLAB. No toolbox.
%  ------------------------------------------------------------------

clear; clc;

%% ---- PART A: made-up signals, where leakage is easy to see --------
fs = 2e6;
N  = 4096;
t  = (0:N-1)/fs;

% One strong tone, deliberately placed HALF WAY between two FFT points
% (that is the worst case), and one tone 60 dB weaker close beside it.
f_strong = 500.5 * fs/N;
f_weak   = 540.0 * fs/N;
x = exp(1i*2*pi*f_strong*t) + 0.001*exp(1i*2*pi*f_weak*t);

w = 0.5 - 0.5*cos(2*pi*(0:N-1)/N);     % the Hann window, built by hand

S_plain  = 20*log10(abs(fft(x))   / N);        % no window
S_hann = 20*log10(abs(fft(x.*w))/ sum(w));   % window, and correct for it
% Note we divide by sum(w) and not by N. The window throws some signal
% away, and dividing by sum(w) puts the heights back where they belong.

bins = 400:700;
clf
plot(bins, S_plain(bins+1), bins, S_hann(bins+1)); grid on
legend('no window', 'Hann window'); ylim([-140 5])
xlabel('FFT point number'); ylabel('Level (dB)')
title('The weak tone is buried by leakage until you use a window')

fprintf('The weak tone was built 60.00 dB below the strong one.\n');
fprintf('  no window : strong peak %7.2f dB, weak tone reads %7.2f dB\n', ...
        max(S_plain(1:800)),  S_plain(541));
fprintf('  Hann      : strong peak %7.2f dB, weak tone reads %7.2f dB\n\n', ...
        max(S_hann(1:800)), S_hann(541));
disp('Without the window the strong tone reads about 3.9 dB too low,')
disp('and its smear sits on top of the weak tone so you cannot read it.')

%% ---- PART B: the same window on the real capture ------------------
load('data/fm_capture_98MHz.mat');
iq = double(iq);  N2 = numel(iq);
w2 = 0.5 - 0.5*cos(2*pi*(0:N2-1)/N2);

Sp = 20*log10(abs(fftshift(fft(iq)))     / N2);
Sw = 20*log10(abs(fftshift(fft(iq.*w2))) / sum(w2));
f_MHz = (fc + (-N2/2:N2/2-1)*(fs/N2)) / 1e6;

near = abs(f_MHz - 98.2) < 0.02;
quiet = (f_MHz > 98.55) & (f_MHz < 98.70);
fprintf('On the REAL capture:\n');
fprintf('  no window : peak %7.2f dB, floor %7.2f dB\n', max(Sp(near)), median(Sp(quiet)));
fprintf('  Hann      : peak %7.2f dB, floor %7.2f dB\n', max(Sw(near)), median(Sw(quiet)));
disp('Barely any change. That is normal and it is worth understanding:')
disp('here the NOISE floor is already higher than the leakage, so the')
disp('window has nothing to uncover. Windows earn their keep when you')
disp('are hunting a weak signal right next to a very strong one.')

%% ================== TRY THIS ==================
%  1) In Part A change f_strong to  500.0 * fs/N  (a whole number of
%     points instead of a half). Run again.
%     Expect: the leakage almost vanishes even with no window, the
%     strong peak reads 0.00 dB instead of -3.92 dB, and the weak tone
%     becomes readable at -60 dB either way. Real signals are never
%     this lucky, which is why we window.
%
%  2) In Part A change the 0.001 to 0.01 (a weak tone only 40 dB down).
%     Expect: now you CAN see it without a window, because it pokes
%     above the -42 dB smear. But it reads about -37.7 dB instead of
%     the true -40 dB: the leakage adds to it, so the measurement is
%     over 2 dB wrong. Leakage sets how far down you can look AND how
%     accurately you can measure near a strong signal.
%
%  3) Replace the Hann window with a triangle you build yourself:
%        w = 1 - abs((0:N-1) - (N-1)/2) / ((N-1)/2);
%     Expect: it works too - strong peak -1.82 dB and the weak tone
%     back at -60.0 dB, very close to Hann's -1.42 and -60.00. The big
%     win comes from fading the block at all; the differences between
%     one good window and another are small.
