%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 3 - Modulation Techniques
%  Exercise  : 5 - Noise on the constellation
%              *** STUDENT STARTER FILE ***
%  Teaches   : noise turns each clean constellation point into a fuzzy
%              cloud. While the clouds stay inside their own quarter of
%              the picture the receiver still decides correctly. When the
%              clouds grow big enough to cross the red decision lines,
%              symbols start coming out wrong. This is also the reason
%              16-QAM and 64-QAM need a much better SNR than QPSK: their
%              points sit much closer together for the same power.
%  Run time  : about 14 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is RUN AND SEE. There is nothing to type in
%              this file. Run each section and watch what happens.
%              In the solo task in Section 5 you change ONE number.
%  How to use: click inside a section and press Run Section, one at a time.
%              Run Section 1 first - every later section uses its symbols.
% ====================================================================

%% Section 1 (RUN AND SEE) - one thousand random QPSK symbols
% What this block does: it makes 1000 random symbol pairs and maps them
% onto the same four QPSK points you built by hand in Exercise 4.
clear; clc;
rng(3);                            % same random numbers every time you run it
Nsym = 1000;                       % number of symbols
b_I  = randi([0 1], 1, Nsym);      % random bits for the I axis
b_Q  = randi([0 1], 1, Nsym);      % random bits for the Q axis
I    = (2*b_I - 1)/sqrt(2);        % the clean transmitted I values
Q    = (2*b_Q - 1)/sqrt(2);        % the clean transmitted Q values

%% Section 2 (RUN AND SEE) - a clean link: SNR = 20 dB
% What this block does: it adds a little Gaussian noise to I and to Q and
% draws the received points. The red lines are the decision boundaries.
snr_dB = 20;                       % signal-to-noise ratio, in dB
sigma  = sqrt(10^(-snr_dB/10)/2);  % noise level per axis (0.0707)
Ir = I + sigma*randn(1,Nsym);      % what the receiver actually sees
Qr = Q + sigma*randn(1,Nsym);
clf
scatter(Ir, Qr, 8, 'filled'); grid on; axis equal
xlim([-2 2]); ylim([-2 2]); xline(0,'r'); yline(0,'r')
xlabel('I'); ylabel('Q'); title('QPSK at SNR = 20 dB - four tight dots')

%% Section 3 (RUN AND SEE) - the same link at three SNR values
% What this block does: it repeats the noise at 20 dB, 10 dB and 5 dB and
% puts the three pictures side by side. Watch the clouds grow.
snr_list = [20 10 5];
clf
for k = 1:3
    sigma = sqrt(10^(-snr_list(k)/10)/2);
    Ir = I + sigma*randn(1,Nsym);
    Qr = Q + sigma*randn(1,Nsym);
    subplot(1,3,k)
    scatter(Ir, Qr, 6, 'filled'); grid on; axis equal
    xlim([-2 2]); ylim([-2 2]); xline(0,'r'); yline(0,'r')
    title(['SNR = ' num2str(snr_list(k)) ' dB'])
end

%% Section 4 (RUN AND SEE) - count the symbols the receiver gets wrong
% What this block does: the receiver decides by asking "is I above or
% below zero, and is Q above or below zero?" This counts how often that
% simple decision gives the wrong answer.
errs = zeros(1,3);
for k = 1:3
    sigma = sqrt(10^(-snr_list(k)/10)/2);
    Ir  = I + sigma*randn(1,Nsym);
    Qr  = Q + sigma*randn(1,Nsym);
    bad = (sign(Ir) ~= sign(I)) | (sign(Qr) ~= sign(Q));
    errs(k) = sum(bad);
end
errs                               % three error counts, out of 1000 symbols

%% Section 5 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - the SNR goes from 5 dB down to 0 dB -
%       then run this section again. Two questions to answer:
%       (a) can you still see four separate clouds?
%       (b) how many symbols out of 1000 are now wrong?
snr_dB = 5;                        % <-- CHANGE 5 TO 0
sigma  = sqrt(10^(-snr_dB/10)/2);
Ir = I + sigma*randn(1,Nsym);
Qr = Q + sigma*randn(1,Nsym);
clf
scatter(Ir, Qr, 8, 'filled'); grid on; axis equal
xlim([-2 2]); ylim([-2 2]); xline(0,'r'); yline(0,'r')
xlabel('I'); ylabel('Q'); title('QPSK with noise')
bad   = (sign(Ir) ~= sign(I)) | (sign(Qr) ~= sign(Q));
n_bad = sum(bad)                   % how many symbols came out wrong

%% Section 6 (RUN AND SEE) - why 16-QAM needs a better SNR than QPSK
% What this block does: it draws 16-QAM on top of QPSK at exactly the
% same average power, and turns the smaller gap between points into dB.
lev = [-3 -1 1 3]/sqrt(10);        % the four 16-QAM levels on each axis
[Ig, Qg] = meshgrid(lev, lev);     % all 16 combinations
clf
scatter(Ig(:), Qg(:), 45, 'filled'); grid on; axis equal; hold on
plot([0.7071 -0.7071 0.7071 -0.7071], [0.7071 0.7071 -0.7071 -0.7071], ...
     'rs', 'MarkerSize', 14, 'LineWidth', 1.5)
hold off
xlim([-1.5 1.5]); ylim([-1.5 1.5]); xlabel('I'); ylabel('Q')
legend('16-QAM: 16 points', 'QPSK: 4 points')
title('Same average power - 16-QAM points sit much closer together')
d_qpsk   = 2/sqrt(2)                     % gap between nearest QPSK points
d_16qam  = 2/sqrt(10)                    % gap between nearest 16-QAM points
extra_dB = 20*log10(d_qpsk/d_16qam)      % the extra SNR that gap costs, in dB
