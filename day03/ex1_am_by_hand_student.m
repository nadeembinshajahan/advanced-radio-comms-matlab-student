%% ====================================================================
%  Course    : Advanced Radio Communications  (Beacon Red)
%  Day       : 3 - Modulation Techniques
%  Exercise  : 1 - AM by hand   *** STUDENT STARTER FILE ***
%  Teaches   : an AM signal is just (1 + mu*message) multiplied by the
%              carrier. The modulation index mu decides how deep the
%              envelope swings. Below 1 the envelope is safe, at 1 it
%              just touches zero, above 1 it goes negative and the
%              message is destroyed. That is OVER-MODULATION.
%  Run time  : about 15 minutes.
%  Needs     : plain MATLAB (MATLAB Online is fine). No toolbox.
%  TIER      : every section is TYPE ALONG - you write it all yourself.
%  How to use: click inside a section and press Run Section, one at a time.
%              Fill in every line that says YOUR CODE HERE.
%              Run Section 1 first - every later section uses t, m and c.
% ====================================================================

%% Section 1 (TYPE ALONG) - the message and the carrier
clear; clc;
Fs = 20000;                       % 20 000 samples every second
t  = 0:1/Fs:0.03-1/Fs;            % exactly 600 samples = 0.03 second
fm = 100;                         % message tone: 100 Hz (the voice)
fc = 1000;                        % carrier: 1000 Hz (the radio)
% GAP 1: build the message wave and the carrier wave.
% Hint: both are cosines. The pattern is cos(2*pi*frequency*t).
m  = % YOUR CODE HERE
c  = % YOUR CODE HERE
plot(t, m, 'LineWidth', 2); grid on; hold on
plot(t, c)
hold off
xlabel('Time (s)'); ylabel('Amplitude'); title('Message (thick) and carrier (thin)')
legend('Message 100 Hz', 'Carrier 1000 Hz')

%% Section 2 (TYPE ALONG) - AM with mu = 0.5  (under-modulated, safe)
mu  = 0.5;                        % modulation index
% GAP 2: build the envelope, then the AM signal.
% Hint: envelope = 1 + mu*m.  AM signal = envelope times carrier.
% Hint: two vectors multiplied together need ".*" and not "*".
env = % YOUR CODE HERE
s   = % YOUR CODE HERE
plot(t, s); grid on; hold on
plot(t, env, 'r', 'LineWidth', 2)
plot(t, -env, 'r', 'LineWidth', 2)
hold off
ylim([-3 3]); xlabel('Time (s)'); ylabel('Amplitude'); title('AM with mu = 0.5')
Emax = max(env)                   % the fattest part of the envelope
Emin = min(env)                   % the thinnest part

%% Section 3 (TYPE ALONG) - AM with mu = 1.0  (100 percent modulation)
mu  = 1.0;                        % <-- only this number changed
env = 1 + mu*m;
s   = env .* c;
plot(t, s); grid on; hold on
plot(t, env, 'r', 'LineWidth', 2)
plot(t, -env, 'r', 'LineWidth', 2)
hold off
ylim([-3 3]); xlabel('Time (s)'); ylabel('Amplitude'); title('AM with mu = 1.0')
Emax = max(env)
Emin = min(env)                   % watch this one closely

%% Section 4 (TYPE ALONG) - AM with mu = 1.5  (OVER-modulated, broken)
mu  = 1.5;                        % <-- only this number changed
env = 1 + mu*m;
s   = env .* c;
plot(t, s); grid on; hold on
plot(t, env, 'r', 'LineWidth', 2)
plot(t, -env, 'r', 'LineWidth', 2)
hold off
ylim([-3 3]); xlabel('Time (s)'); ylabel('Amplitude'); title('AM with mu = 1.5 - OVER-modulated')
Emax = max(env)
Emin = min(env)                   % what does a NEGATIVE envelope mean?

%% Section 5 (TYPE ALONG) - SOLO VARIATION
% Task: set mu to 0.8. Then get the modulation index BACK out of the
%       envelope with the standard receiver formula
%           mu = (Emax - Emin) / (Emax + Emin)
%       Do you get 0.8 again?
% GAP 3: set mu, build the envelope and the signal, then use the formula.
mu  = % YOUR CODE HERE
env = % YOUR CODE HERE
s   = % YOUR CODE HERE
plot(t, s); grid on; hold on
plot(t, env, 'r', 'LineWidth', 2)
plot(t, -env, 'r', 'LineWidth', 2)
hold off
ylim([-3 3]); xlabel('Time (s)'); ylabel('Amplitude'); title('AM with mu = 0.8')
Emax     = max(env)
Emin     = min(env)
mu_check = % YOUR CODE HERE
