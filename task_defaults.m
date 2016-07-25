function defaults = task_defaults
% DEFAULTS  Defines defaults for Why/How Localizer Task
%
% You can modify the values below to suit your particular needs. Note that
% some combinations of modifications may not work, so if you do modify
% anything, make sure to do a test run before running a subject. The default
% values were used in study used to validate the task. See:
%
%    Spunt, R. P., & Adolphs, R. (2014). Validating the why/how contrast
%    for functional mri studies of theory of mind. Neuroimage, 99, 301-311.
%
%__________________________________________________________________________
% Copyright (C) 2014  Bob Spunt, Ph.D.

% Paths
%==========================================================================
defaults.language       = 'english'; % 'english' (default) or 'german'
defaults.pace           = 'slow'; % 'fast' (default) or 'slow'
                                  % 'slow' gives participants more time to
                                  % read the question cues and make their
                                  % response and may be ideal for studies
                                  % in patient populations or children

% Screen Resolution
%==========================================================================
defaults.screenres      = [1024 768];   % recommended screen resolution (if
                                        % not supported by monitor, will
                                        % default to current resolution)

% Response Keys
%==========================================================================
defaults.escape         = 'ESCAPE'; % escape key (to exit early)
defaults.trigger        = '5%'; % task trigger key (to start task)
defaults.valid_keys     = {'1!' '2@' '3#' '4$'}; % valid response keys
% These correspond to the keys that the participant can use to make their
% responses during task performance. The key in the first position (e.g.,
% '1!') will be numerically coded as a 1 in the output data file; the key
% in the second position as a 3; and so on. Given that the subject is
% making a binary choice on each trial, you will need to specify AT LEAST
% two keys. If the subject is using a button box, it may be desirable to
% include all buttons on the box in case the subject winds up having their
% fingers on the wrong keys.

% Paths
%==========================================================================
defaults.path.base      = pwd;
defaults.path.data      = fullfile(defaults.path.base, 'data');
defaults.path.utilities = fullfile(defaults.path.base, 'ptb-utilities');
if strcmpi(defaults.language, 'german')
    defaults.path.stim      = fullfile(defaults.path.base, 'stimuli/german');
    defaults.path.design    = fullfile(defaults.path.base, 'design/german');
else
    defaults.path.stim      = fullfile(defaults.path.base, 'stimuli');
    defaults.path.design    = fullfile(defaults.path.base, 'design');
end
defaults.path.stimpractice  = fullfile(defaults.path.base, 'stimuli', 'practice');

% Text
%==========================================================================
defaults.font.name      = 'Arial'; % default font
defaults.font.size1     = 42; % default font size (smaller)
defaults.font.size2     = 46; % default font size (bigger)
defaults.font.wrap      = 42; % default font wrapping (arg to DrawFormattedText)
defaults.font.linesep   = 3;  % spacing between first and second lines of question cue.

% Timing (specify all in seconds)
%==========================================================================
defaults.TR             = 1;        % Your TR (in secs) - Task runtime will be adjusted
                                    % to a multiple of the TR
defaults.prestartdur    = 4;        % duration of fixation period after trigger
                                    % and before first block
defaults.ignoreDur      = 0.15;     % dur after trial presentation in which
                                    % button presses are ignored (this is
                                    % useful when participant provides a late
                                    % response to the previous trial)
                                    % DEFAULT VALUE = 0.15
defaults.practiceenddur = 2.5;      % Dur of fixation period following last practice trial
end


