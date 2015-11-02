function [resp, rt] = ptb_get_resp_windowed_noflip(resp_device, resp_set, resp_window, ignore_dur)
% PTB_GET_RESP_WINDOWED Psychtoolbox utility for acquiring responses
%
% USAGE: [resp rt] = ptb_get_resp_windowed_noflip(resp_device, resp_set, resp_window, ignore_dur)
%
% INPUTS 
%  resp_device = device #
%  resp_set = array of keycodes (from KbName) for valid keys
%  resp_window = response window (in secs)
%  ignore_dur = dur after onset in which to ignore button presses
%
% OUTPUTS
%  resp = name of key press (empty if no response)
%  rt = time of key press (in secs)
%
% Written by Bob Spunt, Jan. 7, 2013
% =========================================================================
if nargin < 4, ignore_dur = 0; end
onset = GetSecs;
noresp = 1;
resp = [];
rt = [];
if ignore_dur, WaitSecs('UntilTime', onset + ignore_dur); end
while noresp && GetSecs - onset < resp_window
    
    [keyIsDown, secs ,keyCode] = KbCheck(resp_device);
    keyPressed = find(keyCode);
    if keyIsDown & ismember(keyPressed, resp_set)
        
        rt = secs - onset;
        resp = KbName(keyPressed);
        noresp = 0;
        
    end
    
end