function [xpos ypos] = ptb_center_position(string, window, y_offset)
% PTB_CENTER_POSITION
%
% USAGE: [xpos ypos] = ptb_center_position(string, window, y_offset)
%
% INPUTS 
%  string = string being displayed
%  window = window in which it will be displayed
%  y_offset = (default = 0) offset on y-axis (pos = lower, neg = higher)
%
% OUTPUTS
%   xpos = starting x coordinate
%   ypos = starting y coordinate
%

% ------------------------- Copyright (C) 2013 -------------------------
%	Author: Bob Spunt
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%
%	$Revision Date: Oct_24_2013

if nargin<2, disp('USAGE: [xpos ypos] = ptb_center_position(string, window, y_offset)'); end
if nargin<3, y_offset = 0; end
text_size = Screen('TextBounds', window, string);
[width height] = Screen('WindowSize', window);
xcenter = width/2;
ycenter = height/2;
text_x = text_size(1,3);
text_y = text_size(1,4);

% output variable

xpos = xcenter - (text_x/2);
ypos = ycenter - (text_y/2) + y_offset;
