%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 2 - Electromagnetic Fundamentals
%  Exercise  : 2 - Impedance mismatch loss   *** STUDENT STARTER FILE ***
%  Teaches   : a reflection is wasted power. This exercise turns Gamma
%              into the two numbers an engineer actually cares about:
%              how much power reaches the antenna, and how many dB were
%              thrown away getting it there.
%  Run time  : about 14 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is TYPE ALONG - you write it all yourself.
%  How to use: click inside a section and press Run Section, one at a time.
%              Fill in every line that says YOUR CODE HERE.
% ====================================================================

%% Section 1 (TYPE ALONG) - how much power comes back?
clear; clc;
Z0    = 50;                                 % system impedance, in ohms
ZL    = [25 50 75 100 200];                 % the same five loads as Exercise 1
Gmag  = abs((ZL - Z0) ./ (ZL + Z0));        % size of the reflection
% GAP 1: reflected POWER is the reflected voltage squared.
% Hint: Gmag is a vector, so use ".^" and not "^".
Prefl = % YOUR CODE HERE
Pdel  = 1 - Prefl;                          % what is left over reaches the antenna
disp('Fraction reflected:'); disp(Prefl)
disp('Fraction delivered:'); disp(Pdel)

%% Section 2 (TYPE ALONG) - the same thing as a percentage and as dB
pct_del = 100 * Pdel;                       % per cent of the power delivered
% GAP 2: write the delivered fraction as a loss in dB.
% Hint: it is minus 10 times log10 of Pdel. Power uses 10, not 20.
loss_dB = % YOUR CODE HERE
disp('Per cent delivered:'); disp(pct_del)
disp('Mismatch loss (dB):'); disp(loss_dB)

%% Section 3 (TYPE ALONG) - sweep every load from 5 to 500 ohms
ZL_sweep   = 5:1:500;                       % 496 load values, one ohm apart
G_sweep    = abs((ZL_sweep - Z0) ./ (ZL_sweep + Z0));
% GAP 3: the loss at every load in the sweep - the same formula as Section 2.
loss_sweep = % YOUR CODE HERE
% GAP 4: plot it with a log scale along the bottom axis.
% Hint: the command is semilogx(ZL_sweep, loss_sweep, 'LineWidth', 2)
% YOUR CODE HERE
grid on
xlabel('Load resistance (ohms)'); ylabel('Mismatch loss (dB)')
title('Power lost to mismatch vs load resistance')

%% Section 4 (TYPE ALONG) - SOLO VARIATION
% Task: the two ends of the sweep, 5 ohm and 500 ohm. How much power gets
%       through, and how many dB are lost? Are the two answers the same?
%       Leave the semicolons off so MATLAB prints the answers.
% GAP 5: build the new load list, then the four results.
ZL3    = % YOUR CODE HERE
G3     = % YOUR CODE HERE
Pdel3  = % YOUR CODE HERE
loss3  = % YOUR CODE HERE
VSWR3  = % YOUR CODE HERE
