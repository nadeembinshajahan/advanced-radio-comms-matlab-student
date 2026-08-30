%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 2 - Electromagnetic Fundamentals
%  Exercise  : 5 - The wave in space, and how it weakens with distance
%              *** STUDENT STARTER FILE ***
%  Teaches   : two pictures that go with the Pluto demo. First, what a
%              radio wave looks like laid out in SPACE, and how much
%              shorter it gets when the frequency goes up. Second, how
%              fast the signal weakens in clear air as you walk away.
%              Clear air only - buildings and reflections come in Lesson 6.
%  Run time  : about 12 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is RUN AND SEE. There is nothing to type in
%              this file. Run each section and watch what happens.
%              In the solo task in Section 5 you change ONE number.
%  How to use: click inside a section and press Run Section, one at a time.
%              Run Section 1 first - every later section uses it.
% ====================================================================

%% Section 1 (RUN AND SEE) - a snapshot of the wave in space
% What this block does: it freezes time and draws the wave along 10 metres
% of open space, for two different frequencies.
clear; clc;
c    = 3e8;                          % speed of light, metres per second
x    = 0:0.01:10;                    % 10 metres of space, 1 cm at a time
f1   = 100e6;   f2 = 300e6;          % 100 MHz and 300 MHz
lam1 = c/f1;    lam2 = c/f2;         % their wavelengths, in metres
y1   = cos(2*pi*x/lam1);             % the slower wave
y2   = cos(2*pi*x/lam2);             % the faster wave
plot(x, y1, 'LineWidth', 2); hold on
plot(x, y2, 'LineWidth', 2); hold off
grid on
xlabel('Distance through space (m)'); ylabel('Field strength')
legend('100 MHz  (lambda = 3 m)', '300 MHz  (lambda = 1 m)')
title('One snapshot of the wave in space')

%% Section 2 (RUN AND SEE) - the two wavelengths, in numbers
% What this block does: it prints the two wavelengths and counts how many
% whole waves fit inside the 10 metres you can see on the plot.
wavelengths   = [lam1 lam2]
cycles_in_10m = 10 ./ wavelengths

%% Section 3 (RUN AND SEE) - free-space path loss, 1 metre to 10 kilometres
% What this block does: it works out how much weaker a signal gets with
% distance in CLEAR AIR, for two bands, and draws it on a log distance axis.
d     = logspace(0, 4, 200);         % 200 distances, from 1 m to 10 000 m
fa    = 2.4e9;   fb = 100e6;         % 2.4 GHz (Wi-Fi) and 100 MHz (FM band)
FSPLa = 20*log10(4*pi*d*fa/c);       % free-space path loss at 2.4 GHz, in dB
FSPLb = 20*log10(4*pi*d*fb/c);       % the same at 100 MHz
semilogx(d, FSPLa, 'LineWidth', 2); hold on
semilogx(d, FSPLb, 'LineWidth', 2); hold off
grid on
xlabel('Distance (m)'); ylabel('Free-space path loss (dB)')
legend('2.4 GHz', '100 MHz', 'Location', 'northwest')
title('Free-space path loss vs distance (clear air only)')

%% Section 4 (RUN AND SEE) - read the loss off at four distances
% What this block does: it prints the path loss at 1 m, 100 m, 1 km and
% 10 km, so nobody has to read it off the picture by eye.
dcheck    = [1 100 1000 10000];
loss_2G4  = 20*log10(4*pi*dcheck*fa/c)
loss_100M = 20*log10(4*pi*dcheck*fb/c)
gap       = loss_2G4 - loss_100M

%% Section 5 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - 2.4e9 becomes 5.8e9 - then run this
%       section again. Predict FIRST: is 5.8 GHz better or worse than
%       2.4 GHz over the same distance, and by roughly how many dB?
fc       = 2.4e9;                          % <-- CHANGE 2.4e9 TO 5.8e9
loss_5G8 = 20*log10(4*pi*dcheck*fc/c)
step_up  = loss_5G8 - loss_2G4
