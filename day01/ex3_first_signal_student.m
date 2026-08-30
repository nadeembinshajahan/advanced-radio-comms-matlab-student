%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 1 - Introduction to Wireless Communications
%  Exercise  : 3 - Your first signal   *** STUDENT STARTER FILE ***
%  Teaches   : how to build a time vector, how amplitude / frequency /
%              phase change a sine, and how the FFT shows which
%              frequencies are inside a signal.
%  Run time  : about 18 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : Sections 1-2 are TYPE ALONG - fill in the YOUR CODE HERE gaps.
%              Sections 3-5 are RUN AND SEE - they are already complete.
%              Do NOT type them. Just run them and watch what happens.
%  How to use: click inside a section and press Run Section, one at a time.
%  IMPORTANT : run Section 3 before Section 4 - Section 4 uses its signal.
% ====================================================================

%% Section 1 (TYPE ALONG) - one sine wave
clear; clc;
Fs  = 1000;                       % sample rate: 1000 samples every second
t   = 0:1/Fs:0.2;                 % time from 0 to 0.2 s -> 201 samples
f = 25;   A = 2;   phi = 0;       % frequency (Hz), amplitude, phase (radians)
% GAP 1: build the sine wave from A, f, phi and t.
% Hint: the formula is A*sin(2*pi*f*t + phi).
x   = % YOUR CODE HERE
plot(t, x, 'LineWidth', 1.5); grid on
xlabel('Time (s)'); ylabel('Amplitude'); title('One sine wave')

%% Section 2 (TYPE ALONG) - change f, A and phi, then run this section again
% GAP 2: double the frequency, halve the amplitude, and start at the top
%        of the wave instead of at zero (phase = pi/2).
f = % YOUR CODE HERE
A = % YOUR CODE HERE
phi = % YOUR CODE HERE
x   = A*sin(2*pi*f*t + phi);
plot(t, x, 'LineWidth', 1.5); grid on
xlabel('Time (s)'); ylabel('Amplitude'); title('Changed f, A and phi')

%% Section 3 (RUN AND SEE) - two tones added together
% What this block does: it adds a 100 Hz wave and a smaller 250 Hz wave
% together, and draws the result. Just run it and look at the shape.
Fs = 1000;
t  = 0:1/Fs:1-1/Fs;          % exactly 1000 samples = 1 second
x  = sin(2*pi*100*t) + 0.5*sin(2*pi*250*t);
plot(t(1:100), x(1:100), 'LineWidth', 1.5); grid on
xlabel('Time (s)'); ylabel('Amplitude'); title('100 Hz + 250 Hz added together')

%% Section 4 (RUN AND SEE) - the spectrum: what is inside the signal?
% What this block does: fft asks "which frequencies are inside x?" and the
% plot shows the answer. Two spikes = two tones. Just run it.
N     = length(x);           % 1000 samples
X     = abs(fft(x))/N;       % size of every frequency component
amp   = 2*X(1:N/2);          % keep the first half only, and double it
faxis = (0:N/2-1)*(Fs/N);    % the matching frequency axis, in Hz
plot(faxis, amp, 'LineWidth', 1.5); grid on
xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Spectrum: two lines, nothing else')

%% Section 5 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - the 250 becomes 300 - then run this
%       section again. Write down where the second spike ends up and how
%       tall it is. Does the 100 Hz spike change at all?
x     = sin(2*pi*100*t) + 0.5*sin(2*pi*250*t);   % <-- CHANGE 250 TO 300
amp   = 2*abs(fft(x))/N;
amp   = amp(1:N/2);
plot(faxis, amp, 'LineWidth', 1.5); grid on
xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Second tone moved')
