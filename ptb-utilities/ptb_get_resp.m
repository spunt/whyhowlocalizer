function [resp, rt] = ptb_get_resp(resp_device, resp_set)
% PTB_GET_RESP Psychtoolbox utility for acquiring responses
%
% USAGE: [resp rt] = ptb_get_resp(resp_device,resp_set)
%
% INPUTS 
%  resp_device = device #
%  resp_set = array of keycodes (from KbName) for valid keys
%
% OUTPUTS
%  resp = name of key press (empty if no response)
%  rt = time of key press (in secs)
%

% ------------------- Copyright (C) 2013 -------------------
%	Author: Bob Spunt
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%
%	$Revision Date: Oct_24_2013

if nargin<2, disp('USAGE: [resp rt] = ptb_get_resp(resp_device,resp_set)'); return; end

onset = GetSecs;
noresp = 1;
resp = [];
rt = [];
while noresp
    
    [keyIsDown, secs, keyCode] = KbCheck(resp_device);
    keyPressed = find(keyCode);
    if keyIsDown & ismember(keyPressed, resp_set)
        rt = secs - onset;
        resp = KbName(keyPressed);
        noresp = 0;
    end
    
end
