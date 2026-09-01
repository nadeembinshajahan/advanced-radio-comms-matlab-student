%% ====================================================================
%  Course    : Advanced Radio Communications
%  Day       : 2 - Electromagnetic Fundamentals
%  File      : ex6_challenges.m
%  What      : CHALLENGE tasks that follow Exercise 6.
%  For whom  : anyone who has finished ex6_real_spectrum_student.m and
%              wants something harder. Six core challenges plus one
%              optional STRETCH challenge at the end.
%  Needs     : plain MATLAB (MATLAB Online is fine). NO TOOLBOX.
%              In the same folder as this file you need:
%                 fm_capture_98MHz.mat
%                 fm_capture_98MHz_lowgain.mat
%                 hint.m
%                 selfcheck.m
%
%  HOW THESE ARE DIFFERENT FROM THE EXERCISE
%  Exercise 6 told you what to type. These do not. Each challenge is a
%  QUESTION. You decide the method. You write the code.
%
%  YOU CAN DO ALL OF THIS ON YOUR OWN. Two helpers are provided.
%
%  1) HINTS, when you want them
%     Type   hint(3)   to get the first hint for Challenge 3.
%     Type   hint(3)   again for the next hint. There are three hints
%     for every challenge. They get more and more specific. The third
%     one gives you the shape of the calculation. None of them gives
%     you the answer.
%     Type   hint(3,'reset')   to start that challenge's hints again.
%     Nothing is printed until you ask, so you will not read a hint by
%     accident.
%
%  2) SELF-CHECK, when you have a number
%     Type   selfcheck(3, 98.0)   to test your answer for Challenge 3.
%     It tells you whether you are right, or close, or wrong in a way
%     it recognises - and if it recognises the mistake it names it.
%     It NEVER tells you the correct value. Getting there is your job.
%     Each challenge below says exactly what number to pass in.
%     Some challenges are judgement questions with no single right
%     number. For those, selfcheck asks YOU some questions back and
%     tells you what a good answer has to account for.
%
%  THE RULES
%   1. You may only use what is in the two capture files. No internet,
%      no looking up the local radio stations. The data is the evidence.
%   2. Every number you report needs a method you can defend in one
%      sentence. "MATLAB said so" is not a method.
%   3. Use the hints in order and only when you are stuck. A hint you
%      did not need teaches you nothing.
%   4. Write your answer as a comment under each challenge, in words,
%      with the number.
%
%  HOW TO RUN THIS FILE
%  Run Section 0 first - it loads the data and sets up the variables
%  every challenge uses. Then pick any challenge and run its section.
%  Running the whole file top to bottom just prints the questions; it
%  will not error, because the answer space is yours to fill in.
%
%  ORDER AND TIME
%   1  Which antenna would actually work?              20 minutes
%   2  How short can the recording be?                 20 minutes
%   3  One of these is not a radio station             20 minutes
%   4  How strong is the 98.2 MHz station?             25 minutes
%   5  Which gain setting would you actually use?      15 minutes
%   6  How busy is this band, really?                  20 minutes
%   7  The mystery capture            STRETCH, OPTIONAL, 25 minutes
%  They get harder as you go down. Do them in order. Challenge 7 is
%  marked STRETCH: it is the hardest thing here and nobody is expected
%  to finish it. Six out of six is a full afternoon's work.
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

% Are the two helpers here?
if exist('hint', 'file') == 2 && exist('selfcheck', 'file') == 2
    fprintf('Helpers ready.  hint(k) gives hints.  selfcheck(k, value) checks answers.\n');
else
    fprintf('WARNING: hint.m and selfcheck.m are not in this folder.\n');
    fprintf('         Run  setup  again to fetch them. The challenges still work,\n');
    fprintf('         you just will not get hints or answer checking.\n');
end
fprintf('Six challenges, plus one optional stretch. Run one section at a time.\n');

% You will keep needing this pair of lines. Learn them.
%     S_dB  = 20*log10(abs(fftshift(fft(x)))/numel(x));
%     f     = fc + (-numel(x)/2:numel(x)/2-1)*(fs/numel(x));


%% ====================================================================
%  CHALLENGE 1 - WHICH ANTENNA ON THE DESK WOULD ACTUALLY WORK?
%  Time: about 20 minutes.  Start here - this one is meant to be
%  reachable with what you already know.
% ====================================================================
%
%  THE SITUATION
%  There are four antennas on the trainer's desk:
%     A  the short black whip that came in the Pluto box, about 8.6 cm
%        of radiating element (it is designed for around 870 MHz)
%     B  a stubby Wi-Fi antenna, about 3.1 cm of element (2.4 GHz)
%     C  a telescopic whip that pulls out to any length up to 1 m
%     D  a random 15 cm offcut of wire
%
%  THE QUESTION - part (a)
%  For each of the six stations you found in Exercise 6, what is the
%  wavelength, and what is a quarter of it? Then answer: do you need
%  six different antennas, or will one do for all six? Justify it with
%  a number - how much do the six quarter-wave lengths actually differ?
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
%  YOU ARE DONE WHEN...
%   - you can say in one sentence why one antenna covers all six
%     stations, and you have the number that proves it;
%   - you have a dB penalty for A, B and D, all worked out the same
%     way, and you have said which comparison they are penalties
%     against;
%   - you have named at least one station you would lose with antenna
%     A or B, and said what "lose" means as a number;
%   - you have written one sentence saying why your dB figures are
%     optimistic.
%
%  STUCK?      hint(1)
%  CHECK IT    selfcheck(1, x)   where x is the number of dB you LOSE
%              by using antenna A (the 8.6 cm Pluto whip) instead of a
%              correctly cut quarter wave at 98.2 MHz. Give it as a
%              positive number of dB.
%
disp(' ');
disp('CHALLENGE 1 - which antenna, and how many dB do you lose with the wrong one?');
disp('  Part (c) is the one that matters: connect the dB penalty to your own measurements.');
disp('  Hints: hint(1).   Check an answer: selfcheck(1, x).');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------




% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  CHALLENGE 2 - HOW SHORT CAN THE RECORDING BE?
%  Time: about 20 minutes.
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
%  ONE THING THAT CATCHES EVERYBODY
%  x = iq(1:n) always takes the first n samples. That is one slice of
%  the recording out of many. Try starting somewhere else as well:
%  x = iq(20001:20000+n). If your answer changes, the honest answer is
%  the WORST case, not the first one you happened to get.
%
%  YOU ARE DONE WHEN...
%   - you have two different numbers, one for (a) and one for (b), and
%     one sentence saying why they are not the same question;
%   - you can state the test you used to decide "yes, that is two
%     separate signals" and the test for "yes, that station is above
%     the noise", and somebody else could apply both without asking
%     you anything;
%   - you have tried at least three different starting points inside
%     the recording for part (b), and your answer holds for all of
%     them.
%
%  STUCK?      hint(2)
%  CHECK IT    selfcheck(2, x)   where x is a NUMBER OF SAMPLES - for
%              part (a) or for part (b). It works out which part you
%              are answering.
%
disp(' ');
disp('CHALLENGE 2 - how short can the recording be? See the comments above.');
disp('  Getting a shorter recording: x = iq(1:n) takes the first n samples.');
disp('  Hints: hint(2).   Check an answer: selfcheck(2, x).');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------




% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  CHALLENGE 3 - ONE OF THESE IS NOT A RADIO STATION
%  Time: about 20 minutes.
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
%  YOU ARE DONE WHEN...
%   - you have named one peak, in MHz;
%   - you have THREE tests, each one a number you computed for all
%     seven peaks, not an impression;
%   - at least one of your tests came out the same for the impostor as
%     for the real stations, and you have written down that it failed
%     and why;
%   - you can say in one sentence what this peak physically is.
%
%  STUCK?      hint(3)
%  CHECK IT    selfcheck(3, x)   where x is the frequency of the
%              impostor in MHz.
%
disp(' ');
disp('CHALLENGE 3 - one of the seven peaks is not a station. Prove which.');
disp('  Three tests, with numbers for all seven peaks. Include one test that fails.');
disp('  Hints: hint(3).   Check an answer: selfcheck(3, x).');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------




% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  CHALLENGE 4 - HOW STRONG IS THE 98.2 MHz STATION?
%  Time: about 25 minutes. This is the hardest of the six. Do not rush.
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
%          Write those numbers down too. You now have a table of four
%          rows. Build the whole table before you think about it.
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
%  IF YOU THINK THE WOBBLE IS JUST NOISE, TEST THAT
%  Run your Step 1 measurement again with N = 131070, then 131065,
%  then 131060. Five samples out of a hundred and thirty thousand.
%  If the answer still moves, it is not noise. Explain what it is.
%
%  YOU ARE DONE WHEN...
%   - you have the four-row table from Step 2 and can say how big the
%     disagreement is in dB;
%   - you have ONE sentence explaining what causes it, and it is about
%     where the FFT points land, not about noise;
%   - you have a second measurement that gives the same answer, within
%     a few tenths of a dB, at all four values of N - and you have the
%     four numbers to prove it does not wander;
%   - you have said which of your two numbers you would put in a
%     report, and why.
%
%  STUCK?      hint(4)
%  CHECK IT    selfcheck(4, x)   where x is how many dB the 98.2 MHz
%              station is ABOVE the 98.4 MHz station, using your
%              better, stable measurement.
%
disp(' ');
disp('CHALLENGE 4 - how strong is 98.2 MHz? Read the steps above.');
disp('  Build the table first. Do not try to be clever before you have the table.');
disp('  Hints: hint(4).   Check an answer: selfcheck(4, x).');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------




% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  CHALLENGE 5 - WHICH GAIN SETTING WOULD YOU ACTUALLY USE?
%  Time: about 15 minutes. There is no single right answer to (b)/(c).
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
%  YOU ARE DONE WHEN...
%   - you have four percentages: signal and noise, for both files, and
%     they add up sensibly;
%   - you have said what you did with the fake peak from Challenge 3 -
%     counted it as signal, or removed it - and why;
%   - your choice in (b) quotes TWO numbers, one about clarity and one
%     about how close the samples come to 1.0;
%   - part (c) names a number you would watch while setting the gain,
%     not just a gain value.
%
%  STUCK?      hint(5)
%  CHECK IT    selfcheck(5, x)   where x is the percentage of the
%              total captured power that is real radio signal in the
%              gain 50 dB file. Pass a number like 90, not 0.90.
%              selfcheck(5) with no number gives you the questions to
%              test parts (b) and (c) against.
%
disp(' ');
disp('CHALLENGE 5 - which gain setting, and why? Signal vs noise, and headroom.');
disp('  You must quote numbers for both files. "Bigger is better" is not an answer.');
disp('  Hints: hint(5).   Check an answer: selfcheck(5, x).');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------




% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  CHALLENGE 6 - HOW BUSY IS THIS BAND, REALLY?
%  Time: about 20 minutes.
% ====================================================================
%
%  THE SITUATION
%  A regulator asks you: of the ten 200 kHz channel slots in this 2 MHz
%  of spectrum, how many are IN USE? They want one number, and they
%  want the rule you used, because they are going to apply your rule to
%  a thousand more captures without you.
%
%  The ten slot centres are 97.0, 97.2, 97.4, 97.6, 97.8, 98.0, 98.2,
%  98.4, 98.6 and 98.8 MHz.
%
%  THE QUESTION - part (a)
%  Here are three candidate rules. Apply ALL THREE. They will give you
%  three different counts. That is the point of the exercise.
%
%    RULE A  The slot is occupied if the tallest point inside it is at
%            least 15 dB above the noise floor.
%
%    RULE B  The slot is occupied if the total power added up across
%            the whole slot is at least 6 dB above the noise power you
%            would expect in an empty slot of the same width.
%            (Noise power in a slot = noise power per FFT point,
%            multiplied by the number of points in the slot.)
%
%    RULE C  The slot is occupied if it passes RULE A, AND the total
%            power across the slot is at least 3 dB above the tallest
%            single point inside it.
%
%  Report, for each rule: the count, and which slots.
%
%  THE QUESTION - part (b)
%  Argue for ONE of them. You are going to hand this rule to somebody
%  who will run it on a thousand captures without you in the room.
%  Say which rule you would sign, and say what the other two get wrong.
%  Name the specific slot where they disagree.
%
%  THE QUESTION - part (c)
%  Take the rule you chose and change its numbers - stricter, then
%  looser. Show a small table: rule setting -> number of occupied
%  slots. Is there a setting where the count is stable, or does it
%  change every time you touch it? A count that is stable over a wide
%  range of settings is not automatically the right count. Say why.
%
%  A WARNING
%  A rule based only on "is there something big here" will let
%  something into your count that has no business being called an
%  occupied channel. If your count is bigger than you expected, go
%  back and look at Challenge 3.
%
%  YOU ARE DONE WHEN...
%   - you have three counts and three lists of slots, not one;
%   - you have named the slot that the rules disagree about, and said
%     what is physically sitting in it;
%   - you have chosen one rule and given a reason that would still
%     make sense to somebody looking at a different capture;
%   - you have the stricter/looser table from part (c).
%
%  STUCK?      hint(6)
%  CHECK IT    selfcheck(6, x)   where x is the number of slots you
%              would report to the regulator - your final count, from
%              the rule you chose to sign.
%
disp(' ');
disp('CHALLENGE 6 - how many of the ten slots are occupied?');
disp('  Apply all three rules. Get three counts. Then argue for one.');
disp('  Hints: hint(6).   Check an answer: selfcheck(6, x).');

% ---------------- YOUR ANSWER GOES BELOW THIS LINE ----------------




% ---------------- YOUR ANSWER GOES ABOVE THIS LINE ----------------


%% ====================================================================
%  CHALLENGE 7 - THE MYSTERY CAPTURE          *** STRETCH - OPTIONAL ***
%  Time: about 25 minutes. This is the hardest thing in the file.
%  Do it only if you have finished the six above. Nobody is expected
%  to get all the way through it, and that is fine.
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
%  YOU ARE DONE WHEN...
%   - every one of the six questions has an answer with a number or a
%     named piece of evidence behind it;
%   - your answer to 6 says what you would NEED, not just what you
%     cannot do;
%   - you have run the whole report again on the low-gain file and
%     marked each conclusion survived or collapsed;
%   - you can point to at least one conclusion that survived and one
%     that did not.
%
%  STUCK?      hint(7)
%  CHECK IT    selfcheck(7)   - there is no single number here, so it
%              asks you questions instead. If you think you can name
%              the tuned frequency, try selfcheck(7, x) with it.
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
disp('CHALLENGE 7 (STRETCH) - the mystery capture. Six-part report in comments below.');
disp('  Sample rate is known. Centre frequency is NOT. That is the whole point.');
disp('  Hints: hint(7).   Questions to test your report against: selfcheck(7).');

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
%  Pick one of these. They are open ended on purpose. There are no
%  hints and no self-check for these three - you are on your own, and
%  by now that is the point.
%
%  A. In Challenge 2 you found the shortest capture that shows all six
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
