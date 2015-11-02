function ptb_disp_message(message,w,lspacing)
% PTB_DISP_MESSAGE Psychtoolbox utility for displaying a message
%
% USAGE: ptb_disp_message(message,w,lspacing)
%
% INPUTS 
%  message = string to display
%  w = screen structure (from ptb_setup_screen)
%  lspacing = line spacing (default = 1)
%

% --------------------- Copyright (C) 2013 ---------------------
%	Author: Bob Spunt
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%
%	$Revision Date: Oct_24_2013

if nargin<3, lspacing = 1; 
if nargin<2, disp('USAGE: ptb_disp_message(message,w,lspacing)'); return; end
DrawFormattedText(w.win,message,'center','center',w.font.color,w.font.wrap,[],[],lspacing);
Screen('Flip',w.win);







