%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 3 - Modulation Techniques
%  Exercise  : 4 - Digital modulation by hand   *** STUDENT STARTER FILE ***
%  Teaches   : digital modulation is just a LOOK-UP TABLE. BPSK maps one
%              bit to +1 or -1. QPSK takes the bits two at a time and
%              maps each pair to one of four points on a circle, so it
%              carries twice the data in the same bandwidth. The picture
%              of those points is the CONSTELLATION.
%  Run time  : about 17 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : Sections 1, 2, 3, 5 and 6 are TYPE ALONG - fill in the
%              YOUR CODE HERE gaps. Section 4 is RUN AND SEE - it is
%              already complete. Do NOT type it. Just run it and look.
%  How to use: click inside a section and press Run Section, one at a time.
%              Run Section 1 first - every later section uses the bits.
% ====================================================================

%% Section 1 (TYPE ALONG) - eight bits, and the BPSK map
clear; clc;
bits = [1 0 0 1 1 1 0 0];         % the data we want to send
% GAP 1: turn the 0s and 1s into -1s and +1s in ONE line.
% Hint: you used this same trick on Day 1. Multiply by 2, then subtract 1.
sym  = % YOUR CODE HERE
stem(sym, 'filled', 'LineWidth', 1.5); grid on
ylim([-1.5 1.5]); xlabel('Symbol number'); ylabel('Amplitude')
title('BPSK: one bit per symbol, +1 or -1')
disp('BPSK symbols:'); disp(sym)

%% Section 2 (TYPE ALONG) - the BPSK constellation
I = sym;                          % everything sits on the I (in-phase) axis
Q = zeros(1,8);                   % nothing on the Q (quadrature) axis
scatter(I, Q, 90, 'filled'); grid on; axis equal
xlim([-1.5 1.5]); ylim([-1.5 1.5])
xlabel('I'); ylabel('Q'); title('BPSK constellation: 2 points')

%% Section 3 (TYPE ALONG) - QPSK: take the bits two at a time
b_I = bits(1:2:end);              % bits 1,3,5,7 go on the I axis
b_Q = bits(2:2:end);              % bits 2,4,6,8 go on the Q axis
% GAP 2: map each half to -1 or +1, then divide by sqrt(2) so that
%        I^2 + Q^2 comes to exactly 1 for every symbol.
I = % YOUR CODE HERE
Q = % YOUR CODE HERE
scatter(I, Q, 90, 'filled'); grid on; axis equal
xlim([-1.5 1.5]); ylim([-1.5 1.5])
xlabel('I'); ylabel('Q'); title('QPSK constellation: 4 points, 2 bits each')
disp('I values:'); disp(I)
disp('Q values:'); disp(Q)

%% Section 4 (RUN AND SEE) - what QPSK actually looks like on the air
% What this block does: it holds each I and Q value for 100 samples and
% builds the real radio wave. Look for the sudden phase jumps at the
% dashed lines, and notice the height NEVER changes.
Fs  = 8000;                       % 8000 samples every second
sps = 100;                        % 100 samples per symbol
fc  = 400;                        % carrier: 5 cycles inside every symbol
Iv  = repelem(I, sps);            % repelem holds each value for 100 samples
Qv  = repelem(Q, sps);
tt  = (0:length(Iv)-1)/Fs;
w   = Iv.*cos(2*pi*fc*tt) - Qv.*sin(2*pi*fc*tt);   % the QPSK waveform
clf
plot(tt*1000, w, 'LineWidth', 1.2); grid on; ylim([-1.5 1.5])
xlabel('Time (ms)'); ylabel('Amplitude'); title('QPSK waveform - the phase jumps carry the data')
xline(12.5, '--k'); xline(25, '--k'); xline(37.5, '--k');   % symbol boundaries

%% Section 5 (TYPE ALONG) - comparing the schemes: bits per symbol
M   = [2 4 16 64];                % BPSK, QPSK, 16-QAM, 64-QAM
% GAP 3: how many bits does ONE symbol carry in each scheme, and what
%        bit rate does that give at 1 million symbols per second?
% Hint: bits per symbol = log2 of the number of points. Leave the
%       semicolon off so the answer prints.
k   = % YOUR CODE HERE
Rs  = 1e6;                        % 1 million symbols per second
Rb  = Rs * k;                     % the bit rate each scheme gives
Rb_Mbps = Rb / 1e6                % in Mbit/s
% k is also the bandwidth efficiency in bit/s per Hz, because an ideal
% channel needs about 1 Hz of bandwidth for every symbol per second.
% Higher k = more data in the same channel. The price is paid in Exercise 5.

%% Section 6 (TYPE ALONG) - SOLO VARIATION
% Task: the channel now allows 2 million symbols per second. What bit
%       rate does each of the four schemes give? Which one do you need to
%       reach exactly 8 Mbit/s? Write your answer down before you run it.
% GAP 4: work out the four bit rates in Mbit/s at the new symbol rate.
Rs2 = 2e6;
Rb2_Mbps = % YOUR CODE HERE
