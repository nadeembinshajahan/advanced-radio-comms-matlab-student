%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 2 - Electromagnetic Fundamentals
%  Exercise  : 3 - Polarization mismatch   *** STUDENT STARTER FILE ***
%  Teaches   : if the receive antenna is not lined up with the transmit
%              antenna, you lose signal. The loss follows a cos-squared
%              law: nothing at 0 degrees, exactly 3 dB at 45 degrees, and
%              a complete null at 90 degrees.
%  Run time  : about 14 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is TYPE ALONG - you write it all yourself.
%  How to use: click inside a section and press Run Section, one at a time.
%              Fill in every line that says YOUR CODE HERE.
%  NOTE      : cosd() takes DEGREES, so nobody has to convert to radians.
% ====================================================================

%% Section 1 (TYPE ALONG) - the loss at seven angles
clear; clc;
theta   = [0 15 30 45 60 75 90];     % angle between the two antennas, in degrees
% GAP 1: the cos-squared law - the fraction of power that survives.
% Hint: cosd(theta) then square every element with ".^".
factor  = % YOUR CODE HERE
% GAP 2: turn that fraction into a loss in dB.
% Hint: minus 10 times log10 of factor. Power uses 10, not 20.
loss_dB = % YOUR CODE HERE
disp('Power factor (1 = nothing lost):'); disp(factor)
disp('Polarization loss (dB):');          disp(loss_dB)

%% Section 2 (TYPE ALONG) - the whole curve from 0 to 90 degrees
th   = 0:1:90;                       % every degree from 0 to 90
% GAP 3: the same formula again, this time for the whole sweep.
loss = % YOUR CODE HERE
plot(th, loss, 'LineWidth', 2)
grid on; ylim([0 30])                % stop at 30 dB, the curve runs off to infinity
xlabel('Angle between the two antennas (degrees)')
ylabel('Polarization loss (dB)')
title('Polarization mismatch loss')

%% Section 3 (TYPE ALONG) - mark the 45 degree point
% GAP 4: draw a dashed horizontal line at 3.0103 dB and a dashed vertical
%        line at 45 degrees. They should cross exactly ON the curve.
% Hint: yline(3.0103, '--k')  and  xline(45, '--k')
hold on
% YOUR CODE HERE
% YOUR CODE HERE
hold off

%% Section 4 (TYPE ALONG) - the same law drawn as a polar pattern
clf                                  % clear the figure, a polar plot needs its own axes
th2 = 0:1:360;                       % all the way round the circle
% GAP 5: draw the pattern in polar form.
% Hint: polarplot(deg2rad(th2), abs(cosd(th2)), 'LineWidth', 2)
% YOUR CODE HERE
title('Received voltage vs angle - the figure of eight')

%% Section 5 (TYPE ALONG) - SOLO VARIATION
% Task: a hand-held radio held 30 degrees off vertical, and one lying nearly
%       flat at 80 degrees. How much does each one lose? Leave the semicolons
%       off so MATLAB prints the answers.
% GAP 6: build the two angles, then the factor and the loss in dB.
theta2  = % YOUR CODE HERE
factor2 = % YOUR CODE HERE
loss2   = % YOUR CODE HERE
