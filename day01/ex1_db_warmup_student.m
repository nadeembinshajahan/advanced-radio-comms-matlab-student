%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 1 - Introduction to Wireless Communications
%  Exercise  : 1 - dB warm-up   *** STUDENT STARTER FILE ***
%  Teaches   : how to change power between milliwatts and dBm, and why a
%              chain of gains and losses becomes a simple ADDITION in dB.
%  Run time  : about 15 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is TYPE ALONG - you write it all yourself.
%  How to use: click inside a section and press Run Section, one at a time.
%              Fill in every line that says YOUR CODE HERE.
% ====================================================================

%% Section 1 (TYPE ALONG) - milliwatts to dBm
clear; clc;
P_mW  = [0.001 0.1 1 10 100 1000];   % six power levels, in milliwatts
P_dBm = 10*log10(P_mW);              % the dBm formula, done on the whole vector
disp('Power in dBm:')
disp(P_dBm)

%% Section 2 (TYPE ALONG) - go back from dBm to milliwatts, and check
% GAP 1: write the formula that turns dBm back into milliwatts.
% Hint: it is the dBm formula in reverse. Use ".^" and not "^".
P_back = % YOUR CODE HERE
check  = max(abs(P_back - P_mW))     % should print 0 (or a very tiny number)

%% Section 3 (TYPE ALONG) - a chain of 4 blocks: in dB you just add
Pin_dBm  = -10;                      % power going into the chain
blocks   = [20 -3 15 -6];            % amplifier, cable, amplifier, filter (dB)
% GAP 2: add the input power and all four blocks together.
% Hint: sum() adds up all the numbers in a vector. Leave the semicolon off.
Pout_dBm = % YOUR CODE HERE
Pout_mW  = 10.^(Pout_dBm/10)         % the same answer in milliwatts

%% Section 4 (TYPE ALONG) - draw the power level after each block
levels = [Pin_dBm, Pin_dBm + cumsum(blocks)];   % input level, then after each block
stairs(0:4, levels, 'LineWidth', 2)             % stairs = plot with square steps
grid on
xlabel('After block number'); ylabel('Power level (dBm)')
title('Power through the 4-block chain')

%% Section 5 (TYPE ALONG) - SOLO VARIATION
% Task: the input is now 0 dBm and a fifth block, a -20 dB attenuator,
%       is added at the end. What comes out, in dBm and in milliwatts?
% GAP 3: build the new block list and work out the output power.
Pin2_dBm  = 0;
blocks2   = % YOUR CODE HERE
Pout2_dBm = % YOUR CODE HERE
Pout2_mW  = % YOUR CODE HERE
