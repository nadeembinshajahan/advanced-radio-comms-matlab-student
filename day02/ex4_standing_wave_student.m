%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 2 - Electromagnetic Fundamentals
%  Exercise  : 4 - The standing wave on a mismatched line
%              *** STUDENT STARTER FILE ***
%  Teaches   : the reflected wave does not just disappear - it travels back
%              along the cable and adds to the forward wave. In some places
%              they help each other and in others they cancel, so the
%              voltage on the cable has fixed peaks and dips. The ratio of
%              the biggest peak to the smallest dip IS the VSWR.
%  Run time  : about 12 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is RUN AND SEE. There is nothing to type in
%              this file. Run each section and watch what happens.
%              In the solo task in Section 5 you change ONE number.
%  How to use: click inside a section and press Run Section, one at a time.
%              Run Section 1 first - every later section uses it.
% ====================================================================

%% Section 1 (RUN AND SEE) - two wavelengths of cable, three different loads
% What this block does: it sets up the cable and works out the reflection
% coefficient of three loads. Nothing is drawn yet.
clear; clc;
lambda = 1;                          % call one wavelength 1 metre, to keep it simple
beta   = 2*pi/lambda;                % how fast the wave phase turns with distance
z      = 0:0.001:2;                  % two wavelengths of cable, measured from the load
Z0     = 50;
ZL     = [50 100 200];               % matched, then 2:1 off, then 4:1 off
Gamma  = (ZL - Z0) ./ (ZL + Z0)      % 0, 0.3333 and 0.6

%% Section 2 (RUN AND SEE) - add the forward wave and the reflected wave
% What this block does: at every point on the cable it adds the wave going
% towards the load to the smaller wave coming back, then takes the size.
V1 = abs(exp(-1j*beta*z) + Gamma(1)*exp(1j*beta*z));   % 50 ohm load
V2 = abs(exp(-1j*beta*z) + Gamma(2)*exp(1j*beta*z));   % 100 ohm load
V3 = abs(exp(-1j*beta*z) + Gamma(3)*exp(1j*beta*z));   % 200 ohm load

%% Section 3 (RUN AND SEE) - the picture
% What this block does: it draws the three voltage patterns on one figure.
plot(z, V1, 'LineWidth', 2); hold on
plot(z, V2, 'LineWidth', 2)
plot(z, V3, 'LineWidth', 2); hold off
grid on; ylim([0 2])
xlabel('Distance back from the load (wavelengths)')
ylabel('Voltage size on the cable')
legend('ZL = 50 (matched)', 'ZL = 100 (VSWR 2)', 'ZL = 200 (VSWR 4)')
title('Standing wave on a mismatched line')

%% Section 4 (RUN AND SEE) - measure the pattern, then check the formula
% What this block does: it reads the highest and lowest voltage off each
% curve and divides one by the other. That ratio IS the VSWR.
measured = [max(V1)/min(V1), max(V2)/min(V2), max(V3)/min(V3)]
formula  = (1 + abs(Gamma)) ./ (1 - abs(Gamma))

%% Section 5 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - the 200 ohm load becomes 450 ohm - then
%       run this section again. Write down what happened to the peaks and
%       to the dips, and what the new peak-to-dip ratio is.
ZL4 = 200;                                        % <-- CHANGE 200 TO 450
G4  = (ZL4 - Z0) / (ZL4 + Z0);
V4  = abs(exp(-1j*beta*z) + G4*exp(1j*beta*z));
plot(z, V4, 'LineWidth', 2); grid on; ylim([0 2])
xlabel('Distance back from the load (wavelengths)')
ylabel('Voltage size on the cable')
title('A bigger mismatch')
peak_dip_ratio = [max(V4) min(V4) max(V4)/min(V4)]
