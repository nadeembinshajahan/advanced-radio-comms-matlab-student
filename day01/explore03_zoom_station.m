%% explore03_zoom_station.m
%  ------------------------------------------------------------------
%  ONE IDEA: a station is not a line. It has a SHAPE and a WIDTH.
%
%  From far away every station looks like a spike. Zoom in and you see
%  what it really is: a carrier at the channel centre with a hump of
%  modulation spread either side of it. The width of that hump is the
%  BANDWIDTH the station occupies - and bandwidth is the thing that
%  regulators actually hand out.
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

station = 98.2;        % which station to look at, in MHz
half_span = 0.15;      % how far either side to look, in MHz

near = abs(f_MHz - station) < half_span;
clf
subplot(2,1,1)
plot(f_MHz, S_dB); grid on
xlabel('Frequency (MHz)'); ylabel('dB'); title('The whole capture')
subplot(2,1,2)
plot(f_MHz(near), S_dB(near)); grid on
xlabel('Frequency (MHz)'); ylabel('dB')
title(sprintf('Zoomed in on the %.1f MHz station', station))

peak = max(S_dB(near));
fprintf('Station at %.1f MHz\n', station);
fprintf('  tallest point : %.2f dB\n', peak);

% How wide is it? Measure how far you have to go out before the level
% has dropped by a given number of dB.
ff = f_MHz(near);
ss = S_dB(near);
for drop = [20 30 40]
    inside = find(ss > peak - drop);
    width_kHz = (ff(inside(end)) - ff(inside(1))) * 1000;
    fprintf('  width %2d dB down : %5.0f kHz\n', drop, width_kHz);
end
disp(' ');
disp('The tall thin spike in the middle is the carrier.');
disp('The wide low hump around it is the modulation - the actual audio.');
disp('For the 98.2 MHz station the hump is about 90 kHz wide at 30 dB');
disp('down and about 240 kHz wide at 40 dB down. FM broadcast channels');
disp('are 200 kHz apart, and you can see why: the hump needs the room.');

%% ================== TRY THIS ==================
%  1) Change  station  to 97.2 (the weakest one in this capture).
%     Expect: the same spike-on-a-hump shape, but about 25 dB lower,
%     and the hump nearly touches the noise floor. A weak station is
%     harder to demodulate for exactly this reason.
%
%  2) Change  half_span  to 0.6 and run again.
%     Expect: you now see three stations at once - 97.8, 98.2 and 98.4 -
%     plus the thin DC spike at exactly 98.000 MHz. Notice the DC spike
%     has NO hump around it. That is how you tell it is not a station.
%
%  3) Set station = 98.0 (the DC spike itself).
%     Expect: a peak at about -24.62 dB whose "width 20 dB down" prints
%     as 0 kHz - it is literally one point wide. It is a fault inside
%     the receiver, not a transmission, so it carries no modulation and
%     takes up no bandwidth at all.
