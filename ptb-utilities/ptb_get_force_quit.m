function doquit = ptb_get_force_quit(resp_device, resp_set, resp_window)
% PTB_GET_FORCE_QUIT 
%
% USAGE: ptb_get_force_quit(resp_device, resp_set, resp_window)
%
% INPUTS 
%  resp_device = device #
%  resp_set = array of keycodes (from KbName) for valid keys
%  resp_window = response window (in secs)
%
% Written by Bob Spunt, Jan. 7, 2013
% =========================================================================
onset = GetSecs;
noresp = 1;
doquit = 0; 
while noresp && GetSecs - onset < resp_window
    
    [keyIsDown, ~, keyCode] = KbCheck(resp_device);
    keyPressed = find(keyCode);
    if keyIsDown && ismember(keyPressed, resp_set)
        noresp = 0; doquit = 1; 
    end
    
end
