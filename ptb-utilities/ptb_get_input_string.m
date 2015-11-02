function out = ptb_get_input_string(prompt)
% PTB_GET_INPUT_STRING Psychtoolbox utility for getting valid user input string
%
% USAGE: out = ptb_get_input(prompt)
%
% INPUTS 
%  prompt = string containing message to user
%
% OUTPUTS
%  out = input
%

% ----------------------------- Copyright (C) 2013 -----------------------------
%	Author: Bob Spunt
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%
%	$Revision Date: Oct_24_2013

if nargin<1, disp('USAGE: out = ptb_get_input(prompt)'); return; end
out = input(prompt, 's');
while isempty(out)
    disp('ERROR: You entered nothing. Try again.');
    out = input(prompt, 's');
end
         
    
    
