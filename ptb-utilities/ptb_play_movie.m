function [on off resp] = ptb_play_movie(window, movie, moviesize, when, maxtime, inputDevice, resp_set)
% PTB_PLAY_MOVIE Psychtoolbox utility for playing movies
%
% USAGE: [on off resp] = ptb_play_movie(window, movie, moviesize, when, maxtime, inputDevice, resp_set)
%
% INPUTS 
%  window = window to draw to
%  movie = pointer to movie to play
%  moviesize = scaling factor for display movie (between 0 and 1)
%  when = when to starting playing
%  maxtime = max time to play(in secs)
%  inputDevice = device #
%  resp_set = array of keycodes (from KbName) for valid keys
%  
% OUTPUTS
%  resp = name of key press (empty if no response)
%  on = onset (in secs)
%  off = offset (in secs)
%
% EXAMPLE USAGE:
%  moviesize = .75;
%  maxTime = 3;
%  [on off resp] = ptb_play_movie(w, videoStim, movieSize, anchor + tmpSeeker(t,9) + 2, maxTime, inputDevice, resp_set);  
%

% -------------------------------------------------- Copyright (C) 2013 --------------------------------------------------
%	Author: Bob Spunt
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%
%	$Revision Date: Oct_24_2013

if nargin<7, disp('USAGE: [on off resp] = ptb_play_movie(window, movie, moviesize, when, maxtime, inputDevice, resp_set)'); return; end


% set rect
movierect = CenterRect(ScaleRect(Screen('Rect', window),moviesize,moviesize),Screen('Rect', window));

% open and play movie
% [movie movieduration fps imgw imgh] = Screen('OpenMovie', window, [pwd filesep moviename]);
Screen('SetMovieTimeIndex', movie, 0);
Screen('PlayMovie', movie, 1, 0, 0);
WaitSecs('UntilTime', when);
on = GetSecs;
while 1
    tex = Screen('GetMovieImage', window, movie, 1);
    if tex<=0 || (GetSecs - on) > maxtime
        off = GetSecs;
        resp = [];
        Screen('PlayMovie', movie, 0);
        break
    end
    Screen('DrawTexture', window, tex, [], movierect);
    Screen('DrawingFinished',window);
    Screen('Flip', window);
    Screen('Close', tex); 
    % check for button press
    [keyIsDown,secs,keyCode]=KbCheck(inputDevice);
    keyPressed = find(keyCode);
    if keyIsDown & ismember(keyPressed,resp_set)
        tmp = KbName(keyPressed);
        resp = str2double(tmp(1));
        off = secs;
        Screen('PlayMovie', movie, 0);
        break
    end
end
