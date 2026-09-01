function selfcheck(k, value)
%SELFCHECK  Test your own answer to a challenge problem.
%
%   selfcheck(3, 98.0)   tests your answer to Challenge 3.
%   selfcheck(5)         for the judgement questions, asks you the
%                        questions a good answer has to survive.
%   selfcheck            prints this summary.
%
%   It tells you one of three things:
%      - your answer is right, and one sentence about why it is right;
%      - your answer is close but outside the tolerance, with a nudge
%        about the likely cause;
%      - your answer is wrong in a way it recognises, and it names the
%        mistake.
%   It never prints the correct value. Finding it is the exercise.
%
%   Each challenge in ex6_challenges.m says exactly what number to
%   pass in. If you pass the wrong kind of number, selfcheck will
%   usually notice and say so.
%
%   If you are stuck before you have a number, use  hint(k)  instead.
%
%   Needs plain MATLAB. No toolbox.

n_challenges = 7;

if nargin < 1
    usage(n_challenges);
    return
end

if ~isnumeric(k) || ~isscalar(k) || ~isreal(k) || ~isfinite(k) || ...
        k < 1 || k > n_challenges || k ~= fix(k)
    fprintf('\nselfcheck needs a challenge number from 1 to %d.\n', n_challenges);
    fprintf('For example:  selfcheck(3, 98.0)\n\n');
    return
end

if nargin < 2
    no_value(k);
    return
end

if ~isnumeric(value) || ~isscalar(value)
    fprintf('\n');
    fprintf('That is not a single number. selfcheck takes one value at a\n');
    fprintf('time, for example  selfcheck(%d, 12.5)\n\n', k);
    return
end

if ~isreal(value)
    fprintf('\n');
    fprintf('That is a complex number. Every answer here is a plain real\n');
    fprintf('number. If you are holding a spectrum value, you probably\n');
    fprintf('want abs() of it first.\n\n');
    return
end

if ~isfinite(value)
    fprintf('\n');
    fprintf('That value is NaN or Inf, so something upstream went wrong.\n');
    fprintf('A common cause is log10 of zero or of a negative number.\n');
    fprintf('Check the line that produced it, then try again.\n\n');
    return
end

switch k
    case 1, check1(value);
    case 2, check2(value);
    case 3, check3(value);
    case 4, check4(value);
    case 5, check5(value);
    case 6, check6(value);
    case 7, check7(value);
end
end


% ---------------------------------------------------------------- 1
function check1(v)
banner(1, 'the antenna penalty in dB');
s = abs(v);

if near(s, 24.78, 0.9)
    verdict('NOT YET');
    say('That is antenna B, the 3.1 cm Wi-Fi stub, not antenna A.');
    say('Run the same three lines again with h = 0.086.');
elseif near(s, 11.24, 0.9)
    verdict('NOT YET');
    say('That is antenna D, the 15 cm offcut, not antenna A.');
    say('Run the same three lines again with h = 0.086.');
elseif near(s, 3.97, 0.7)
    verdict('NOT YET');
    say('That is the telescopic whip pulled out to about half the');
    say('right length. Antenna A is the 8.6 cm Pluto whip.');
elseif near(s, 31.92, 1.4)
    verdict('NOT YET');
    say('You have doubled it. eta is already a ratio of POWER, so it');
    say('takes 10*log10, not 20*log10. Day 1 Exercise 1: 10 for');
    say('power, 20 for voltage.');
elseif s > 0 && s < 2.5
    verdict('NOT YET');
    say('That looks like your part (a) answer - the spread of the six');
    say('quarter-wave lengths, in centimetres or in percent.');
    say('selfcheck(1,...) wants the part (b) number: how many dB you');
    say('lose with the 8.6 cm whip compared with a proper quarter');
    say('wave at 98.2 MHz.');
elseif near(s, 15.96, 0.6)
    verdict('CORRECT');
    say('At 98 MHz an 8.6 cm whip is about a thirty-fifth of a');
    say('wavelength, so the resistance it offers is a fraction of an');
    say('ohm against a 50 ohm receiver input. Almost all the power');
    say('available at the antenna never gets into the radio. The');
    say('penalty is a mismatch, not a length.');
    say(' ');
    say('Now finish part (c): subtract this from each station''s');
    say('margin above the noise and see which ones you lose.');
elseif s > 12.5 && s < 20
    verdict('CLOSE - BUT NOT INSIDE THE TOLERANCE');
    say('You are in the right region, so the method is right and');
    say('something small is off. The two usual causes:');
    say('  - you compared the whip against a perfect match instead of');
    say('    against the quarter-wave whip you were told to use;');
    say('  - you used a different length for h. Use 0.086 m, the');
    say('    radiating element only.');
elseif s > 40 || s < 0.5
    verdict('NOT YET');
    say('That is not the size of a dB penalty for a short whip.');
    say('Check that eta came out between 0 and 1 before you took');
    say('10*log10 of it. If eta is bigger than 1 you have swapped');
    say('something in the formula.');
else
    verdict('NOT YET');
    say('Work it through in this order and check each step prints a');
    say('sensible number: h/lambda, then Rr in ohms, then eta as a');
    say('fraction between 0 and 1, then 10*log10(eta).');
    say('Then do the same for the quarter wave using the Rr you were');
    say('given, and subtract.');
end
tail(1);
end


% ---------------------------------------------------------------- 2
function check2(v)
banner(2, 'a number of samples');

if v <= 0 || v ~= fix(v)
    verdict('NOT YET');
    say('That is not a whole number of samples. Pass the length of');
    say('the piece of recording you used, for example selfcheck(2, 64).');
    say('If you were about to give microseconds, convert first:');
    say('samples = microseconds * fs / 1e6.');
    tail(2);
    return
end

if v >= 20 && v <= 40
    verdict('CORRECT  (this is part (a))');
    say('At that length the FFT points are close enough together that');
    say('at least one of them falls between the two stations and');
    say('reads lower than both, so you can point at the gap and');
    say('honestly call it two signals.');
    if v > 32
        say(' ');
        say('It works, but it is not the shortest that works. Try');
        say('trimming it and watch the gap close.');
    end
    say(' ');
    say('Part (b) is a completely different number. Check that too.');
elseif v >= 9 && v < 20
    verdict('NOT YET');
    say('You have done the arithmetic - fs/N about equal to the 200');
    say('kHz spacing - but not the check. At that length the two');
    say('stations land in FFT points that touch, with nothing');
    say('between them, so they merge into one lump.');
    say('Plot it. If you cannot point at a dip between two peaks, you');
    say('have not separated them. Then go a little longer.');
elseif v < 9
    verdict('NOT YET');
    say('Far too short. With that few samples the whole 2 MHz span is');
    say('covered by a handful of FFT points, each one hundreds of kHz');
    say('wide. Work out fs/N for your value and compare it with the');
    say('200 kHz you are trying to resolve.');
elseif v >= 850 && v <= 1400
    verdict('NOT YET  -  and this is the classic one');
    say('This is right for the first slice of the file and wrong as a');
    say('general claim. You have almost certainly only tested');
    say('x = iq(1:n).');
    say('Try  x = iq(20001:20000+n)  and count the stations again.');
    say('Then try two more starting points. At this length at least');
    say('one slice loses a station, and the honest answer is the');
    say('worst case, not the first one you got.');
elseif v >= 1800 && v <= 2600
    verdict('CORRECT  (this is part (b))  -  with one caution');
    say('At this length the noise floor of the short piece has come');
    say('down far enough that even the two quiet stations stand');
    say('clear of it. That is processing gain: more samples, lower');
    say('noise floor, same station heights.');
    say(' ');
    say('The caution: this is close to the boundary. Test it on');
    say('several different starting points before you sign it - some');
    say('slices are less kind than others.');
elseif v > 2600 && v <= 8192
    verdict('CORRECT  (this is part (b))');
    say('At this length every one of the six stands clear of the');
    say('noise floor, and it keeps doing so wherever in the recording');
    say('you take the slice from. That is the difference between an');
    say('answer and a lucky answer.');
    say(' ');
    say('Say in one sentence why this is so much longer than your');
    say('part (a) answer. Resolution and detection are not the same');
    say('problem.');
elseif v > 8192
    verdict('LONGER THAN YOU NEED');
    say('That certainly works, but the question asked for the');
    say('SHORTEST piece. Halve it and test again. Keep halving until');
    say('a station disappears, then go back one step.');
else
    verdict('NOT YET');
    say('That is longer than part (a) needs and shorter than part (b)');
    say('needs, so first decide which part this number is for.');
    say('For (a): can you see a dip between the two peaks?');
    say('For (b): do all six stations stand above the noise, on every');
    say('starting point you try?');
end
tail(2);
end


% ---------------------------------------------------------------- 3
function check3(v)
banner(3, 'a frequency in MHz');
f = v;
if abs(f) > 1e6
    f = f/1e6;
end

if abs(f) < 0.01
    verdict('CORRECT');
    say('Zero offset from the tuned frequency is the same place. Well');
    say('read - that is exactly why it is there.');
    say(' ');
    impostor_why();
elseif near(f, 98.0, 0.02)
    verdict('CORRECT');
    impostor_why();
elseif near(f, 98.2, 0.03)
    verdict('NOT YET');
    say('That is the strongest transmitter in the capture. Big is not');
    say('the same as fake. Look for the peak that carries no');
    say('information, not the one that carries the most power.');
elseif near(f, 97.2, 0.03) || near(f, 97.4, 0.03)
    verdict('NOT YET');
    say('That is one of the two quietest real stations. Quiet is not');
    say('the same as fake either. Your test has to ask whether a peak');
    say('carries information, not how loud it is.');
elseif near(f, 97.8, 0.03) || near(f, 98.4, 0.03) || near(f, 98.8, 0.03)
    verdict('NOT YET');
    say('That is one of the six real transmitters. Apply the');
    say('mean-subtraction test to all seven peaks and see which one');
    say('is the only one that moves.');
elseif f > 96.9 && f < 99.1
    verdict('NOT YET');
    say('There is no peak at that frequency. List the seven peak');
    say('positions first - Exercise 6 Section 6 shows you how - then');
    say('test all seven.');
else
    verdict('NOT YET');
    say('I expected a frequency in MHz, somewhere inside the 2 MHz');
    say('this capture covers. If you meant an offset from the tuned');
    say('frequency, pass 0 for the centre.');
end
tail(3);
end

function impostor_why()
say('It sits at exactly the frequency the receiver was tuned to, it');
say('has no hump of modulation around it, it holds far steadier');
say('than any real station across the capture, and subtracting');
say('mean(iq) deletes it while leaving all six stations untouched.');
say('That is a constant in the samples, which is a spike at zero');
say('frequency: the receiver''s own DC offset.');
say(' ');
say('Now make sure you have reported a test that FAILED as well.');
say('That half of the challenge is worth more than this half.');
end


% ---------------------------------------------------------------- 4
function check4(v)
banner(4, 'a difference in dB between two stations');

if v < 0 && (near(-v, 10.35, 0.7) || near(-v, 16.25, 0.7))
    verdict('NOT YET');
    say('That looks like the level of one channel on its own, not the');
    say('difference between two. Measure both stations the same way,');
    say('then subtract one from the other.');
    tail(4); return
end

flipped = v < 0;
s = abs(v);

if near(s, 7.72, 0.22)
    verdict('NOT YET  -  and this is the trap');
    say('That is the single-point reading using the whole capture,');
    say('N = 131072. It is the number almost everybody reports.');
    say('Do the identical measurement at N = 4096, then at N = 2048.');
    say('The station did not change. If your answer changes, you are');
    say('measuring where the FFT points happen to land, not the');
    say('station.');
elseif near(s, 1.82, 0.30)
    verdict('NOT YET  -  and this is the trap');
    say('That is the single-point reading at N = 4096. Do the same');
    say('measurement on the whole capture and you will get a very');
    say('different number from identical data.');
    say('Neither of them is the honest answer. Stop reading one');
    say('point.');
elseif near(s, 8.49, 0.12)
    verdict('NOT YET  -  and this is the trap');
    say('That is the single-point reading at N = 2048. Try it at');
    say('N = 4096 as well and watch the answer collapse.');
elseif near(s, 8.28, 0.12)
    verdict('NOT YET  -  and this is the trap');
    say('That is the single-point reading at N = 32768. Try it at');
    say('N = 4096 as well and watch the answer collapse.');
elseif near(s, 3.65, 0.20) || near(s, 4.31, 0.20) || ...
        near(s, 4.47, 0.20) || near(s, 6.57, 0.20)
    verdict('NOT YET');
    say('That is what you get by reading a single FFT point at one');
    say('particular N. Repeat it at three more values of N and put');
    say('the four answers side by side before you go further.');
elseif near(s, 11.74, 0.7)
    verdict('NOT YET');
    say('You have doubled it. You summed POWER across the channel and');
    say('then took 20*log10 of it. Power takes 10*log10.');
    say('Day 1 Exercise 1, the 10 versus 20 rule.');
elseif near(s, 5.87, 0.45)
    if flipped
        verdict('CORRECT  -  but the wrong way round');
        say('The size is right. Check your subtraction: the question');
        say('asks how far 98.2 MHz is ABOVE 98.4 MHz, and 98.2 is the');
        say('stronger of the two.');
    else
        verdict('CORRECT');
    end
    say(' ');
    say('That is what you get by adding up the power across each');
    say('station''s whole channel instead of reading its tallest');
    say('point. It stays put at every N because it no longer depends');
    say('on where the FFT grid happens to fall.');
    say(' ');
    say('Confirm it: run your measurement at N = 131072, 32768, 4096');
    say('and 2048. If those four agree to a few tenths of a dB, you');
    say('have something you can sign.');
elseif s > 6.3 && s < 7.5
    verdict('CLOSE - BUT NOT INSIDE THE TOLERANCE');
    say('The method is probably right and the window is probably');
    say('wrong. Two usual causes:');
    say('  - your channel window is wide enough to catch part of the');
    say('    neighbouring station 200 kHz away. Keep it under 200 kHz');
    say('    wide so it cannot reach the neighbour;');
    say('  - the noise inside the window is counted as station power.');
    say('    Try subtracting the noise power of the same window.');
elseif s > 4.9 && s <= 5.42
    verdict('CLOSE - BUT NOT INSIDE THE TOLERANCE');
    say('Slightly too small. Check that both channels use exactly the');
    say('same window width, and that you are summing abs(X).^2 and');
    say('not abs(X).');
elseif s > 20
    verdict('NOT YET');
    say('Far too big for the gap between these two stations. If your');
    say('levels are near +90 dB you have forgotten to divide by');
    say('numel(x) squared. That is a constant, so it cancels in a');
    say('difference - which means an error this big is somewhere');
    say('else. Print both levels before you subtract them.');
else
    verdict('NOT YET');
    say('Build the four-row table first: measure both stations at');
    say('N = 131072, 32768, 4096 and 2048 and write all eight numbers');
    say('down. The pattern in that table is the whole challenge.');
end
tail(4);
end


% ---------------------------------------------------------------- 5
function check5(v)
banner(5, 'a percentage of the total captured power');

if v > 0 && v < 1.02
    verdict('NOT YET');
    say('Pass a percentage, like 90, not a fraction like 0.90.');
    say('Multiply by 100 and try again.');
    tail(5); return
end

if v < 0 || v > 100
    verdict('NOT YET');
    say('A share of the total power has to be between 0 and 100');
    say('percent. Check what you divided by: it should be the total');
    say('power of the whole capture.');
    tail(5); return
end

if near(v, 96.4, 0.8)
    verdict('NOT YET');
    say('You have counted the fake peak from Challenge 3 as signal.');
    say('It is worth two to three percent of everything the radio');
    say('recorded. Decide whether a fault inside your own receiver');
    say('belongs in a figure you are calling signal, then say which');
    say('choice you made and why.');
elseif v > 98.6
    verdict('NOT YET');
    say('Too high, and there is one usual reason: the noise level you');
    say('measured in the quiet band is per FFT point. There are');
    say('numel(x) points across the whole span. Multiply before you');
    say('subtract.');
elseif near(v, 93.9, 1.5)
    verdict('CORRECT');
    say('At 50 dB of gain the noise floor sits far below the');
    say('stations, so nearly everything the radio recorded is real');
    say('signal. That is what high gain buys you.');
elseif near(v, 40.9, 2.0)
    verdict('NOT YET');
    say('That is the gain 20 dB file. The question asked for the');
    say('gain 50 dB one. Worth noticing though: at 20 dB most of what');
    say('the radio recorded is the radio listening to itself.');
elseif near(v, 3.6, 1.0)
    verdict('NOT YET');
    say('That is the NOISE share at gain 50, not the signal share.');
    say('The two have to add up to 100.');
elseif near(v, 58.7, 2.0)
    verdict('NOT YET');
    say('That is the noise share of the gain 20 dB file. Two things');
    say('swapped at once: the file, and signal for noise.');
elseif v > 85
    verdict('CLOSE - BUT NOT INSIDE THE TOLERANCE');
    say('The method is right and something small is off. Check where');
    say('you measured the noise floor - if your quiet band clips the');
    say('edge of a station, the noise looks far too big.');
    say('Plot the band you used and look at it.');
else
    verdict('NOT YET');
    say('Too low for the high gain file. Check three things:');
    say('  - is your quiet band really empty? Plot it.');
    say('  - are you working in power, (abs(X)/n).^2, all the way');
    say('    through?');
    say('  - does sum(P) agree with mean(abs(x).^2)? If not, the');
    say('    normalising is wrong and everything after it is too.');
end
judgement5();
tail(5);
end

function judgement5()
say(' ');
say('PARTS (b) AND (c) HAVE NO SINGLE RIGHT ANSWER.');
say('Test what you wrote against these three questions:');
say('  1. Did you quote a clarity number AND a headroom number in');
say('     the same sentence? One of each, not two of one.');
say('  2. How many dB is the biggest sample in the gain 50 file');
say('     below full scale - and what happens to your capture if a');
say('     signal arrives tomorrow that is stronger than that?');
say('  3. If you would ask for a third setting, what number would');
say('     you watch on screen to know you had reached it?');
say('A good answer names a cost for the setting it chooses. An');
say('answer that only lists advantages has not made a decision.');
end


% ---------------------------------------------------------------- 6
function check6(v)
banner(6, 'a number of occupied slots');

if v < 0 || v > 10 || v ~= fix(v)
    verdict('NOT YET');
    say('There are ten slots, so the count is a whole number from 0');
    say('to 10. Pass the count from the rule you would sign.');
    tail(6); return
end

if v == 7
    verdict('NOT YET');
    say('Seven is what a rule gets when it only asks "is there');
    say('something big here". Six of your seven are transmitters.');
    say('The seventh is the peak you exposed in Challenge 3.');
    say('Ask yourself what is transmitting in that slot. Nothing is.');
    say('A regulator would be counting a fault in your receiver as an');
    say('occupied channel.');
elseif v == 5
    verdict('NOT YET');
    say('Five is what the whole-slot-power rule gives on its own. It');
    say('throws out the fault, which is good, but it throws out the');
    say('two quietest real stations with it.');
    say('Name the two slots you lost and look at them. Are they');
    say('empty? If they are not, your rule is too blunt.');
elseif v == 10
    verdict('NOT YET');
    say('Every slot occupied means your threshold is below the noise.');
    say('Noise alone wanders by more than a few dB from point to');
    say('point. Ask your rule what it says about a slot with nothing');
    say('in it at all - if it says occupied, the rule is broken.');
elseif v == 6
    verdict('CORRECT  -  now check you have the RIGHT six');
    say('Six is defensible, and only one of the three rules gets');
    say('there honestly. Print your six slot centres and check them.');
    say('It is possible to get six by setting a threshold so high');
    say('that you throw away a real quiet station while still');
    say('keeping the fault: right number, wrong six, and that is how');
    say('bad measurements pass review.');
    say(' ');
    say('Your six should contain no slot that fails a modulation');
    say('test, and no slot whose peak is only noise.');
elseif v == 8 || v == 9
    verdict('NOT YET');
    say('Too many. Some of your slots contain nothing but noise that');
    say('happened to peak. Compare each slot peak with the noise');
    say('floor before you count it.');
elseif v >= 2 && v <= 4
    verdict('NOT YET');
    say('Too strict - you are throwing away real transmitters. Which');
    say('slots did you drop, and what is actually in them? Loosen the');
    say('rule one step at a time and watch which slot comes back');
    say('first.');
else
    verdict('NOT YET');
    say('That count says almost nothing is on air. Plot the spectrum');
    say('and count the obvious peaks by eye first, then make your');
    say('rule agree with your eyes before you trust it anywhere else.');
end
judgement6();
tail(6);
end

function judgement6()
say(' ');
say('PART (b) IS A JUDGEMENT, NOT A NUMBER.');
say('Test your argument against these questions:');
say('  1. Which single slot do the three rules disagree about, and');
say('     what is physically sitting in it?');
say('  2. Your rule will be run on a thousand captures you never');
say('     see. What would it do on a capture where every station is');
say('     10 dB weaker?');
say('  3. Over what range of settings does your count stay the same?');
say('     A count that is stable over a wide range is easier to');
say('     defend - but stable is not the same as correct. Say which');
say('     one yours is.');
end


% ---------------------------------------------------------------- 7
function check7(v)
banner(7, 'no single number - this one is a report');

if v >= 87.5 && v <= 108
    verdict('NOT YET  -  and this is the whole point of the challenge');
    say('You have named an absolute frequency in the FM broadcast');
    say('band. Nothing inside these samples carries an absolute');
    say('frequency. The capture was handed to you with the tuning');
    say('deliberately removed, so that number came from somewhere');
    say('else - your memory of the earlier challenges, most likely.');
    say(' ');
    say('Saying "I cannot determine that from this data, and here is');
    say('what I would need" is the best answer in the whole file.');
    say('Saying a number you cannot support is inventing evidence.');
elseif v == 0
    verdict('READ THAT AS: the tuned frequency itself');
    say('Zero offset is where the receiver was tuned, and where the');
    say('DC spike sits. True, and useful for question 5 - but it is');
    say('not an absolute frequency, which is what question 6 asks.');
else
    verdict('THERE IS NO SINGLE NUMBER FOR THIS ONE');
    say('Challenge 7 is marked on the reasoning in your six answers,');
    say('not on any one value.');
end
judgement7();
tail(7);
end

function judgement7()
say(' ');
say('QUESTIONS YOUR REPORT HAS TO SURVIVE:');
say('  1. For question 1, what number did you use to decide between');
say('     AM and FM? "It looks like FM" is not evidence. How much of');
say('     each channel''s power sits in the carrier point itself?');
say('  2. For question 2, is every gap between signals a whole');
say('     multiple of one number? An accidental collection of');
say('     transmitters would not do that. A channel plan would.');
say('  3. For question 6, did you say what you would NEED in order');
say('     to answer it? Name the three routes: receiver metadata, a');
say('     transmitter of known frequency inside the capture, or a');
say('     second capture at a different tuning.');
say(' ');
say('A good report separates what the data supports from what you');
say('believe. It also says which of its conclusions survived the');
say('low-gain file and which fell apart. If you have not run it on');
say('lo.iq yet, that paragraph is still missing.');
end


% ------------------------------------------------------- plumbing
function t = near(v, target, tol)
t = abs(v - target) <= tol;
end

function banner(k, expects)
fprintf('\n');
fprintf('============================================================\n');
fprintf('SELF-CHECK  -  CHALLENGE %d\n', k);
fprintf('expecting: %s\n', expects);
fprintf('============================================================\n');
end

function verdict(word)
fprintf('%s\n', word);
fprintf('------------------------------------------------------------\n');
end

function say(s)
fprintf('%s\n', s);
end

function tail(k)
fprintf('------------------------------------------------------------\n');
fprintf('Stuck? hint(%d).   Checked something else? selfcheck(%d, x).\n\n', k, k);
end

function no_value(k)
fprintf('\n');
switch k
    case 5
        banner(5, 'a percentage of the total captured power');
        say('Part (a) has a number: pass the percentage of the gain');
        say('50 dB capture that is real radio signal, as selfcheck(5, x).');
        judgement5();
    case 6
        banner(6, 'a number of occupied slots');
        say('Pass the count you would give the regulator, from the rule');
        say('you decided to sign, as selfcheck(6, x).');
        judgement6();
    case 7
        banner(7, 'no single number - this one is a report');
        say('There is no value to check here. Mark your own report');
        say('against the questions below.');
        judgement7();
    otherwise
        fprintf('selfcheck(%d, x) needs your answer as the second input.\n', k);
        fprintf('Challenge %d in ex6_challenges.m says exactly what x is.\n', k);
        fprintf('If you do not have a number yet, try  hint(%d)  instead.\n', k);
end
fprintf('\n');
end

function usage(n_challenges)
fprintf('\n');
fprintf('SELF-CHECK FOR THE CHALLENGE PROBLEMS\n');
fprintf('  selfcheck(3, 98.0)   test your answer to Challenge 3\n');
fprintf('  selfcheck(7)         judgement questions, no number needed\n');
fprintf('\n');
fprintf('There are %d challenges. Each one tells you what number to\n', n_challenges);
fprintf('pass in. selfcheck says whether you are right, or close, or\n');
fprintf('wrong in a way it recognises - and it never prints the answer.\n');
fprintf('\nStuck before you have a number? Use  hint(k)  instead.\n\n');
end
