%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 1 - Introduction to Wireless Communications
%  Exercise  : 4 - The one-line mixer   *** STUDENT STARTER FILE ***
%  Teaches   : a mixer just MULTIPLIES two signals, and multiplying two
%              sine waves creates two brand-new frequencies: the sum and
%              the difference. This is how every radio changes frequency.
%  Run time  : about 10 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is RUN AND SEE. There is nothing to type in
%              this file. Run each section and watch what happens.
%              In the solo task at the end you change ONE number.
%  How to use: click inside a section and press Run Section, one at a time.
% ====================================================================

%% Section 1 (RUN AND SEE) - the two inputs
% What this block does: it makes two sine waves - the wanted signal at
% 1000 Hz and the radio's own oscillator at 1200 Hz. Nothing prints yet.
clear; clc;
Fs = 10000;                  % 10 000 samples every second
t  = 0:1/Fs:0.1-1/Fs;        % exactly 1000 samples = 0.1 second
x1 = sin(2*pi*1000*t);       % the wanted signal ("RF"), 1000 Hz
x2 = sin(2*pi*1200*t);       % the local oscillator ("LO"), 1200 Hz

%% Section 2 (RUN AND SEE) - the mixer: one line
% What this block does: it multiplies the two waves together, sample by
% sample, and draws the result. That single line IS the mixer.
x = x1 .* x2;                % ".*" multiplies sample by sample
plot(t(1:500), x(1:500)); grid on
xlabel('Time (s)'); ylabel('Amplitude'); title('Mixer output in time')

%% Section 3 (RUN AND SEE) - the spectrum shows the two NEW frequencies
% What this block does: it asks which frequencies are now inside the
% mixer output. Look for what is there - and for what has vanished.
N     = length(x);
amp   = 2*abs(fft(x))/N;
amp   = amp(1:N/2);
faxis = (0:N/2-1)*(Fs/N);    % frequency axis, 0 to 4990 Hz in 10 Hz steps
plot(faxis, amp, 'LineWidth', 1.5); grid on
xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Sum and difference frequencies')

%% Section 4 (RUN AND SEE) - read the peaks off automatically
% What this block does: it prints every frequency whose spike is taller
% than 0.1, so you do not have to read them off the picture by eye.
peaks = faxis(amp > 0.1)     % two frequencies will print here

%% Section 5 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - the oscillator moves from 1200 Hz to
%       1500 Hz - then run this section again. Write down the two peaks
%       you EXPECT before you run it, then check whether you were right.
x2    = sin(2*pi*1200*t);    % <-- CHANGE 1200 TO 1500
x     = x1 .* x2;
amp   = 2*abs(fft(x))/N;
amp   = amp(1:N/2);
peaks = faxis(amp > 0.1)
