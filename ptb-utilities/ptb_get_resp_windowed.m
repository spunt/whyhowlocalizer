function [resp rt] = ptb_get_resp_windowed(resp_device, resp_set, resp_window, window, color)
% PTB_GET_RESP_WINDOWED Psychtoolbox utility for acquiring responses
%
% USAGE: [resp rt] = ptb_get_resp_windowed(resp_device,resp_set,resp_window,window,color)
%
% INPUTS 
%  resp_device = device #
%  resp_set = array of keycodes (from KbName) for valid keys
%  resp_window = response window (in secs)
%  window = window to draw to
%  color = color to flip once response is collected
%
% OUTPUTS
%  resp = name of key press (empty if no response)
%  rt = time of key press (in secs)
%

% ------------------------------------ Copyright (C) 2013 ------------------------------------
%	Author: Bob Spunt
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%
%	$Revision Date: Oct_24_2013

if nargin<5, disp('USAGE: [resp rt] = ptb_get_resp_windowed(resp_device,resp_set,resp_window,window,color)'); return; end

onset = GetSecs;
noresp = 1;
resp = [];
rt = [];
while noresp && GetSecs - onset < resp_window
    
    [keyIsDown secs keyCode] = KbCheck(resp_device);
    keyPressed = find(keyCode);
    if keyIsDown & ismember(keyPressed, resp_set)
        
        rt = secs - onset;
        Screen('FillRect', window, color); 
        Screen('Flip', window);
        resp = KbName(keyPressed);
        noresp = 0;
        
    end
    
end
WaitSecs('UntilTime', onset + resp_window)
