function chosen_device = ptb_get_resp_device(prompt)
% PTB_GET_RESPONSE Psychtoolbox utility for acquiring responses
%
% USAGE: chosen_device = ptb_get_resp_device(prompt)
%
% INPUTS 
%  prompt = to display to user
%
% OUTPUTS
%  chosen_device = device number
%
% Adapted by Bob Spunt (Jan. 8, 2013) from function by Don Kalar

% --------------------- Copyright (C) 2013 ---------------------
%	Author: Bob Spunt (adapted from hid_probe.m by Don Kalar)
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%
%	$Revision Date: Oct_24_2013

if nargin<1, prompt = 'Which device?'; end

chosen_device = [];
numDevices=PsychHID('NumDevices');
devices=PsychHID('Devices');
candidate_devices = [];
boxTop(1:length(prompt))='-';
keyboard_idx = GetKeyboardIndices;
fprintf('\n%s\n%s\n%s\n',boxTop,prompt,boxTop)
if length(keyboard_idx)==1
    fprintf('Defaulting to one found keyboard: %s, %s\n',devices(keyboard_idx).usageName,devices(keyboard_idx).product)
    chosen_device = keyboard_idx;
else 
    for i=1:length(keyboard_idx), n=keyboard_idx(i); fprintf('%d - %s, %s\n',i,devices(n).usageName,devices(n).product); candidate_devices = [candidate_devices i]; end
    prompt_string = sprintf('\nChoose a keyboard (%s): ',num2str(candidate_devices));
    while isempty(chosen_device)
        chosen_device = input(prompt_string);
        if isempty(chosen_device)
            fprintf('Invalid Response!\n')
            chosen_device = [];
        elseif isempty(find(candidate_devices == chosen_device))
            fprintf('Invalid Response!\n')
            chosen_device = [];
        end
    end
    chosen_device = keyboard_idx(chosen_device);
end
