function out = ptb_get_input_numeric(prompt, input_set)
% PTB_GET_INPUT_NUMERIC Psychtoolbox utility for getting numeric input
%
% USAGE: out = ptb_get_input_numeric(prompt)
%
% INPUTS 
%  prompt = string containing message to user
%  input_set = valid inputs
%
% OUTPUTS
%  out = input
%
% Written by Bob Spunt, Jan. 13, 2013
% =========================================================================
out = input(prompt);
while ~sum(ismember([1 2],out))
    disp(sprintf(['Valid inputs are: ' repmat('%d ',1,length(input_set))], input_set));
    out = input(prompt);
end
         
    
    