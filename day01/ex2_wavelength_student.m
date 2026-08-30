%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 1 - Introduction to Wireless Communications
%  Exercise  : 2 - Wavelength calculator   *** STUDENT STARTER FILE ***
%  Teaches   : lambda = c / f, how to divide a whole vector at once with
%              "./", and why a log-log plot turns this into a straight line.
%  Run time  : about 12 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is TYPE ALONG - you write it all yourself.
%  How to use: click inside a section and press Run Section, one at a time.
%              Fill in every line that says YOUR CODE HERE.
% ====================================================================

%% Section 1 (TYPE ALONG) - wavelength for frequencies we use on this course
clear; clc;
c = 3e8;                                    % speed of light, metres per second
f = [30e6 144e6 433e6 915e6 2.4e9 5.8e9];   % frequencies, in Hz
% GAP 1: work out the wavelength of every frequency in one line.
% Hint: f is a vector, so you need "./" and not "/".
lambda = % YOUR CODE HERE

%% Section 2 (TYPE ALONG) - how long is a quarter-wave antenna?
quarter = lambda / 4;                       % a quarter of a wavelength
disp('Wavelength (m):');   disp(lambda)
disp('Quarter-wave (m):'); disp(quarter)

%% Section 3 (TYPE ALONG) - log-log plot from 1 MHz to 10 GHz
f_sweep = logspace(6, 10, 200);             % 200 points, spread on a log scale
% GAP 2: plot wavelength against frequency with both axes on a log scale.
% Hint: the command is loglog(f_sweep, c./f_sweep, 'LineWidth', 2)
% YOUR CODE HERE
grid on; hold on
loglog(f, lambda, 'ro', 'MarkerFaceColor', 'r')   % mark our six frequencies
xlabel('Frequency (Hz)'); ylabel('Wavelength (m)'); title('Wavelength vs frequency')
hold off

%% Section 4 (TYPE ALONG) - SOLO VARIATION
% Task: add FM radio at 88 MHz and GPS L1 at 1.575 GHz to the list.
%       What is the wavelength, and how long is a quarter-wave antenna?
% GAP 3: build the new frequency list, then the wavelengths and quarter-waves.
f2       = % YOUR CODE HERE
lambda2  = % YOUR CODE HERE
quarter2 = % YOUR CODE HERE
