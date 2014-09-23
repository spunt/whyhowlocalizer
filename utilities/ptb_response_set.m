function resp_set = ptb_response_set(keys)
% PTB_RESPONSE_SET Psychtoolbox utility for building response set
%
% USAGE: resp_set = ptb_response_set(keys)
%
% INPUTS 
%  keys = cell array of strings for key names
%
% OUTPUTS
%  resp_set = array containing key codes for key names
%

% ---------------------- Copyright (C) 2013 ----------------------
%	Author: Bob Spunt
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%
%	$Revision Date: Oct_24_2013

if nargin<1, disp('USAGE: resp_set = ptb_response_set(keys)'); return; end

resp_set = zeros(length(keys),1);
for k = 1:length(keys)
    
    resp_set(k) = KbName(keys{k});
    
end
