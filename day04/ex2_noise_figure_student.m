%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 4 - Lesson 4 RF Components  (morning)
%  Exercise  : 2 - Noise figure of a cascade   *** STUDENT STARTER FILE ***
%  Teaches   : the Friis noise-figure formula. The FIRST stage sets the
%              noise figure of the whole receiver, because every stage
%              after it is divided by the gain in front of it. Put the
%              LNA second and the receiver gets dramatically worse.
%  Run time  : about 15 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : Sections 1-4 and 6 are TYPE ALONG - fill in the gaps.
%              Section 5 is RUN AND SEE - it is already complete.
%              Do NOT type it. Just run it and watch what happens.
%  How to use: click inside a section and press Run Section, one at a time.
%              Run Section 1 first - every later section uses its numbers.
% ====================================================================

%% Section 1 (TYPE ALONG) - the three stages, in dB and as plain ratios
clear; clc;
NF_lna = 1.5;   G_lna = 15;     % low-noise amplifier
NF_mix = 8;     G_mix = -7;     % mixer: it LOSES 7 dB, so the gain is negative
NF_if  = 6;     G_if  = 30;     % IF amplifier
F_lna = 10.^(NF_lna/10);   g_lna = 10.^(G_lna/10);   % noise FACTOR and gain
F_mix = 10.^(NF_mix/10);   g_mix = 10.^(G_mix/10);   % as plain numbers,
F_if  = 10.^(NF_if/10);    g_if  = 10.^(G_if/10);    % never in dB

%% Section 2 (TYPE ALONG) - Friis: LNA first (the right way round)
% GAP 1: write the Friis formula for the order LNA, mixer, IF amp.
% Hint:  F = F1 + (F2-1)/g1 + (F3-1)/(g1*g2)
%        Every stage is divided by ALL the gain sitting in front of it.
F_A  = % YOUR CODE HERE
NF_A = 10*log10(F_A)            % back into dB

%% Section 3 (TYPE ALONG) - now swap the first two: mixer first, LNA second
% GAP 2: same formula, but the mixer is stage 1 and the LNA is stage 2.
F_B  = % YOUR CODE HERE
NF_B = 10*log10(F_B)
penalty = NF_B - NF_A           % how much the wrong order costs you

%% Section 4 (TYPE ALONG) - what that costs at the antenna
B_Hz = 1e6;                     % receiver bandwidth: 1 MHz
N_th = -174 + 10*log10(B_Hz)    % thermal noise in that bandwidth, dBm
N_A  = N_th + NF_A              % noise floor with the LNA first
N_B  = N_th + NF_B              % noise floor with the LNA second

%% Section 5 (RUN AND SEE) - how much LNA gain is enough?
% What this block does: it runs the same Friis formula again for every LNA
% gain from 0 to 30 dB and draws the answer, so you can watch the cascade
% noise figure fall towards the LNA's own 1.5 dB and then stop improving.
G1_dB  = 0:0.5:30;
g1     = 10.^(G1_dB/10);
F_tot  = F_lna + (F_mix-1)./g1 + (F_if-1)./(g1*g_mix);
NF_tot = 10*log10(F_tot);
plot(G1_dB, NF_tot, 'LineWidth', 2); grid on
xlabel('LNA gain (dB)'); ylabel('Cascade noise figure (dB)')
title('Why the LNA needs gain, not just a low noise figure')
yline(NF_lna, '--r');           % the floor: the LNA's own noise figure
xline(15, ':k');                % the gain we used in Section 2

%% Section 6 (TYPE ALONG) - SOLO VARIATION
% Task: a better LNA arrives - noise figure 1.0 dB and gain 20 dB. Nothing
%       else changes. What is the cascade noise figure now, and how many dB
%       better is that than the answer in Section 2?
% GAP 3: build the new LNA numbers and run Friis one more time.
F_lna2 = % YOUR CODE HERE
g_lna2 = % YOUR CODE HERE
F_new  = % YOUR CODE HERE
NF_new = 10*log10(F_new)
saved  = NF_A - NF_new
