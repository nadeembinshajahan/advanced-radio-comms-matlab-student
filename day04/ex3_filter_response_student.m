%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 4 - Lesson 4 RF Components  (morning)
%  Exercise  : 3 - Filter response   *** STUDENT STARTER FILE ***
%  Teaches   : what a filter data sheet is actually describing. The
%              response is built here from one formula - no toolbox - so
%              you can see where the -3 dB point is, how fast the skirt
%              falls, and that insertion loss shifts the WHOLE curve down.
%  Run time  : about 12 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is RUN AND SEE. There is nothing to type in
%              this file. Run each section and watch what happens.
%              In the solo task in Section 4 you change ONE number.
%  How to use: click inside a section and press Run Section, one at a time.
%              Run Section 1 first - every later section uses its numbers.
% ====================================================================

%% Section 1 (RUN AND SEE) - build the filter response
% What this block does: it works out how much a 3-pole low-pass filter lets
% through at 401 frequencies from 1 MHz to 10 GHz. The response is a single
% formula, so no Signal Processing Toolbox is needed. Nothing prints yet.
clear; clc;
fc = 100e6;                 % cut-off frequency: 100 MHz
n  = 3;                     % number of poles: this sets how steep the skirt is
IL = 1.5;                   % insertion loss in the passband, in dB
f  = logspace(6, 10, 401);                      % 1 MHz to 10 GHz, log spaced
mag_dB = -IL - 10*log10(1 + (f/fc).^(2*n));     % the whole response, in dB

%% Section 2 (RUN AND SEE) - draw it, and mark the -3 dB line
% What this block does: it draws the response on a log frequency axis and
% adds two guide lines - the cut-off frequency and the -3 dB level.
semilogx(f, mag_dB, 'LineWidth', 2); grid on
ylim([-120 5])
xlabel('Frequency (Hz)'); ylabel('Response (dB)')
title('Filter magnitude response: 3 poles, 100 MHz cut-off')
passband_dB = max(mag_dB)       % the flat level in the passband
yline(passband_dB - 3, '--r');  % -3 dB measured DOWN FROM the passband level
xline(fc, ':k');                % the cut-off frequency

%% Section 3 (RUN AND SEE) - read the numbers off the curve
% What this block does: it finds the first frequency where the curve has
% dropped 3 dB below the passband, then prints the response at six useful
% frequencies and measures the roll-off over one decade.
k    = find(mag_dB <= passband_dB - 3, 1);   % first point at or past -3 dB
f3dB = f(k)                                  % the cut-off, read off the curve
f_check   = [10e6 50e6 100e6 200e6 1e9 10e9];
mag_check = -IL - 10*log10(1 + (f_check/fc).^(2*n));
disp('Check frequencies (MHz):'); disp(f_check/1e6)
disp('Response there (dB):');     disp(mag_check)
rolloff = mag_check(5) - mag_check(6)        % dB lost per decade of frequency

%% Section 4 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - the filter is built with 5 poles instead
%       of 3 - then run this section again. Write down two answers: does the
%       cut-off frequency move? does the skirt get steeper?
n = 3;                                       % <-- CHANGE 3 TO 5
mag_dB = -IL - 10*log10(1 + (f/fc).^(2*n));
semilogx(f, mag_dB, 'LineWidth', 2); grid on; ylim([-120 5])
xlabel('Frequency (Hz)'); ylabel('Response (dB)')
title('Same filter, now with 5 poles')
k    = find(mag_dB <= max(mag_dB) - 3, 1);
f3dB = f(k)
mag_check = -IL - 10*log10(1 + (f_check/fc).^(2*n));
rolloff   = mag_check(5) - mag_check(6)      % dB per decade - write it down
