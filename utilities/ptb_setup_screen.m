function w = ptb_setup_screen(background_color, font_color, font_name, font_size, screen_res)
% PTB_SETUP_SCREEN Psychtoolbox utility for setting up screen
%
% USAGE: w = ptb_setup_screen(background_color,font_color,font_name,font_size,screen_res)
%
% INPUTS
%  background_color = color to setup screen with
%  font_color = default font color
%  font_name = default font name (e.g. 'Arial','Times New Roman','Courier')
%  font_size = default font size
%  screen_res = desired screen resolution (width x height)
%
% OUTPUTS
%   w = structure with the following fields:
%       win = window pointer
%       res = window resolution
%       oldres = original window resolution
%       xcenter = x center
%       ycenter = y center
%       white = white index
%       black = black index
%       gray = between white and black
%       color = background color
%       font.name = default font 
%       font.color = default font color
%       font.size = default font size
%       font.wrap = default wrap for font
%

% ------------------------------------ Copyright (C) 2013 ------------------------------------
%	Author: Bob Spunt
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%
%	$Revision Date: Oct_24_2013

if nargin<5, screen_res = []; end
if nargin<4, display('USAGE: w = ptb_setup_screen(background_color,font_color,font_name,font_size, screen_res)'); return; end

% start
screenNum = max(Screen('Screens'));
oldres = Screen('Resolution',screenNum);
if ~isempty(screen_res) & ~isequal([oldres.width oldres.height], screen_res)
    Screen('Resolution',screenNum,screen_res(1),screen_res(2));
end
[w.win w.res] = Screen('OpenWindow', screenNum, background_color);
[width height] = Screen('WindowSize', w.win);

% text
Screen('TextSize', w.win, font_size);
Screen('TextFont', w.win, font_name);
Screen('TextColor', w.win, font_color);

% this bit gets the default font wrap
text = repmat('a',1000,1);
[normBoundsRect offsetBoundsRect]= Screen('TextBounds', w.win, text);
wscreen = w.res(3);
wtext = normBoundsRect(3);
wchar = floor(wtext/length(text));

% output variable
w.xcenter = width/2;
w.ycenter = height/2;
w.white = WhiteIndex(w.win);
w.black = BlackIndex(w.win);
w.gray = round(((w.white-w.black)/2));
w.color = background_color;
w.font.name = font_name;
w.font.color = font_color;
w.font.size = font_size;
w.font.wrap = floor(wscreen/wchar) - 4;

% flip up screen
HideCursor;
Screen('FillRect', w.win, background_color);

