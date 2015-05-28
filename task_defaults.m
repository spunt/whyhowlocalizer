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
defaults.trigger        = '5%'; % trigger key (to start ask)
defaults.valid_keys     = {'1!' '2@' '3#' '4$'}; % valid response keys
defaults.escape         = 'ESCAPE'; % escape key (to exit early)
                                
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

% Text 
%==========================================================================
defaults.font.name      = 'Arial'; % default font
defaults.font.size1     = 42; % default font size (smaller)
defaults.font.size2     = 46; % default font size (bigger)
defaults.font.wrap      = 42; % default font wrapping (arg to DrawFormattedText)

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
end


