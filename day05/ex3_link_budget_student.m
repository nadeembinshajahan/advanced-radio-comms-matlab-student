%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 5 - Lesson 5 Antennas and RF Systems  (Friday half day)
%  Exercise  : 3 - Full link budget   *** STUDENT STARTER FILE ***
%              *** CAPSTONE EXERCISE OF THE DAY ***
%  Teaches   : the complete free-space link budget, end to end. Every
%              number from Lesson 4 and Lesson 5 comes back here: gains,
%              losses, EIRP, path loss, noise floor, SNR and margin. Then
%              the margin is swept against distance to find the range at
%              which the link finally dies.
%  Run time  : about 20 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : Sections 1-5 are TYPE ALONG - fill in the YOUR CODE HERE gaps.
%              Sections 6-7 are RUN AND SEE - they are already complete.
%              Do NOT type them. Just run them and watch what happens.
%              In the solo task in Section 7 you change ONE number.
%  NOTE      : this is FREE SPACE only - a clear line of sight with nothing
%              in the way. Fading, terrain and multipath arrive in Lesson 6.
%  How to use: click inside a section and press Run Section, one at a time.
%              Run in order - every section uses the one before it.
% ====================================================================

%% Section 1 (TYPE ALONG) - the radio link we are checking
clear; clc;
f_MHz = 2400;                   % 2.4 GHz
d_km  = 5;                      % how far apart the two radios are
Pt    = 20;                     % transmitter power, dBm (20 dBm = 100 mW)
Gt    = 6;    Gr = 6;           % antenna gain at each end, dBi
Lt    = 1.5;  Lr = 1.5;         % feeder and connector loss at each end, dB
B_Hz  = 10e6;                   % receiver bandwidth: 10 MHz
NF    = 6;                      % receiver noise figure, dB
SNR_req = 12;                   % the SNR this radio needs to work, dB

%% Section 2 (TYPE ALONG) - free-space path loss, worked out two ways
% GAP 1: write the engineer's free-space path loss formula.
% Hint: 32.44 + 20*log10(distance in km) + 20*log10(frequency in MHz).
FSPL = % YOUR CODE HERE
c    = 3e8;
lam  = c/(f_MHz*1e6);                             % wavelength, metres
FSPL2 = 20*log10(4*pi*(d_km*1e3)/lam)             % the physics form
difference = FSPL - FSPL2       % the two forms are the same formula

%% Section 3 (TYPE ALONG) - EIRP, and the power that actually arrives
% GAP 2: EIRP is the transmit power plus the antenna gain minus the feeder
%        loss. Received power is EIRP, minus the path loss, plus the receive
%        antenna gain, minus the receive feeder loss.
EIRP = % YOUR CODE HERE
Pr   = % YOUR CODE HERE

%% Section 4 (TYPE ALONG) - noise floor, SNR and link margin
% GAP 3: the noise floor is -174 dBm in 1 Hz, plus 10*log10(bandwidth),
%        plus the receiver noise figure. SNR is the received power above
%        that floor. The margin is whatever is left over.
N_dBm  = % YOUR CODE HERE
SNR    = % YOUR CODE HERE
margin = % YOUR CODE HERE

%% Section 5 (TYPE ALONG) - how much further could this link reach?
% In free space, doubling the distance costs 6 dB. So spending the whole
% margin buys a distance factor of 10^(margin/20).
% GAP 4: turn the margin into extra distance.
d_zero = % YOUR CODE HERE

%% Section 6 (RUN AND SEE) - margin against distance
% What this block does: it repeats the whole budget at 400 distances from
% 100 m out to 100 km and draws the margin. Where the curve crosses zero,
% the link stops working. Everything else is held exactly as above.
d       = logspace(-1, 2, 400);                    % 0.1 km to 100 km
FSPLs   = 32.44 + 20*log10(d) + 20*log10(f_MHz);
margins = EIRP - FSPLs + Gr - Lr - N_dBm - SNR_req;
semilogx(d, margins, 'LineWidth', 2); grid on
xlabel('Distance (km)'); ylabel('Link margin (dB)')
title('Link margin against distance, free space')
yline(0, '--r');                                   % the line where the link dies
k     = find(margins < 0, 1);                      % first distance with no margin
d_max = d(k)

%% Section 7 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - the receive antenna is upgraded from
%       6 dBi to 12 dBi - then run this section again. How much further
%       does the link reach? Guess the answer before you run it.
Gr      = 6;                                       % <-- CHANGE 6 TO 12
margins = EIRP - FSPLs + Gr - Lr - N_dBm - SNR_req;
semilogx(d, margins, 'LineWidth', 2); grid on
xlabel('Distance (km)'); ylabel('Link margin (dB)')
title('Link margin with a 12 dBi receive antenna')
yline(0, '--r');
k     = find(margins < 0, 1);
d_max = d(k)
