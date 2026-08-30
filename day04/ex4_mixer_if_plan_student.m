%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 4 - Lesson 4 RF Components
%  Exercise  : 4 - Mixers and the IF plan   *** STUDENT STARTER FILE ***
%  Teaches   : what a mixer does to FREQUENCIES. It makes the sum and the
%              difference of whatever you feed it, and we keep the
%              difference - that is the IF. Then the sting: there is
%              always a SECOND input frequency that lands on exactly the
%              same IF, called the image, and it sits 2 x IF away from
%              the wanted channel. Killing it is the job of the RF filter
%              in front of the mixer - the filter from Exercise 3.
%  Run time  : about 15 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : Sections 1, 2 and 3 are TYPE ALONG - fill in the gaps.
%              Sections 4 and 5 are RUN AND SEE - they are already
%              complete. Do NOT type them. Run them and watch.
%              In the solo task in Section 5 you change ONE number.
%  How to use: click inside a section and press Run Section, one at a time.
%              Fill in every line that says YOUR CODE HERE.
%              Run Section 1 first - every later section uses its numbers.
% ====================================================================

%% Section 1 (TYPE ALONG) - a mixer makes two new frequencies
clear; clc;
f_RF = 2400;                    % the channel we want to receive, MHz
f_IF = 70;                      % the fixed IF this receiver works at, MHz
% GAP 1: a low-side LO sits one IF BELOW the wanted channel. Work out the
%        LO frequency, then the sum and the difference the mixer makes.
% Hint: leave the semicolons off so MATLAB prints all three answers.
f_LO_low = % YOUR CODE HERE
f_sum  = % YOUR CODE HERE
f_diff = % YOUR CODE HERE

%% Section 2 (TYPE ALONG) - two LO choices, the same IF
% GAP 2: a high-side LO sits one IF ABOVE the channel. Build it, then do
%        both LO choices at once using the vector LO.
% Hint: abs( ) throws the minus sign away, so both choices give 70 MHz.
f_LO_high = % YOUR CODE HERE
LO      = [f_LO_low f_LO_high]; % the two choices, side by side
IF_out  = % YOUR CODE HERE
SUM_out = % YOUR CODE HERE

%% Section 3 (TYPE ALONG) - the image: another station on the same IF
% GAP 3: the image is one IF on the FAR side of the LO from the channel.
%        Work out both images, how far each sits from the wanted channel,
%        and check that distance against twice the IF.
f_img_low   = % YOUR CODE HERE
f_img_high  = % YOUR CODE HERE
offset_low  = % YOUR CODE HERE
offset_high = % YOUR CODE HERE
check_2IF   = % YOUR CODE HERE

%% Section 4 (RUN AND SEE) - the RF filter is what kills the image
% What this block does: it builds a simple model of the band-pass filter
% that sits between the antenna and the mixer, draws it across 601 MHz of
% spectrum, and marks the wanted channel and both possible images on the
% picture. Then it prints how far DOWN each image is compared with the
% wanted channel. That number is the image rejection the filter buys you.
f0 = 2400;   BW = 80;   n = 3;   IL = 1.5;   % centre MHz, width MHz, poles, dB
f    = 2100:0.5:2700;                        % 1201 frequencies, in MHz
resp = -IL - 10*log10(1 + ((f-f0)/(BW/2)).^(2*n));
plot(f, resp, 'LineWidth', 2); grid on; ylim([-80 5])
xlabel('Frequency (MHz)'); ylabel('Preselector response (dB)')
title('RF filter in front of the mixer, with the images marked')
xline(f_RF, ':k');                           % the channel we want
xline(f_img_low,  '--r');                    % the low-side image
xline(f_img_high, '--r');                    % the high-side image
at_RF     = -IL - 10*log10(1 + ((f_RF-f0)/(BW/2))^(2*n))
at_img    = -IL - 10*log10(1 + ((f_img_low-f0)/(BW/2))^(2*n))
rejection = at_RF - at_img      % how much weaker the image arrives, in dB

%% Section 5 (RUN AND SEE) - SOLO VARIATION
% Task: change ONE number below - the IF goes from 70 MHz up to 140 MHz -
%       then run this section again. Everything else is worked out from
%       it. Write down two answers: where does the image move to, and
%       what does that do to the rejection the SAME filter gives you?
f_IF2      = 70;                             % <-- CHANGE 70 TO 140
f_LO2      = f_RF - f_IF2
f_img2     = f_LO2 - f_IF2
offset2    = f_RF - f_img2
at_img2    = -IL - 10*log10(1 + ((f_img2-f0)/(BW/2))^(2*n))
rejection2 = at_RF - at_img2
gained     = rejection2 - rejection
