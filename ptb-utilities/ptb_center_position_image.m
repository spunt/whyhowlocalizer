function rect = ptb_center_position_image(im, window, xy_offsets)
% PTB_CENTER_POSITION
%
% USAGE: rect = ptb_center_position_image(im, window, xy_offsets)
%
% INPUTS 
%  im = image matrix to be displayed
%  window = window in which it will be displayed
%  xy_offsets = (default = [0 0]) offset on x and y-axes (pos = lower, neg = higher)
%
% OUTPUTS
%   rect = coordinates for desination rectangle
%

% ------------------------------- Copyright (C) 2013 -------------------------------
%	Author: Bob Spunt
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%
%	$Revision Date: Oct_24_2013

if nargin<2, disp('USAGE: rect = ptb_center_position_image(im, window, xy_offsets)'); return; end
if nargin<3, xy_offsets = [0 0]; end
dims = size(im);
[width height] = Screen('WindowSize', window);
rect = [0 0 0 0];
rect(1) = (width - dims(2))/2 + xy_offsets(1); 
rect(2) = (height - dims(1))/2 + xy_offsets(2);  
rect(3) = rect(1) + dims(2);
rect(4) = rect(2) + dims(1);


