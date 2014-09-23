function im = ptb_preload_images(impattern, w)
% PTB_PRELOAD_IMAGES
%
% USAGE: im = ptb_preload_images(impattern, w)
%
% INPUTS 
%   impattern - wildcard pattern for finding
%   window - window pointer
%
% OUTPUTS
%   im - structure with following fields
%   .name - image file name
%   .data - raw image data (output from imread)
%   .tex - pointer to image tex from Screen('MakeTexture',...)
%

% ------------ Copyright (C) 2013 ------------
%	Author: Bob Spunt
%	Affilitation: Caltech
%	Email: spunt@caltech.edu
%
%	$Revision Date: Oct_24_2013

if nargin < 2, disp('USAGE: im = ptb_preload_images(impattern, w)'); return; end

fnonly = dirfiles(impattern,1);
fn = dirfiles(impattern);
for i = 1:length(fn)
    im(i).name = fnonly{i};
    im(i).data = imread(fn{i});
    im(i).tex = Screen('MakeTexture', w, im(i).data);
end

end

function fn = dirfiles(pattern, filenameonly)
if nargin<1, display('USAGE: fn = dirfiles(pattern, filenameonly)'); end
if nargin<2, filenameonly = 0; end

% get path name
seps = strfind(pattern,'/');
if isempty(seps)
    path = pwd; 
else
    relpath = regexprep(pattern,pwd,''); 
    relseps = strfind(relpath,'/');
    path = [pwd relpath(1:relseps(end)-1)];
end

% get filenames
d = dir(pattern);
fn = {d(~[d.isdir]).name}';

% add full path
if ~filenameonly
    fn = strcat(repmat(cellstr([path filesep]),length(fn),1), fn);
end

end
