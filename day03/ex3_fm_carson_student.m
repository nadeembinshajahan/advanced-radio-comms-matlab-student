%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 3 - Modulation Techniques
%  Exercise  : 3 - FM and Carson's rule   *** STUDENT STARTER FILE ***
%  Teaches   : FM keeps the amplitude fixed and moves the FREQUENCY up
%              and down with the message. How far it moves is the
%              deviation. Carson's rule says the bandwidth an FM signal
%              needs is  BW = 2 x (deviation + message frequency).
%              Narrowband FM is thin, wideband FM is wide - and the
%              spectrum on screen agrees with the rule almost exactly.
%  Run time  : about 14 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : Sections 1-2 are TYPE ALONG - fill in the YOUR CODE HERE
%              gaps. Sections 3-5 are RUN AND SEE - they are already
%              complete. Do NOT type them. Just run them and watch.
%  How to use: click inside a section and press Run Section, one at a time.
%              Run Section 3 before Sections 4 and 5.
% ====================================================================

%% Section 1 (TYPE ALONG) - Carson's rule on three real radio systems
clear; clc;
fm    = [3e3   3e3   15e3];       % highest message frequency, Hz
dev   = [1e3   5e3   75e3];       % peak deviation, Hz
% GAP 1: work out the modulation index and the Carson bandwidth for all
%        three systems at once.
% Hint: beta = deviation divided by message frequency. Two vectors, so "./".
% Hint: Carson's rule is BW = 2*(deviation + message frequency).
beta  = % YOUR CODE HERE
BW    = % YOUR CODE HERE
BW_kHz = BW / 1e3                 % the same answer in kHz
disp('Modulation index beta:'); disp(beta)
% Column 1 = narrowband data link, column 2 = a 2-way FM radio,
% column 3 = broadcast FM radio (the 200 kHz channels on your car radio).

%% Section 2 (TYPE ALONG) - how bandwidth grows with deviation
d_sweep  = 0:5e3:100e3;           % deviation from 0 up to 100 kHz
% GAP 2: apply Carson's rule to the whole sweep, with fm fixed at 15 kHz.
BW_sweep = % YOUR CODE HERE
plot(d_sweep/1e3, BW_sweep/1e3, 'LineWidth', 2); grid on
xlabel('Peak deviation (kHz)'); ylabel('Carson bandwidth (kHz)')
title('Carson bandwidth vs deviation, message fixed at 15 kHz')
% Note the straight line and where it starts: even at ZERO deviation the
% bandwidth is still 30 kHz, because 2 x 15 kHz is the floor.

%% Section 3 (RUN AND SEE) - build a real FM waveform
% What this block does: it wobbles the carrier frequency with the message
% by adding up (cumsum) the message to make the phase. Narrowband first,
% then wideband. Watch the HEIGHT of both traces - it never changes.
Fs   = 20000;                     % 20 000 samples every second
t    = 0:1/Fs:0.02-1/Fs;          % exactly 400 samples = 0.02 second
fmes = 50;                        % message tone, 50 Hz (one cycle shown)
fc   = 1000;                      % carrier, 1000 Hz (20 cycles shown)
m    = cos(2*pi*fmes*t);          % the message
dev_nb = 50;                      % narrowband: deviation 50 Hz  -> beta = 1
dev_wb = 500;                     % wideband:   deviation 500 Hz -> beta = 10
s_nb = cos(2*pi*fc*t + 2*pi*dev_nb*cumsum(m)/Fs);
s_wb = cos(2*pi*fc*t + 2*pi*dev_wb*cumsum(m)/Fs);
subplot(2,1,1); plot(t*1000, s_nb); grid on; ylim([-1.5 1.5])
title('Narrowband FM, deviation 50 Hz (beta = 1)'); xlabel('Time (ms)')
subplot(2,1,2); plot(t*1000, s_wb); grid on; ylim([-1.5 1.5])
title('Wideband FM, deviation 500 Hz (beta = 10)'); xlabel('Time (ms)')

%% Section 4 (RUN AND SEE) - the two spectra, and Carson checked
% What this block does: it takes the spectrum of both FM signals, counts
% how wide each one really is, and compares that with Carson's rule.
N     = length(s_nb);             % 400 samples
faxis = (0:N/2-1)*(Fs/N);         % 50 Hz per step
amp_nb = 2*abs(fft(s_nb))/N;  amp_nb = amp_nb(1:N/2);
amp_wb = 2*abs(fft(s_wb))/N;  amp_wb = amp_wb(1:N/2);
clf
subplot(2,1,1); plot(faxis, amp_nb, 'LineWidth', 1.5); grid on; xlim([0 2500])
title('Narrowband FM spectrum'); xlabel('Frequency (Hz)')
subplot(2,1,2); plot(faxis, amp_wb, 'LineWidth', 1.5); grid on; xlim([0 2500])
title('Wideband FM spectrum'); xlabel('Frequency (Hz)')
lines_nb = faxis(amp_nb > 0.1);
lines_wb = faxis(amp_wb > 0.1);
measured_nb = max(lines_nb) - min(lines_nb)      % measured width, narrowband
carson_nb   = 2*(dev_nb + fmes)                  % what Carson's rule predicts
measured_wb = max(lines_wb) - min(lines_wb)      % measured width, wideband
carson_wb   = 2*(dev_wb + fmes)                  % what Carson's rule predicts

%% Section 5 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - the deviation goes from 500 Hz down to
%       250 Hz - then run this section again. Work out Carson's answer in
%       your head BEFORE you run it, then check it against the measured
%       width that MATLAB prints.
dev_solo = 500;                   % <-- CHANGE 500 TO 250
s_solo   = cos(2*pi*fc*t + 2*pi*dev_solo*cumsum(m)/Fs);
amp_solo = 2*abs(fft(s_solo))/N;  amp_solo = amp_solo(1:N/2);
clf
plot(faxis, amp_solo, 'LineWidth', 1.5); grid on; xlim([0 2500])
xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('FM spectrum, deviation 250 Hz')
lines_solo   = faxis(amp_solo > 0.1);
measured_solo = max(lines_solo) - min(lines_solo)   % the measured width
carson_solo   = 2*(dev_solo + fmes)                 % Carson's prediction
beta_solo     = dev_solo / fmes                     % the modulation index
