function tex = ptb_im2tex(imfile, w)
% PTB_IM2TEX
%
% USAGE: tex = ptb_im2tex(imfile, w)
%
% OUTPUTS
%   im - structure with following fields
%   w - window
%   tex - pointer to image tex from Screen('MakeTexture',...)
%

% ------------ Copyright (C) 2013 ------------
%	Author: Bob Spunt
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%

if nargin < 1, disp('USAGE: tex = ptb_im2tex(imfile, w)'); return; end
if iscell(imfile), imfile = char(imfile); end
tex = Screen('MakeTexture', w, imread(imfile)); 
    
end