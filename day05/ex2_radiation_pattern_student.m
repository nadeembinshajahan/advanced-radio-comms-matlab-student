%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 5 - Lesson 5 Antennas and RF Systems  (Friday half day)
%  Exercise  : 2 - Radiation patterns   *** STUDENT STARTER FILE ***
%  Teaches   : what a radiation pattern picture means, how to read the
%              half-power beamwidth off it, and what front-to-back ratio
%              tells you. An isotropic radiator is a circle. A dipole is
%              a figure of eight. A directional antenna is one big lobe.
%  Run time  : about 13 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is RUN AND SEE. There is nothing to type in
%              this file. Run each section and watch what happens.
%              In the solo task in Section 5 you change ONE number.
%  How to use: click inside a section and press Run Section, one at a time.
%              Run Section 1 first - every later section uses its patterns.
% ====================================================================

%% Section 1 (RUN AND SEE) - the angles and the three patterns
% What this block does: it builds one full circle of angles and works out
% how strongly three antennas radiate at every angle. The angles start at
% 0.05 degrees, not 0, because the dipole formula divides by sin(angle) and
% we must never divide by exactly zero. Nothing prints yet.
clear; clc;
th_deg = 0.05:0.1:359.95;                 % 3600 angles right round the circle
th     = th_deg*pi/180;                   % the same angles in radians
iso    = ones(size(th));                  % isotropic: the same in every direction
dip    = abs(cos(pi/2*cos(th))./sin(th)); % half-wave dipole
dip    = dip/max(dip);                    % normalise so the peak is exactly 1
b      = 0.1;                             % size of the back lobe (10 per cent)
yagi   = b + (1-b)*abs(cos((th-pi/2)/2)).^6;   % a directional antenna
yagi   = yagi/max(yagi);                  % normalise this one too

%% Section 2 (RUN AND SEE) - draw all three on one polar plot
% What this block does: polarplot draws each pattern round a circle. Look
% at the shapes before you look at any numbers.
polarplot(th, iso, '--', 'LineWidth', 1.5); hold on
polarplot(th, dip, 'LineWidth', 2)
polarplot(th, yagi, 'LineWidth', 2)
hold off
legend('Isotropic', 'Half-wave dipole', 'Directional', 'Location', 'southoutside')
title('Normalised radiation patterns')

%% Section 3 (RUN AND SEE) - read the beamwidth off the dipole
% What this block does: it finds every angle in the top half of the circle
% where the dipole is at or above 0.7071 of its peak. That level is -3 dB,
% so the width between the first and the last of those angles is the
% half-power beamwidth.
half  = 1/sqrt(2);                        % 0.7071 in amplitude = -3 dB
k     = find(dip >= half & th_deg < 180);
edge1 = th_deg(k(1))                      % where the main lobe starts
edge2 = th_deg(k(end))                    % where it ends
hpbw_dipole = edge2 - edge1               % the half-power beamwidth, degrees

%% Section 4 (RUN AND SEE) - beamwidth and front-to-back of the directional one
% What this block does: the same beamwidth measurement on the directional
% antenna, then front-to-back - how much weaker the antenna is behind it
% than in front of it. A dipole has no front and no back; this one does.
k2 = find(yagi >= half & th_deg < 180);
hpbw_yagi = th_deg(k2(end)) - th_deg(k2(1))
i90  = find(th_deg > 90,  1);             % straight ahead (the main lobe)
i270 = find(th_deg > 270, 1);             % straight behind
FtoB        = 20*log10(yagi(i90)/yagi(i270))   % front-to-back, in dB
FtoB_dipole = 20*log10(dip(i90)/dip(i270))     % the dipole, for comparison

%% Section 5 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - the back lobe b goes from 0.1 down to
%       0.03 - then run this section again. Write down two answers: what
%       happens to the front-to-back figure? what happens to the beamwidth?
b     = 0.1;                              % <-- CHANGE 0.1 TO 0.03
yagi2 = b + (1-b)*abs(cos((th-pi/2)/2)).^6;
yagi2 = yagi2/max(yagi2);
polarplot(th, yagi2, 'LineWidth', 2)
title('Directional antenna with a smaller back lobe')
k3    = find(yagi2 >= half & th_deg < 180);
hpbw2 = th_deg(k3(end)) - th_deg(k3(1))
FtoB2 = 20*log10(yagi2(i90)/yagi2(i270))
