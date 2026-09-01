%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 2 - Electromagnetic Fundamentals
%  File      : ex6_challenges.m
%  What      : CHALLENGE tasks that follow Exercise 6.
%  For whom  : anyone who has finished ex6_real_spectrum.m and wants
%              something harder. There are seven challenges. A fast
%              student needs 10 to 20 minutes for each one.
%  Needs     : plain MATLAB (MATLAB Online is fine). NO TOOLBOX.
%              Plus  fm_capture_98MHz.mat  and  fm_capture_98MHz_lowgain.mat
%              in the same folder as this file.
%
%  HOW THESE ARE DIFFERENT FROM THE EXERCISE
%  Exercise 6 told you what to type. These do not. Each challenge is a
%  QUESTION. You decide the method. You write the code. Nobody will
%  tell you the answer - you have to convince yourself, and then
%  convince the person sitting next to you.
%
%  THE RULES
%   1. You may only use what is in the two capture files. No internet,
%      no looking up the local radio stations. The data is the evidence.
%   2. Every number you report needs a method you can defend in one
%      sentence. "MATLAB said so" is not a method.
%   3. If your neighbour gets a different answer, do not assume one of
%      you is wrong. Find out WHY the two methods disagree. That is
%      usually the real lesson.
%   4. Write your answer as a comment under each challenge, in words,
%      with the number. You will be asked to read it out.
%
%  HOW TO RUN THIS FILE
%  Run Section 0 first - it loads the data and sets up the variables
%  every challenge uses. Then pick any challenge and run its section.
%  Running the whole file top to bottom just prints the questions; it
%  will not error, because the answer space is yours to fill in.
%
%  MARKED  [PAIR]  = do it alone first, then compare with one other
%  person before you accept your answer.
% ====================================================================


%% Section 0 - SETUP. Run this first, every time.
clear; clc; close all;

load('fm_capture_98MHz.mat');            % iq, fs, fc, gain_dB, capture_time, source
iq = double(iq);
N  = numel(iq);

lo    = load('fm_capture_98MHz_lowgain.mat');
iq_lo = double(lo.iq);

% The spectrum of the full capture, exactly as in Exercise 6.
S_dB  = 20*log10(abs(fftshift(fft(iq)))/N);
f     = fc + (-N/2:N/2-1)*(fs/N);
f_MHz = f/1e6;

% A piece of band with nothing in it, for measuring the noise floor.
quiet    = (f_MHz > 98.55) & (f_MHz < 98.70);
noise_dB = median(S_dB(quiet));

fprintf('Capture loaded.\n');
fprintf('  %d samples, %.3f ms long, %.1f MHz wide, centred on %.1f MHz\n', ...
        N, 1000*N/fs, fs/1e6, fc/1e6);
fprintf('  receiver gain %g dB (the second file is at %g dB)\n', gain_dB, lo.gain_dB);
fprintf('  noise floor in the quiet band: %.2f dB\n\n', noise_dB);
fprintf('Seven challenges follow. Run one section at a time.\n');

% You will keep needing this pair of lines. Learn them.
%     S_dB  = 20*log10(abs(fftshift(fft(x)))/numel(x));
%     f     = fc + (-numel(x)/2:numel(x)/2-1)*(fs/numel(x));


%% ====================================================================
%  CHALLENGE 1 - HOW SHORT CAN THE RECORDING BE?
%  Suggested time: 15 minutes.
% ====================================================================
%
%  THE SITUATION
%  Your capture is 65.5 ms long. Recording costs time, memory and
%  battery. A drone that has to sweep a whole band cannot afford 65 ms
%  in every channel. So: how much of that recording did you actually
%  need?
%
%  THE QUESTION - part (a)
%  What is the SHORTEST piece of this recording that still shows the
%  two closest stations as TWO separate signals, rather than one lump?
%  Give the answer in samples AND in microseconds.
%
%  THE QUESTION - part (b)
%  What is the shortest piece that still shows ALL SIX stations, each
%  one clearly above the noise?
%
%  IF THE TWO ANSWERS ARE DIFFERENT, EXPLAIN WHY. That explanation is
%  worth more than either number.
%
%  BEFORE YOU WRITE ANY CODE
%  Work out on paper what you EXPECT, from the fact that neighbouring
%  points of an FFT are fs/N apart. Write your prediction down. Then
%  test it. If the measurement disagrees with the prediction, the
%  interesting work starts there.
%
%  WHAT COUNTS AS AN ANSWER
%  A number, plus the test you used to decide "yes, that is two
%  separate signals" or "yes, that station is above the noise".
%  Somebody else must be able to apply your test and get your answer.
%
disp(' ');
disp('CHALLENGE 1 - how short can the recording be? See the comments above.');
disp('  Hint on getting a shorter recording: x = iq(1:n) takes the first n samples.');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------




% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  CHALLENGE 2 - HOW STRONG IS THE 98.2 MHz STATION?          [PAIR]
%  Suggested time: 25 minutes. This is the hardest one. Do not rush it.
% ====================================================================
%
%  THE TASK
%  Measure how strong the 98.2 MHz station is. Then measure how strong
%  the 98.4 MHz station is. Then say how many dB apart they are.
%
%  THAT SOUNDS EASY. IT IS NOT.
%
%  DO IT LIKE THIS, IN THIS ORDER:
%
%  Step 1. Measure both stations using the whole capture, N = 131072.
%          Write the two numbers down. Write the difference down.
%
%  Step 2. Now do exactly the same measurement using only the first
%          4096 samples. Then only the first 32768. Then 2048.
%          Write those numbers down too.
%
%  Step 3. Look at your table. Something is wrong. The radio signal
%          did not change. Your answer did.
%          HOW BIG IS THE DISAGREEMENT, in dB?
%
%  Step 4. Work out WHY. Do not move on until you can say it in one
%          sentence. A hint that is not a spoiler: the FFT does not
%          measure the frequencies you are interested in. It measures
%          the frequencies fs/N apart that it happens to land on.
%          What if the station is not sitting exactly on one of them?
%
%  Step 5. Now design a BETTER measurement - one that gives the same
%          answer no matter how many samples you use. Test it at all
%          four values of N and show that it is stable.
%
%  [PAIR TASK] Before Step 5, swap answers with one other person.
%  One of you uses N = 131072. The other uses N = 4096. You will get
%  different numbers for the same station. Neither of you has made a
%  mistake. Work out together what the honest number is.
%
%  WHAT COUNTS AS AN ANSWER
%  (i) the size of the disagreement in dB,
%  (ii) one sentence saying what causes it,
%  (iii) a measurement whose answer does not wander when N changes,
%       and the four numbers proving it does not wander.
%
disp(' ');
disp('CHALLENGE 2 - how strong is 98.2 MHz? Read the steps above. [PAIR TASK]');
disp('  Build the table first. Do not try to be clever before you have the table.');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------




% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  CHALLENGE 3 - ONE OF THESE IS NOT A RADIO STATION
%  Suggested time: 20 minutes.
% ====================================================================
%
%  THE SITUATION
%  Look at the spectrum. There are seven tall peaks. Six of them are
%  transmitters somewhere out there in the city. ONE of them is not a
%  transmitter at all - it is a fault inside the receiver, and it
%  would still be there with the antenna unplugged.
%
%  THE QUESTION
%  Which one is the impostor, and how do you PROVE it from the data?
%
%  THE PART THAT MATTERS
%  Almost anyone can guess which one. What you are being asked for is
%  a TEST - something you compute, that gives a clearly different
%  answer for the impostor than for the six real stations.
%
%  Design at least THREE different tests. For each one, report the
%  number it gives for all seven peaks, and say whether that test
%  actually separates the impostor from the rest.
%
%  BE HONEST ABOUT THE TESTS THAT FAIL. At least one obvious test does
%  NOT work on this data - it gives nearly the same answer for the
%  impostor as for a real station. Finding a test that fails, and
%  saying so, scores higher than three tests that happen to work.
%
%  THINGS YOU MIGHT THINK ABOUT
%   - where exactly is it, to the nearest Hz?
%   - a transmitter sends information. Does this peak carry any?
%   - if you cut the capture into eight short blocks and measure the
%     peak in each block, does it hold still or does it move about?
%   - a real transmitter's audio changes from moment to moment.
%   - what does the average of all the samples, mean(iq), have to do
%     with a spike at the exact centre of the spectrum?
%
%  DO NOT use "it is at a round number" or "it is not on the 200 kHz
%  channel grid" as evidence. Check whether that is even true here
%  before you rely on it.
%
disp(' ');
disp('CHALLENGE 3 - one of the seven peaks is not a station. Prove which.');
disp('  Three tests, with numbers for all seven peaks. Include one test that fails.');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------




% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  CHALLENGE 4 - WHICH GAIN SETTING WOULD YOU ACTUALLY USE?
%  Suggested time: 15 minutes. There is no single right answer here.
% ====================================================================
%
%  THE SITUATION
%  You have the same piece of band recorded twice: once with the
%  receiver gain at 50 dB, once at 20 dB. iq is the first, iq_lo is
%  the second.
%
%  THE QUESTION - part (a)
%  In each recording, how much of the total captured power is actual
%  radio signal, and how much is just receiver noise? Give it as a
%  percentage of the total, for BOTH files.
%  (Useful fact you can check for yourself: the total power of the
%  samples, mean(abs(x).^2), is the same as the total power added up
%  across the whole spectrum. Either route is fine.)
%
%  THE QUESTION - part (b)
%  You are the engineer. You get to pick ONE gain setting for a
%  mission tomorrow. Which one, and why?
%  Your answer must mention BOTH of these, with numbers:
%    - how clearly you can hear the weakest station you care about,
%    - what happens if a signal much stronger than today's arrives.
%      Look at max(abs(iq)) in each file. The radio cannot represent
%      a sample bigger than 1.0. How much room is left?
%
%  THE QUESTION - part (c)
%  Is EITHER of these two settings the right one? If not, describe the
%  setting you would actually ask for, and what number you would watch
%  to decide you had got it right.
%
%  This is a judgement question. Two sensible engineers can disagree.
%  Marks are for the reasoning, not for picking a side.
%
disp(' ');
disp('CHALLENGE 4 - which gain setting, and why? Signal vs noise, and headroom.');
disp('  You must quote numbers for both files. "Bigger is better" is not an answer.');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------




% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  CHALLENGE 5 - HOW BUSY IS THIS BAND, REALLY?               [PAIR]
%  Suggested time: 15 minutes, then a class discussion.
% ====================================================================
%
%  THE SITUATION
%  A regulator asks you: of the ten 200 kHz channel slots in this 2 MHz
%  of spectrum, how many are IN USE? They want one number, and they
%  want the rule you used, because they are going to apply your rule to
%  a thousand more captures without you.
%
%  THE QUESTION
%  Write down a rule for "this slot is occupied" BEFORE you look at the
%  answer it gives. Then apply it. Then report:
%     - your rule, in one sentence,
%     - the number of occupied slots,
%     - which slots.
%
%  THEN DO THIS, WHICH IS THE REAL POINT
%  Change the numbers in your rule - make it stricter, then looser -
%  and record how the count changes. Show a small table:
%  rule setting -> number of occupied slots.
%  How much does the answer move? Is there any setting where the count
%  is stable, or does it change every time you touch it?
%
%  [PAIR TASK] Compare your count with one other person. If you have
%  different numbers, do NOT just take the average. Find the slot you
%  disagree about, and work out which rule is the more defensible one
%  and why. Be ready to say your count and your rule out loud.
%
%  A WARNING
%  A rule based only on "is there something big here" will let
%  something into your count that has no business being called an
%  occupied channel. If your count is bigger than you expected, go
%  back and look at Challenge 3.
%
disp(' ');
disp('CHALLENGE 5 - how many of the ten slots are occupied? [PAIR TASK]');
disp('  State the rule BEFORE you look at the answer. Then vary the rule.');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------




% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  CHALLENGE 6 - WHICH ANTENNA ON THE DESK WOULD ACTUALLY WORK?
%  Suggested time: 15 minutes.
% ====================================================================
%
%  THE SITUATION
%  There are antennas on the trainer's desk. Roughly:
%     A  the short black whip that came in the Pluto box, about 8.6 cm
%        of radiating element (it is designed for around 870 MHz)
%     B  a stubby Wi-Fi antenna, about 3.1 cm of element (2.4 GHz)
%     C  a telescopic whip that pulls out to any length up to 1 m
%     D  a random 15 cm offcut of wire
%
%  THE QUESTION - part (a)
%  For each of the six stations you measured, what is the wavelength,
%  and what is a quarter of it? Then answer: do you need six different
%  antennas, or will one do for all six? Justify it with a number -
%  how much do the six quarter-wave lengths actually differ?
%
%  THE QUESTION - part (b)
%  You pick antenna C and pull it out to the right length. Good.
%  Now: HOW MUCH WORSE would A, B and D be? Put a dB number on each.
%
%  You have not been taught a formula for this. Here is the one piece
%  of physics you need, and you may take it as given:
%
%     For a whip much SHORTER than a quarter wavelength, the useful
%     resistance it presents is about
%           Rr = 40 * pi^2 * (h/lambda)^2   ohms
%     where h is the length of the whip. The receiver input is 50 ohms.
%     The fraction of the available power that gets in is about
%           eta = 4 * Rr * 50 / (Rr + 50)^2
%     A correctly cut quarter-wave whip has Rr of about 36.5 ohms.
%
%  Work out eta in dB for each antenna and compare it with the
%  quarter-wave whip. (This is the BEST case - it ignores another
%  effect that makes a short whip worse still. Say so in your answer.)
%
%  THE QUESTION - part (c)
%  Take your dB penalties and apply them to the numbers you measured
%  today. In Exercise 6 you found how far each station stands above the
%  noise floor. With antenna A instead of a proper quarter wave, which
%  of the six stations would you still be able to listen to, and which
%  would you lose? Assume you need about 15 to 20 dB above the noise to
%  hear a station cleanly.
%
disp(' ');
disp('CHALLENGE 6 - which antenna, and how many dB do you lose with the wrong one?');
disp('  Part (c) is the one that matters: connect the dB penalty to your own measurements.');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------




% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  CHALLENGE 7 - THE MYSTERY CAPTURE
%  Suggested time: 20 minutes. Finish with this one.
% ====================================================================
%
%  THE SITUATION
%  A colleague hands you a file of IQ samples from a receiver. The
%  notes that came with it are gone. All you know is the sample rate.
%  You do NOT know what frequency the receiver was tuned to.
%
%  The section below sets that up: it gives you the same samples, but
%  with the centre frequency thrown away. The only axis you get is
%  "kHz away from wherever the receiver was tuned".
%
%  THE QUESTION
%  Write a short report - five or six sentences - answering:
%     1. What KIND of signals are these? How do you know?
%     2. What is the channel spacing? What does that tell you?
%     3. How wide is one signal? What does that tell you?
%     4. What service or band do you believe this is, and how
%        confident are you?
%     5. Is there anything in this capture that is NOT a transmission?
%     6. Can you say what absolute frequency the receiver was tuned to?
%        If yes, say how. If no, say exactly why not, and say what
%        extra information you would need.
%
%  Question 6 is the important one. Think hard before you answer it.
%
%  EVIDENCE YOU ARE ALLOWED TO USE
%  Only the samples, the sample rate, and general radio knowledge.
%  You may reuse anything you built in Challenges 1 to 6.
%
%  MARKS ARE FOR REASONING, NOT ARITHMETIC. A confident wrong answer
%  scores nothing. "Here is what the data supports, and here is where
%  it runs out" scores everything.
%
%  THEN, WHEN YOUR REPORT IS WRITTEN
%  Change one line below to  mystery_iq = double(lo.iq);  and run the
%  section again. That is the SAME band recorded with the receiver
%  turned down. Go through your six answers one at a time and mark
%  each one: does it still hold, or did it just fall apart? Say which
%  of your conclusions were robust and which depended on having a
%  clean recording. That last paragraph is the best thing you will
%  write today.
%
mystery_iq = double(iq);                 % samples only
mystery_fs = fs;                         % sample rate is known
% centre frequency: DELIBERATELY NOT PROVIDED.
Nm      = numel(mystery_iq);
Sm_dB   = 20*log10(abs(fftshift(fft(mystery_iq)))/Nm);
f_kHz   = (-Nm/2:Nm/2-1)*(mystery_fs/Nm)/1e3;   % offset from the tuned frequency
clf
plot(f_kHz, Sm_dB); grid on
xlabel('kHz away from wherever the receiver was tuned')
ylabel('Level (dB)')
title('Mystery capture - the metadata is lost')
disp(' ');
disp('CHALLENGE 7 - the mystery capture. Write the six-part report in comments below.');
disp('  Sample rate is known. Centre frequency is NOT. That is the whole point.');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------
%  1.
%  2.
%  3.
%  4.
%  5.
%  6.



% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  IF YOU FINISH EVERYTHING
% ====================================================================
%  Pick one of these. They are open ended on purpose.
%
%  A. In Challenge 1 you found the shortest capture that shows all six
%     stations. Repeat that measurement using a DIFFERENT slice of the
%     recording each time - say iq(1:n), then iq(20001:20000+n), and so
%     on. Does your answer hold? If it moves, what should you report to
%     somebody who has to trust the number?
%
%  B. Exercise 6 measured how far the noise floor moved between the two
%     gain settings and got about 10 dB, not the 30 dB the gain moved.
%     Using both files, work out how much of the noise is picked up at
%     the antenna and how much is made inside the receiver after the
%     amplifier. Two numbers, one equation, and a sentence saying which
%     one you could fix with a better antenna.
%
%  C. The stations are 200 kHz apart and each one is wider than you
%     might expect. From your own measurement of how wide one station
%     is, argue whether 200 kHz is generous, tight, or about right -
%     and say what would happen to a listener if the regulator had
%     chosen 150 kHz instead.
%
disp(' ');
disp('Extras A, B and C are in the comments at the end of the file.');
