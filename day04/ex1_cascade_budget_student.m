%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 4 - Lesson 4 RF Components  (morning)
%  Exercise  : 1 - Cascade budget   *** STUDENT STARTER FILE ***
%  Teaches   : how to follow the signal level through a real receive
%              chain - LNA, filter, mixer, IF amplifier, cable - one
%              stage at a time, and why cumsum gives you the level at
%              every point in the chain, not just at the end.
%  Run time  : about 15 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is TYPE ALONG - you write it all yourself.
%  How to use: click inside a section and press Run Section, one at a time.
%              Fill in every line that says YOUR CODE HERE.
% ====================================================================

%% Section 1 (TYPE ALONG) - the receiver chain, stage by stage
clear; clc;
Pin_dBm = -80;                  % what the antenna hands to the receiver, dBm
stage   = [15 -2 -7 30 -4];     % LNA, filter, mixer, IF amp, cable (dB)
G_total = sum(stage)            % net gain of the whole chain, in dB

%% Section 2 (TYPE ALONG) - the running level after every stage
% GAP 1: build the list of levels. It starts with the input level, then
%        adds the stages one at a time.
% Hint: cumsum adds up a vector as it goes: cumsum([15 -2]) is [15 13].
level = % YOUR CODE HERE
disp('Gain or loss of each stage (dB):'); disp(stage)
disp('Level after each stage (dBm):');    disp(level(2:end))
budget = [stage; level(2:end)]'   % column 1 = stage dB, column 2 = level dBm

%% Section 3 (TYPE ALONG) - the output, in dBm and in milliwatts
Pout_dBm = level(end)           % the last number in the level list
% GAP 2: turn that dBm value into milliwatts.
% Hint: it is the dBm formula in reverse. Use ".^" and not "^".
Pout_mW  = % YOUR CODE HERE
G_ratio  = 10.^(G_total/10)     % the same gain as a plain multiplying factor

%% Section 4 (TYPE ALONG) - draw the level through the chain
stairs(0:5, level, 'LineWidth', 2)   % stairs = plot drawn with square steps
grid on
xlabel('After stage number'); ylabel('Level (dBm)')
title('Receiver chain: signal level after each stage')

%% Section 5 (TYPE ALONG) - SOLO VARIATION
% Task: the antenna is now 10 m away and the feeder cable to the LNA costs
%       3 dB. Add that loss as a NEW FIRST stage. What is the net gain now,
%       and what comes out of the chain in dBm and in milliwatts?
% GAP 3: build the new stage list and work the whole budget out again.
stage2 = % YOUR CODE HERE
level2 = % YOUR CODE HERE
G_total2  = % YOUR CODE HERE
Pout2_dBm = % YOUR CODE HERE
Pout2_mW  = % YOUR CODE HERE
penalty   = Pout2_dBm - Pout_dBm     % how much did that 3 dB of cable cost?
