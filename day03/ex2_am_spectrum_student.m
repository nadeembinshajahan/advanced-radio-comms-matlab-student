%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 3 - Modulation Techniques
%  Exercise  : 2 - The AM spectrum   *** STUDENT STARTER FILE ***
%  Teaches   : an AM signal is not one frequency. It is THREE: the
%              carrier in the middle and one sideband on each side, each
%              sitting exactly the message frequency away. So the
%              bandwidth of AM is 2 x the message frequency. It also
%              shows where the power goes: most of it is wasted in the
%              carrier, which carries no information at all.
%  Run time  : about 12 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is RUN AND SEE. There is nothing to type in
%              this file. Run each section and watch what happens.
%              In the solo task in Section 5 you change ONE number.
%  How to use: click inside a section and press Run Section, one at a time.
%              Run Section 1 first - every later section uses its signal.
% ====================================================================

%% Section 1 (RUN AND SEE) - build the same AM signal, but longer
% What this block does: it rebuilds the Exercise 1 signal with mu = 0.5
% over a longer window, so the FFT has enough samples to work with.
clear; clc;
Fs = 20000;                  % 20 000 samples every second
t  = 0:1/Fs:0.1-1/Fs;        % exactly 2000 samples = 0.1 second
fm = 100;                    % message tone, Hz
fc = 1000;                   % carrier, Hz
mu = 0.5;                    % modulation index
m  = cos(2*pi*fm*t);
c  = cos(2*pi*fc*t);
s  = (1 + mu*m) .* c;        % the AM signal

%% Section 2 (RUN AND SEE) - the spectrum: three lines, not one
% What this block does: fft asks "which frequencies are inside s?" and
% the plot shows the answer. Look for how many lines there are.
N     = length(s);           % 2000 samples
amp   = 2*abs(fft(s))/N;     % size of every frequency component
amp   = amp(1:N/2);          % keep the first half only
faxis = (0:N/2-1)*(Fs/N);    % matching frequency axis, 10 Hz per step
plot(faxis, amp, 'LineWidth', 1.5); grid on
xlim([800 1200])             % zoom in around the carrier
xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('AM spectrum: carrier + 2 sidebands')

%% Section 3 (RUN AND SEE) - read the three lines and the bandwidth
% What this block does: it prints every frequency whose line is taller
% than 0.05, then works out the bandwidth from the answer.
spikes  = faxis(amp > 0.05)       % three frequencies will print here
BW      = max(spikes) - min(spikes)
BW_rule = 2*fm                       % the rule: bandwidth = 2 x message frequency

%% Section 4 (RUN AND SEE) - where does the power go?
% What this block does: it measures the total power in the signal, takes
% away the carrier power, and shows what fraction is left for the two
% sidebands. Only the sidebands carry the message.
Ptot = mean(s.^2)                 % total power in the AM signal
Pcar = 0.5                        % power of the carrier on its own
side_fraction = (Ptot - Pcar)/Ptot     % the useful share of the power

%% Section 5 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - mu goes from 0.5 to 1.0 - then run this
%       section again. Write down the answers to two questions:
%       (a) do the two sidebands get TALLER?
%       (b) does the BANDWIDTH get WIDER?
mu    = 0.5;                 % <-- CHANGE 0.5 TO 1.0
s     = (1 + mu*m) .* c;
amp   = 2*abs(fft(s))/N;
amp   = amp(1:N/2);
plot(faxis, amp, 'LineWidth', 1.5); grid on
xlim([800 1200])
xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('AM spectrum at the new mu')
spikes  = faxis(amp > 0.05)
BW      = max(spikes) - min(spikes)
Ptot  = mean(s.^2)
side_fraction = (Ptot - 0.5)/Ptot
