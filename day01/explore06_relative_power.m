%% explore06_relative_power.m
%  ------------------------------------------------------------------
%  ONE IDEA: in radio you almost never care about the absolute level.
%  You care about the DIFFERENCE between two levels - and in dB a
%  difference is just a subtraction.
%
%     difference in dB = level A - level B
%     how many times more POWER   = 10^(difference/10)
%     how many times more VOLTAGE = 10^(difference/20)
%
%  Power uses 10 and voltage uses 20. That is the only thing to
%  remember, and it is the thing people get wrong most often.
%
%  Run this from the TOP folder of the repo (the one with README.md).
%  Needs: plain MATLAB. No toolbox.
%  ------------------------------------------------------------------

clear; clc;
load('data/fm_capture_98MHz.mat');
iq = double(iq);
N  = numel(iq);

S_dB  = 20*log10(abs(fftshift(fft(iq)))/N);
f_MHz = (fc + (-N/2:N/2-1)*(fs/N)) / 1e6;

station_A = 98.2;      % the two stations to compare, in MHz
station_B = 97.8;

near_A = abs(f_MHz - station_A) < 0.02;
near_B = abs(f_MHz - station_B) < 0.02;
level_A = max(S_dB(near_A));
level_B = max(S_dB(near_B));

difference = level_A - level_B;

fprintf('station A at %.1f MHz : %7.2f dB\n',  station_A, level_A);
fprintf('station B at %.1f MHz : %7.2f dB\n\n', station_B, level_B);
fprintf('A is %.2f dB stronger than B.\n', difference);
fprintf('  that is %8.1f times the POWER    (10^(%.2f/10))\n', 10^(difference/10), difference);
fprintf('  and     %8.1f times the VOLTAGE  (10^(%.2f/20))\n\n', 10^(difference/20), difference);

% A quick sanity check on the rule: 3 dB should be about double the
% power, 10 dB should be exactly ten times, 20 dB a hundred times.
disp('The rules of thumb, checked:');
for d = [3 6 10 20 30]
    fprintf('  %2d dB = %7.2f times the power\n', d, 10^(d/10));
end
disp(' ');
disp('Now the picture, with both stations marked:');
clf
plot(f_MHz, S_dB); grid on; hold on
plot([station_A station_A], [level_A-3 level_A+3], 'LineWidth', 2)
plot([station_B station_B], [level_B-3 level_B+3], 'LineWidth', 2)
hold off
xlabel('Frequency (MHz)'); ylabel('Level (dB)')
title(sprintf('%.1f MHz is %.1f dB stronger than %.1f MHz', ...
      station_A, difference, station_B))

%% ================== TRY THIS ==================
%  1) Set station_B = 97.2 (the weakest station in this capture).
%     Expect: about 25.2 dB of difference, which is roughly 333 times
%     the power. Say that out loud - one station in this recording is
%     over three hundred times stronger than another one 1 MHz away.
%
%  2) Swap them round: station_A = 97.2 and station_B = 98.2.
%     Expect: -25.2 dB, and 0.003 times the power. A negative dB
%     number just means "weaker". The maths does not need a special
%     case for it.
%
%  3) Set both to 98.2. Expect: 0.00 dB and exactly 1.0 times the
%     power. Zero dB does not mean "no signal" - it means "the same".
%     This trips up nearly everyone once.
