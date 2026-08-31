%% ====================================================================
%  Exercise 6 - Read the real spectrum            (starter version)
%  ------------------------------------------------------------------
%  Teaches   : real radio data is COMPLEX (an I part and a Q part), so
%              its spectrum has a left half AND a right half, and the
%              middle of that spectrum is the frequency the radio was
%              tuned to. That idea - the two-sided spectrum drawn on an
%              absolute frequency axis - is the one you will reuse for
%              everything else you ever do with software defined radio.
%  Run time  : about 45 minutes to work through. The script itself runs
%              in about 2 seconds.
%  Needs     : plain MATLAB. No toolbox. MATLAB Online works fine.
%              Run it from the TOP folder of this repo (the one with
%              README.md in it) so the data/ paths resolve.
%  TIER      : Sections 1, 2, 4, 5, 7, 8, 9 are the ones you write -
%              fill in every line marked YOUR CODE HERE.
%              Sections 3, 6, 10, 11 are written for you - do NOT type
%              them, just run them and watch what happens.
%  How to use: click inside a section and press Run Section, one at a
%              time, in order. Later sections use earlier variables.
%
%  Stuck on a gap? The completed version is in
%  ex6_real_spectrum.m - but try it yourself first.
%
%  WHERE THE DATA CAME FROM
%  An ADALM-Pluto software defined radio was tuned to 98 MHz, the
%  middle of the FM broadcast band, and told to record 2 million
%  samples per second for a small fraction of a second. The sample file
%  shipped in data/ is a close synthetic copy of such a recording, so
%  the exercise runs with no hardware at all. See the README for how to
%  drop in your own capture instead.
% ====================================================================

%% Section 1 (TYPE ALONG) - open the capture and see what is inside it
clear; clc;
load('data/fm_capture_98MHz.mat');   % gives iq, fs, fc, gain_dB, capture_time, source
iq = double(iq);                % stored as single to keep the file small
N           = numel(iq)         % how many samples the radio recorded
% GAP 1: how long does the recording last, in milliseconds?
% Hint: N samples at fs samples per second lasts N/fs seconds.
%       Multiply by 1000 to get milliseconds. Leave the semicolon off.
duration_ms = % YOUR CODE HERE
centre_MHz  = fc/1e6            % the frequency the radio was tuned to
span_MHz    = fs/1e6            % how wide a slice of band we captured
disp(['captured at: ' capture_time '   source: ' source])

%% Section 2 (TYPE ALONG) - this data is COMPLEX, and that is the point
% Every sample is TWO numbers, written a + bi. The a is called I
% (in-phase) and the b is called Q (quadrature). A real radio needs
% both: with only one number you cannot tell a signal ABOVE the tuned
% frequency from a signal the same distance BELOW it.
first_three = iq(1:3)           % look: each one is a + bi, not one number
n_show = 400;                   % just the first 400 samples
t_us   = (0:n_show-1)/fs*1e6;   % their time, in microseconds
% GAP 2: pull out the I part and the Q part of those 400 samples.
% Hint: real(...) gives the I part and imag(...) gives the Q part.
%       Put iq(1:n_show) inside the brackets.
I_part = % YOUR CODE HERE
Q_part = % YOUR CODE HERE
clf
subplot(2,1,1); plot(t_us, I_part); grid on
ylabel('I  (real part)'); title('The first 400 samples of the capture')
subplot(2,1,2); plot(t_us, Q_part); grid on
ylabel('Q  (imaginary part)'); xlabel('Time (microseconds)')
% The two are different signals, not one signal drawn twice. Together
% they carry both how big the wave is AND where in its cycle it is.

%% Section 3 (RUN AND SEE) - turn it into a two-sided spectrum
% What this block does, in three steps:
%  fft(iq)     asks "which frequencies are inside this recording?"
%  fftshift()  moves 0 Hz from the edge of the answer to the MIDDLE.
%              Without it, the negative frequencies sit at the far
%              right and the picture is cut in half and swapped.
%  20*log10()  turns the sizes into dB, so a strong station and a weak
%              station both fit on one picture.
X    = fftshift(fft(iq));       % the spectrum, with 0 Hz in the middle
S_dB = 20*log10(abs(X)/N);      % how big each frequency is, in dB
disp(['spectrum has ' num2str(numel(S_dB)) ' points'])

%% Section 4 (TYPE ALONG) - the frequency axis: THE LINE TO REMEMBER
% After fftshift, the middle point of the spectrum is the frequency
% the radio was tuned to. Everything to the left of it is BELOW that
% frequency, everything to the right is ABOVE it. The step between
% neighbouring points is fs/N.
% This one line is used again on every day of this course.
% GAP 3: build the frequency axis. Start at the tuned frequency fc,
%        then step out both ways in steps of fs/N.
% Hint: the middle part is (-N/2:N/2-1), a list running from -N/2 up
%       to N/2-1. Multiply that list by (fs/N) and add fc.
f     = % YOUR CODE HERE
f_MHz = f/1e6;                      % the same thing, in MHz, to plot
clf
% GAP 4: draw the spectrum against the frequency axis in MHz.
% Hint: plot(f_MHz, S_dB)
% YOUR CODE HERE
grid on
xlabel('Frequency (MHz)'); ylabel('Level (dB)')
title('A real slice of the FM band, as the radio sees it')

%% Section 5 (TYPE ALONG) - the strongest station, and its wavelength
% max with TWO outputs gives you the value AND which point it was at.
% Point number k on the spectrum matches frequency f(k).
% GAP 5: find the tallest point in S_dB and remember where it was.
% Hint: [peak_dB, k] = max(S_dB)
% YOUR CODE HERE
f_peak_MHz   = f(k)/1e6         % turn the point number into a real frequency
c = 3e8;                        % speed of light, as in Exercise 2
% GAP 6: what is the wavelength of that station, and a quarter of it?
% Hint: same formula as Exercise 2. Both are single numbers, so plain
%       / is fine here - you do not need ./ this time.
lambda       = % YOUR CODE HERE
quarter_wave = % YOUR CODE HERE

%% Section 6 (RUN AND SEE) - find the eight strongest peaks
% What this block does: it takes the tallest point, writes it down,
% rubs out everything within 150 kHz of it, and looks again - eight
% times. That is how you find several stations without a toolbox.
% Two things it does FIRST:
%  - it measures the noise floor in a piece of band with nothing in it
%  - it rubs out the receiver's own DC spike at the exact centre.
%    That spike is NOT a station. It is a fault inside every direct
%    conversion receiver. Notice it has no hump of modulation round it.
quiet_lo = 98.55;   % a quiet piece of band, in MHz. If you use your own
quiet_hi = 98.70;   % capture, look at your plot and change these two.
quiet    = (f_MHz > quiet_lo) & (f_MHz < quiet_hi);
noise_dB = median(S_dB(quiet));

S_work = S_dB;
S_work(abs(f - fc) < 30e3) = -200;      % rub out the DC spike
f_pk = zeros(1,8);   p_pk = zeros(1,8);
for n = 1:8
    [p, kb]  = max(S_work);
    f_pk(n)  = f(kb);
    p_pk(n)  = p;
    S_work(abs(f - f(kb)) < 150e3) = -200;   % rub this one out, look again
end
is_station = p_pk > noise_dB + 25;      % a real station stands well clear
fprintf('noise floor between %.2f and %.2f MHz : %.2f dB\n', quiet_lo, quiet_hi, noise_dB);
for n = 1:8
    if is_station(n)
        fprintf('peak %d : %9.4f MHz   %7.2f dB    STATION\n',    n, f_pk(n)/1e6, p_pk(n));
    else
        fprintf('peak %d : %9.4f MHz   %7.2f dB    just noise\n', n, f_pk(n)/1e6, p_pk(n));
    end
end

%% Section 7 (TYPE ALONG) - how far apart are the stations?
% sort puts them in order, smallest frequency first.
% diff gives the gap between each one and the next.
f_st = sort(f_pk(is_station));
% GAP 7: work out the gap between each station and the next, in kHz,
%        then the smallest gap of all.
% Hint: diff(f_st) gives the gaps in Hz. Divide by 1e3 for kHz.
gaps_kHz         = % YOUR CODE HERE
smallest_gap_kHz = % YOUR CODE HERE
% Look at the answer before you move on. Is there a pattern?

%% Section 8 (TYPE ALONG) - how many channel slots, how many are used?
slot_kHz = 200;                     % the grid you just discovered
% GAP 8: how many 200 kHz slots fit inside the captured span, how many
%        of them hold a station, and what percentage is that?
% Hint: the span in kHz is fs/1e3. numel(f_st) counts the stations.
n_slots      = % YOUR CODE HERE
n_used       = % YOUR CODE HERE
percent_used = % YOUR CODE HERE
% Spectrum is finite. This is the whole reason regulators hand out
% channels instead of letting anyone transmit anywhere.

%% Section 9 (TYPE ALONG) - how much stronger is the strong station?
% Straight back to Exercise 1: a difference in dB is a ratio in power.
p_st         = p_pk(is_station);
strongest_dB = max(p_st)
weakest_dB   = min(p_st)
% GAP 9: how many dB is the strongest above the weakest, and how many
%        TIMES more power is that?
% Hint: subtract for the dB. For the ratio, undo the dB the same way
%       you did in Exercise 1: 10^(difference/10).
difference_dB    = % YOUR CODE HERE
times_more_power = % YOUR CODE HERE

%% Section 10 (RUN AND SEE) - two gain settings: watch the noise floor
% What this block does: it opens a SECOND capture of exactly the same
% band, taken with the receiver's gain turned down by 30 dB, and draws
% both on one picture. Watch what happens to the stations, and watch
% what happens to the noise floor underneath them. They do NOT move by
% the same amount. Day 4 explains why.
lo    = load('data/fm_capture_98MHz_lowgain.mat');
iq_lo = double(lo.iq);
S_lo  = 20*log10(abs(fftshift(fft(iq_lo)))/N);
floor_hi = median(S_dB(quiet));
floor_lo = median(S_lo(quiet));
clf
plot(f_MHz, S_dB, f_MHz, S_lo); grid on
legend(sprintf('gain %g dB', gain_dB), sprintf('gain %g dB', lo.gain_dB))
xlabel('Frequency (MHz)'); ylabel('Level (dB)')
title('The same band, recorded twice at two receiver gains')
fprintf('gain %g dB : noise floor %.2f dB\n', gain_dB,    floor_hi);
fprintf('gain %g dB : noise floor %.2f dB\n', lo.gain_dB, floor_lo);
fprintf('gain went up %g dB, but the noise floor only rose %.2f dB\n', ...
        gain_dB - lo.gain_dB, floor_hi - floor_lo);

%% Section 11 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - the station we look at moves from
%       98.2 MHz (the strongest) to 97.2 MHz (the weakest) - then run
%       this section again. Write down both sets of numbers.
%       Question: does the weak station gain as much as the strong one?
station_MHz = 98.2;             % <-- CHANGE 98.2 TO 97.2
band    = abs(f_MHz - station_MHz) < 0.02;   % a 40 kHz window round it
peak_hi = max(S_dB(band));   snr_hi = peak_hi - floor_hi;
peak_lo = max(S_lo(band));   snr_lo = peak_lo - floor_lo;
fprintf('station %.1f MHz\n', station_MHz);
fprintf('  gain %g dB : peak %7.2f dB, floor %7.2f dB, %5.1f dB above the noise\n', ...
        gain_dB,    peak_hi, floor_hi, snr_hi);
fprintf('  gain %g dB : peak %7.2f dB, floor %7.2f dB, %5.1f dB above the noise\n', ...
        lo.gain_dB, peak_lo, floor_lo, snr_lo);
fprintf('  turning the gain up bought this station %.1f dB of clarity\n', snr_hi - snr_lo);
