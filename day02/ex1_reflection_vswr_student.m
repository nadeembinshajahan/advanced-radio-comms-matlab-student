%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 2 - Electromagnetic Fundamentals
%  Exercise  : 1 - Reflection coefficient, VSWR and return loss
%              *** STUDENT STARTER FILE ***
%  Teaches   : what happens when the antenna impedance does not equal the
%              cable impedance. Gamma says how much of the wave bounces
%              back, VSWR is the same fact written as a ratio, and return
%              loss is the same fact written in dB.
%  Run time  : about 15 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is TYPE ALONG - you write it all yourself.
%  How to use: click inside a section and press Run Section, one at a time.
%              Fill in every line that says YOUR CODE HERE.
% ====================================================================

%% Section 1 (TYPE ALONG) - the reflection coefficient
clear; clc;
Z0    = 50;                          % the radio and cable impedance, in ohms
ZL    = [25 50 75 100 200];          % five different antennas/loads, in ohms
% GAP 1: work out Gamma for all five loads in one line.
% Hint: Gamma = (ZL - Z0) divided by (ZL + Z0). ZL is a vector, so use "./".
Gamma = % YOUR CODE HERE
disp('Reflection coefficient Gamma:')
disp(Gamma)

%% Section 2 (TYPE ALONG) - how big is the bounce, and what is the VSWR?
Gmag = abs(Gamma);                   % size of the reflection, sign thrown away
% GAP 2: turn |Gamma| into VSWR.
% Hint: VSWR = (1 + Gmag) divided by (1 - Gmag). Use "./" again.
VSWR = % YOUR CODE HERE
disp('|Gamma|:');  disp(Gmag)
disp('VSWR:');     disp(VSWR)

%% Section 3 (TYPE ALONG) - the same fact written in dB
% GAP 3: return loss says how far DOWN the reflection is, in dB.
% Hint: it is minus 20 times log10 of Gmag.
RL_dB = % YOUR CODE HERE
disp('Return loss (dB):')
disp(RL_dB)

%% Section 4 (TYPE ALONG) - draw the VSWR of the five loads
% GAP 4: draw one stick per load, VSWR up the side and ZL along the bottom.
% Hint: the command is stem(ZL, VSWR, 'filled', 'LineWidth', 1.5)
% YOUR CODE HERE
grid on
xlabel('Load resistance (ohms)'); ylabel('VSWR')
title('VSWR of five loads on a 50 ohm system')

%% Section 5 (TYPE ALONG) - SOLO VARIATION
% Task: two more loads - 12.5 ohm and 300 ohm. Work out Gamma, VSWR and
%       return loss for both. Which one is worse? Leave the semicolons off
%       so that MATLAB prints the answers.
% GAP 5: build the new load list, then the three results.
ZL2     = % YOUR CODE HERE
Gamma2  = % YOUR CODE HERE
VSWR2   = % YOUR CODE HERE
RL2_dB  = % YOUR CODE HERE
