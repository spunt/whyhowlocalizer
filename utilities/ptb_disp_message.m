function ptb_disp_message(message,w)
% PTB_DISP_MESSAGE Psychtoolbox utility for displaying a message
%
% USAGE: ptb_disp_message(message,w,device)
%
% INPUTS 
%  message = string to display
%  w = screen structure (from ptb_setup_screen)
%

% --------------------- Copyright (C) 2013 ---------------------
%	Author: Bob Spunt
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%
%	$Revision Date: Oct_24_2013

if nargin<2, disp('USAGE: ptb_disp_message(message,w)'); return; end
DrawFormattedText(w.win,message,'center','center',w.font.color,w.font.wrap);
Screen('Flip',w.win);







