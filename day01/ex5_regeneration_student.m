%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 1 - Introduction to Wireless Communications
%  Exercise  : 5 - Analog repeater vs digital regenerator (4 hops)
%              *** STUDENT STARTER FILE ***
%  Teaches   : an analog repeater amplifies the noise together with the
%              signal, so the noise piles up hop after hop. A digital
%              repeater DECIDES the bit again at every hop, so the signal
%              comes out perfectly clean - until the SNR drops below the
%              threshold, and then it fails suddenly. That sudden failure
%              is called the THRESHOLD CLIFF.
%  Run time  : about 15 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is RUN AND SEE. There is nothing to type in
%              this file. Run each section and watch what happens.
%              In the solo task in Section 5 you change ONE number.
%  How to use: click inside a section and press Run Section, one at a time.
%              Run Section 1 first - every later section uses its bits.
% ====================================================================

%% Section 1 (RUN AND SEE) - make the transmitted signal
% What this block does: it makes 2000 random bits and sends them as
% voltages: +1 volt for a 1, and -1 volt for a 0. Nothing prints.
clear; clc;
rng(1);                        % same random numbers every time you run it
N    = 2000;                   % number of bits
bits = randi([0 1], 1, N);     % random 0s and 1s
x    = 2*bits - 1;             % send +1 for a 1, and -1 for a 0

%% Section 2 (RUN AND SEE) - four ANALOG hops: the noise piles up
% What this block does: it sends the signal through 4 analog repeaters.
% Each one adds new noise on top of the noise that is already there.
snr_dB = 12;                   % signal-to-noise ratio on each hop
sigma  = 10.^(-snr_dB/20);     % the matching noise level (0.2512)
a = x;
for k = 1:4
    a = a + sigma*randn(1,N);  % new noise on top of the old noise
end

%% Section 3 (RUN AND SEE) - four DIGITAL hops: clean up at every repeater
% What this block does: the same 4 hops, with one word added - sign().
% Each repeater decides "is this above zero or below zero?" and sends a
% brand-new clean +1 or -1. The old noise is thrown away.
d = x;
for k = 1:4
    d = sign(d + sigma*randn(1,N));   % add noise, then decide the bit again
end

%% Section 4 (RUN AND SEE) - look at the two outputs and count the errors
% What this block does: it draws both signals after 4 hops and counts how
% many bits came out wrong. This is the whole point of the exercise.
subplot(2,1,1); plot(a(1:100)); ylim([-3 3]); grid on
title('Analog after 4 hops - noise everywhere')
subplot(2,1,2); plot(d(1:100)); ylim([-3 3]); grid on
title('Digital after 4 hops - perfectly clean')
err_analog  = sum(sign(a) ~= x)      % roughly 45 bad bits out of 2000 (30 to 70 is normal)
err_digital = sum(d ~= x)            % 0 bad bits, sometimes 1 or 2

%% Section 5 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - the SNR goes from 12 dB down to 6 dB -
%       then run this section and write down what changed. Two questions:
%       is the digital plot still clean? Is it still CORRECT?
snr_dB = 12;                   % <-- CHANGE 12 TO 6
sigma  = 10.^(-snr_dB/20);
a = x;  d = x;
for k = 1:4
    a = a + sigma*randn(1,N);
    d = sign(d + sigma*randn(1,N));
end
subplot(2,1,1); plot(a(1:100)); ylim([-3 3]); grid on; title('Analog at 6 dB')
subplot(2,1,2); plot(d(1:100)); ylim([-3 3]); grid on; title('Digital at 6 dB')
err_analog  = sum(sign(a) ~= x)
err_digital = sum(d ~= x)
