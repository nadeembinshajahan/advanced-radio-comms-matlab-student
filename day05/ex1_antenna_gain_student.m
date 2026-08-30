%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 5 - Lesson 5 Antennas and RF Systems  (Friday half day)
%  Exercise  : 1 - Antenna gain arithmetic   *** STUDENT STARTER FILE ***
%  Teaches   : the three gain sums an RF engineer does every day. dBi and
%              dBd are the same gain measured against different reference
%              antennas. A dish's gain comes from its area. EIRP is what
%              the transmitter looks like from far away.
%  Run time  : about 13 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is TYPE ALONG - you write it all yourself.
%  How to use: click inside a section and press Run Section, one at a time.
%              Fill in every line that says YOUR CODE HERE.
% ====================================================================

%% Section 1 (TYPE ALONG) - dBi and dBd: one gain, two reference antennas
clear; clc;
G_dBd = [0 2 9 12];             % four antenna gains, quoted against a dipole
% GAP 1: turn all four gains into dBi in one line.
% Hint: a dipole is 2.15 dB better than an isotropic radiator.
G_dBi = % YOUR CODE HERE

%% Section 2 (TYPE ALONG) - the gain of a dish comes from its area
c   = 3e8;
f   = 10e9;                     % 10 GHz
lam = c/f;                      % wavelength: 0.03 m
D   = 0.6;                      % dish diameter, in metres
eta = 0.55;                     % efficiency: only 55 % of the area really works
A   = pi*(D/2)^2                % area of the dish mouth, m^2
% GAP 2: work out the gain of the dish as a plain number.
% Hint: G = efficiency * 4 * pi * area / wavelength squared.
G_lin  = % YOUR CODE HERE
G_dish = 10*log10(G_lin)        % the same gain in dBi

%% Section 3 (TYPE ALONG) - EIRP: what the transmitter looks like from far away
Pt = 30;                        % transmitter power: 30 dBm = 1 watt
Lf = 2.5;                       % feeder and connector loss, dB
G  = [0 6 11.15 G_dish];        % isotropic, patch, Yagi (9 dBd), dish
% GAP 3: work out the EIRP of all four antennas in ONE line.
% Hint: EIRP = transmitter power + antenna gain - feeder loss.
EIRP = % YOUR CODE HERE
EIRP_yagi_W = 10.^((EIRP(3)-30)/10)   % the Yagi case, in watts
EIRP_dish_W = 10.^((EIRP(4)-30)/10)   % the dish case, in watts

%% Section 4 (TYPE ALONG) - SOLO VARIATION
% Task: the 0.6 m dish is replaced by a 1.2 m dish - twice the diameter,
%       same frequency, same efficiency. How much gain do you win, and what
%       is the new EIRP? Guess the gain step before you run it.
% GAP 4: work out the new area, the new gain, the gain step and the new EIRP.
D2 = 1.2;
A2 = % YOUR CODE HERE
G_dish2 = % YOUR CODE HERE
step_up = % YOUR CODE HERE
EIRP2   = % YOUR CODE HERE
