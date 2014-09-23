function defaults = task_defaults
% DEFAULTS  Defines defaults for Why/How Localizer Task
%
% You can modify the values below to suit your particular needs. Note that
% some combinations of modifications may not work, so if you do modify 
% anything, make sure to do a test run before running a subject. The values
% currently specified were used in study used to validate the task. See:
%
%    Spunt, R. P., & Adolphs, R. (2014). Validating the why/how contrast 
%    for functional mri studies of theory of mind. Neuroimage, 99, 301-311.
%
%__________________________________________________________________________
% Copyright (C) 2014  Bob Spunt, Ph.D.

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
defaults.path.stim      = fullfile(defaults.path.base, 'stimuli');
defaults.path.design    = fullfile(defaults.path.base, 'design');
defaults.path.utilities = fullfile(defaults.path.base, 'utilities');

% Text 
%==========================================================================
defaults.font.name      = 'Arial'; % default font
defaults.font.size1     = 42; % default font size (smaller)
defaults.font.size2     = 46; % default font size (bigger)
defaults.font.wrap      = 42; % default font wrapping (arg to DrawFormattedText)

% Timing (specify all in seconds)
%==========================================================================
defaults.cueDur         = 2.10;   % dur of question presentation
defaults.ignoreDur      = 0.15;   % dur after trial presentation in which 
                                  % button presses are ignored (this is
                                  % useful when participant provides a late
                                  % response to the previous trial)
defaults.maxDur         = 1.70;   % (max) dur of trial 
defaults.ISI            = 0.30;   % dur of interval between trials
defaults.firstISI       = 0.15;   % dur of interval between question and   
                                  % first trial of each block
                               
end