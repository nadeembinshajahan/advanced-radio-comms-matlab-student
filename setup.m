%% ====================================================================
%  setup.m  -  gets everything you need for the real-spectrum work
%
%  WHAT IT DOES
%  Downloads, into the folder you are in right now:
%    - the spectrum exercise      ex6_real_spectrum_student.m
%    - the challenge problems     ex6_challenges.m
%    - the two sample captures    fm_capture_98MHz.mat  and  ..._lowgain.mat
%    - six short exploration scripts, for when you finish early
%  The files are saved with plain names, so the exercises find the
%  captures straight away. A second copy of the two captures is placed
%  in a data/ folder, because the exploration scripts look for them
%  there.
%
%  HOW TO USE IT
%  Type this and press Enter:      setup
%  Then open  ex6_real_spectrum_student.m  and work down from Section 1.
%
%  RE-RUNNING IS SAFE. Every file is fetched again and overwrites the
%  old copy, so this is also how you get a clean set back if you have
%  edited one into a corner. Anything you want to keep, rename first.
%
%  Needs plain MATLAB and an internet connection. No toolbox.
% ====================================================================

function setup()

% The one place to change if the files ever move.
base = 'https://raw.githubusercontent.com/nadeembinshajahan/advanced-radio-comms-matlab-student/main/';

% Column 1: where the file lives in the repository.
% Column 2: what to call it here, in this folder.
files = {
    'day02/ex6_real_spectrum_student.m',  'ex6_real_spectrum_student.m'
    'day02/ex6_challenges.m',             'ex6_challenges.m'
    'data/fm_capture_98MHz.mat',          'fm_capture_98MHz.mat'
    'data/fm_capture_98MHz_lowgain.mat',  'fm_capture_98MHz_lowgain.mat'
    'day01/explore01_resolution.m',       'explore01_resolution.m'
    'day01/explore02_windowing.m',        'explore02_windowing.m'
    'day01/explore03_zoom_station.m',     'explore03_zoom_station.m'
    'day01/explore04_iq_time.m',          'explore04_iq_time.m'
    'day01/explore05_gain_noise_floor.m', 'explore05_gain_noise_floor.m'
    'day01/explore06_relative_power.m',   'explore06_relative_power.m'
    };

n = size(files, 1);
fprintf('Downloading %d files into:\n   %s\n\n', n, pwd);

got    = {};
missed = {};

for k = 1:n
    remote = [base files{k,1}];
    local  = files{k,2};
    try
        websave(local, remote);
        fprintf('   ok    %s\n', local);
        got{end+1} = local;                              %#ok<AGROW>
    catch err
        fprintf('   FAILED %s\n          %s\n', local, err.message);
        missed{end+1} = local;                           %#ok<AGROW>
    end
end

%% ---- second copy of the captures, for the exploration scripts -----
% explore01 to explore06 load 'data/fm_capture_98MHz.mat'. The two
% exercise files load the same captures by plain name. Keeping a copy
% in both places means every script here works with no editing.
captures = {'fm_capture_98MHz.mat', 'fm_capture_98MHz_lowgain.mat'};

if exist('data', 'dir') ~= 7
    try
        mkdir('data');
    catch err
        fprintf('   FAILED could not make a data folder\n          %s\n', err.message);
    end
end

for k = 1:numel(captures)
    here  = captures{k};
    there = fullfile('data', here);
    try
        if exist(here, 'file') == 2 && exist('data', 'dir') == 7
            copyfile(here, there, 'f');
            fprintf('   ok    data/%s\n', here);
            got{end+1} = ['data/' here];                 %#ok<AGROW>
        else
            fprintf('   FAILED data/%s   (nothing to copy)\n', here);
            missed{end+1} = ['data/' here];              %#ok<AGROW>
        end
    catch err
        fprintf('   FAILED data/%s\n          %s\n', here, err.message);
        missed{end+1} = ['data/' here];                  %#ok<AGROW>
    end
end

%% ---- what happened -----------------------------------------------
fprintf('\n------------------------------------------------------\n');
fprintf('%d of %d files are here.\n', numel(got), numel(got) + numel(missed));

if isempty(missed)
    fprintf('\nYou are ready. Open  ex6_real_spectrum_student.m  and start\n');
    fprintf('at Section 1. The challenge problems are in  ex6_challenges.m\n');
    fprintf('and start at Section 0.\n');
else
    fprintf('\nThese did not arrive:\n');
    for k = 1:numel(missed)
        fprintf('   %s\n', missed{k});
    end
    fprintf('\nCheck your internet connection and run  setup  again.\n');
    fprintf('If only the exploration scripts are missing you can still\n');
    fprintf('do the exercise: open  ex6_real_spectrum_student.m  and\n');
    fprintf('start at Section 1.\n');
end
fprintf('------------------------------------------------------\n');

end
