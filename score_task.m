function out = score_task(in, option, write2file, nodisplay)
% SCORE_TASK Score Why/How Localizer Behavioral Data
%
%  USAGE: score_task()	*optional input
%
%  OUTPUT
%	out:  
%
% __________________________________________________________________________
%  INPUTS
%	in:             array of behavioral data filenames (.mat)
%	option:         option, '1x2' for why vs. how, '2x2' for full design
%	write2file:     write report to CSV in current dir, 0=No (default), 1=Yes
%	nodisplay:      flag to not display results to command window
%
% __________________________________________________________________________
%  EXAMPLES
%	>> score_task
%

% ---------------------- Copyright (C) 2015 Bob Spunt ----------------------
%	Created:  2015-03-06
%	Email:    spunt@caltech.edu
% __________________________________________________________________________
if nargin < 1
    [fname, pathname] = uigetfile({'*.mat', 'MAT-File'}, 'Select Behavioral Data File(s)', 'Multiselect', 'on');
    if isequal(fname,0) || isequal(pathname,0)
        disp('NO FILES SELECTED'); return;
    end
    in = fullfile(pathname, fname);
end
if nargin < 2, option = '2x2'; end
if nargin < 3, write2file = 0; end
if nargin < 4, nodisplay = 0; end
if ischar(in), in = cellstr(in); end
if iscell(option), option = lower(char(option)); end
 
for s = 1:length(in)

    %% read data
    d = load(in{s});
    subid{s} = d.subjectID;
    if ismember({'result'},fieldnames(d))
        data = d.result.trialSeeker;
        blockwise = d.result.blockSeeker; 
        items = d.result.preblockcues(d.result.blockSeeker(:,4));
    else
        data = d.trialSeeker;
        blockwise = d.blockSeeker; 
        items = d.ordered_questions;
    end
    
    %% blockwise accuracy and durations
    ntrials = length(data(data(:,1)==1,1));
    blockwise(:,3) = data(data(:,2)==1, 6);
    blockwise(:,4) = data(data(:,2)==ntrials, 9) - blockwise(:,3); 
    data(:,9) = data(:,4)==data(:,8);
    
    % compute block-wise accuracy
    for b = 1:size(blockwise, 1)
        blockwise(b,5) = sum(data(data(:,1)==b,9));  % block-wise accuracy
    end
        
    %% re-code data
    if strcmpi(option, '1x2')
        data(data(:,3) < 3, 3) = 1;
        data(data(:,3) > 2, 3) = 2;
    end
    blockwise(:,2) = data(data(:,2)==1, 3);
    ncond = length(unique(blockwise(:,2)));  
    out.blockwise.data{s} = blockwise; 
    
    crt = [];
    crtyes = [];
    crtno = [];

    for c = 1:ncond
        
        %% indices
        allidx = find(data(:,3)==c);
        yesidx = find(data(:,3)==c & data(:,4)==1);
        noidx = find(data(:,3)==c & data(:,4)==2);
        accallidx = find(data(:,3)==c & data(:,9)==1);
        accyesidx = find(data(:,3)==c & data(:,4)==1 & data(:,9)==1);
        accnoidx = find(data(:,3)==c & data(:,4)==2 & data(:,9)==1);

        %% accuracy
        acc(s,c) = 100*(length(accallidx)/length(allidx));
        accyes(s,c) = 100*(length(accyesidx)/length(yesidx));
        accno(s,c) = 100*(length(accnoidx)/length(noidx));
        
        %% accurate rt
        allrt = data(data(:,3)==c & data(:,9)==1,7);
        yesrt = data(data(:,3)==c & data(:,9)==1 & data(:,4)==1,7);
        nort = data(data(:,3)==c & data(:,9)==1 & data(:,4)==2,7);
        allrt(allrt==0) = [];
        yesrt(yesrt==0) = [];
        nort(nort==0) = [];
        allrt = outlier2nan(allrt, 3);
        yesrt = outlier2nan(yesrt, 3);
        nort = outlier2nan(nort, 3);
        
        %% compute rt outcomes
        rt(s,c) = nanmean(allrt);
        rtyes(s,c) = nanmean(yesrt);
        rtno(s,c) = nanmean(nort);
        rtnocost(s,c) = (nanmean(nort) - nanmean(yesrt))/nanstd(allrt);
       
        %% save for computing why>how cost
        crt = [crt; allrt];
        crtyes = [crtyes; yesrt];
        crtno = [crtno; nort];       
        
    end
    
    %% rt cost outcomes
    allrtwhycost(s,1) = (rt(s,1) - rt(s,2))/nanstd(crt);
    yesrtwhycost(s,1) = (rtyes(s,1) - rtyes(s,2))/nanstd(crtyes);
    nortwhycost(s,1) = (rtno(s,1) - rtno(s,2))/nanstd(crtno);

end
switch option
    case {'1x2'}
        labels = {'Why' 'How'};
    case {'2x2'}
        labels = {'WhyFace' 'WhyHand' 'HowFace' 'HowHand'};
end
out.condlabels = labels; 
l1 = {'Accuracy' 'RT'};
l2 = {'All' 'Yes' 'No'};
l3 = labels;
count = 0;
for i = 1:length(l1)
    for ii = 1:length(l2)
        for iii = 1:length(l3)
            count = count + 1;
            outcome{count} = [l1{i} '_' l2{ii} '_' l3{iii}];
        end
    end
end
for i = 1:length(l2)
    count = count + 1;
    outcome{count} = ['RTcost_Why-How_' l2{i}];
end
alldata = [acc accyes accno rt rtyes rtno allrtwhycost yesrtwhycost nortwhycost];
out.blockwise.columnlabels = {'Block' 'Condition' 'Onset' 'Duration' 'N Correct'}; 
out.subjectid = subid;
out.variables = outcome;
out.data = alldata;
if ~nodisplay, disptable(out.data', out.subjectid, out.variables, '%2.2f'); end
if write2file
    reportname = sprintf('SCORE_REPORT_%s', option);
    thereport = [{'ID'} out.variables];
    thereport = [thereport; [out.subjectid' num2cell(out.data)]];
    writereport(thereport, reportname);
end

end
% SUBFUNCTIONS ------------------------------------------------------------
function disptable(M, col_strings, row_strings, fmt, spaces)
%DISPTABLE Displays a matrix with per-column or per-row labels.
%   DISPTABLE(M, COL_STRINGS, ROW_STRINGS)
%   Displays matrix or vector M with per-column or per-row labels,
%   specified in COL_STRINGS and ROW_STRINGS, respectively. These can be
%   cell arrays of strings, or strings delimited by the pipe character (|).
%   Either COL_STRINGS or ROW_STRINGS can be ommitted or empty.
%   
%   DISPTABLE(M, COL_STRINGS, ROW_STRINGS, FMT, SPACES)
%   FMT is an optional format string or number of significant digits, as
%   used in NUM2STR. It can also be the string 'int', as a shorthand to
%   specify that the values should be displayed as integers.
%   SPACES is an optional number of spaces to separate columns, which
%   defaults to 1.
%   
%   Example:
%     disptable(magic(3)*10-30, 'A|B|C', 'a|b|c')
%   
%   Outputs:
%        A    B    C
%    a  50  -20   30
%    b   0   20   40
%    c  10   60  -10
%   
%   Author: João F. Henriques, April 2010


	%parse and validate inputs

	if nargin < 2, col_strings = []; end
	if nargin < 3, row_strings = []; end
	if nargin < 4, fmt = 4; end
	if nargin < 5, spaces = 2; end
	
	if strcmp(fmt, 'int'), fmt = '%.0f'; end  %shorthand for displaying integer values
	
	assert(ndims(M) <= 2, 'Can only display a vector or two-dimensional matrix.')
	
	num_rows = size(M,1);
	num_cols = size(M,2);

	use_col_strings = true;
	if ischar(col_strings),  %convert "|"-delimited string to cell array of strings
		col_strings = textscan(col_strings, '%s', 'delimiter','|');
		col_strings = col_strings{1};
		
	elseif isempty(col_strings),  %empty input; have one empty string per column for consistency
		col_strings = cell(num_cols,1);
		use_col_strings = false;
		
	elseif ~iscellstr(col_strings),
		error('COL_STRINGS must be a cell array of strings, or a string with "|" as a delimiter.');
	end

	use_row_strings = true;
	if ischar(row_strings),  %convert "|"-delimited string to cell array of strings
		row_strings = textscan(row_strings, '%s', 'delimiter','|');
		row_strings = row_strings{1};
		
	elseif isempty(row_strings),  %empty input; have one empty string per row for consistency
		row_strings = cell(num_rows,1);
		use_row_strings = false;
		
	elseif ~iscellstr(row_strings),
		error('ROW_STRINGS must be a cell array of strings, or a string with "|" as a delimiter.');
	end
	
	assert(~use_col_strings || numel(col_strings) == num_cols, ...
		'COL_STRINGS must have one string per column of M, or be empty.')
	
	assert(~use_row_strings || numel(row_strings) == num_rows, ...
		'ROW_STRINGS must have one string per column of M, or be empty.')
	
	assert(isscalar(fmt) || (isvector(fmt) && ischar(fmt)), ...
		'Format must be a format string or the number of significant digits (as in NUM2STR).')
	
	
	
	%format the table for display
	
	col_text = cell(num_cols,1);  %the text of each column
	
	%spaces to separate columns
	if use_col_strings,
		blank_column = repmat(' ', num_rows + 1, spaces);
	else
		blank_column = repmat(' ', num_rows, spaces);
	end
	
	for col = 1:num_cols,
		%convert this column of the matrix to its string representation
		str = num2str(M(:,col), fmt);
		
		%add the column header on top and automatically pad, returning a
		%character array
		if use_col_strings,
			str = char(col_strings{col}, str);
		end
		
		%right-justify and add blanks to separate from previous column
		col_text{col} = [blank_column, strjust(str, 'right')];
	end
	
	%turn the row labels into a character array, with a blank line on top
	if use_col_strings,
		left_text = char('', row_strings{:});
	else
		left_text = char(row_strings{:});
	end
	
	%concatenate horizontally the character arrays and display
	disp([left_text, col_text{:}])
	disp(' ')
	
end
function out = oneoutzscore(in)
% perform columnwise leave-one-out zscoring

if size(in,1)==1, in=in'; end
sample = in;
out = zeros(size(sample));
for c = 1:size(sample,2)
    for r = 1:size(sample,1)
        obs = sample(r,c);
        nsample = sample(:,c);
        nsample(r) = [];
        tmpsd = nanstd(nsample);
        tmpmean = nanmean(nsample);
        out(r,c) = (obs - tmpmean)/tmpsd; 
    end
end
end
function y = outlier2nan(x,sd,rmcase)
% OUTLIER2NAN
% 
% USAGE: y = outlier2nan(x,sd,rmcase)
%   x = input matrix
%   sd = number of standard deviations to truncate
%   rmcase = option to remove case/row 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1, error('y = outlier2nan(x,sd,rmcase)'); end
if nargin < 2, sd = 3; end
if nargin < 3, rmcase = 0; end
y = x;
nvec = size(x,2);
nnan = sum(isnan(y));
do = 1;
while do
    for i = 1:nvec
        zvec = abs(oneoutzscore(y(:,i)));
        y(zvec>sd,i) = NaN;
    end
    if nansum(isnan(y(:)))==nnan
        do = 0;
    else
        nnan = nansum(isnan(y(:)));
    end
end
if rmcase, y(isnan(mean(y,2)),:) = []; end 
end
function m = nanmean(x,dim)
% Find NaNs and set them to zero
nans = isnan(x);
x(nans) = 0;

if nargin == 1 % let sum deal with figuring out which dimension to use
    % Count up non-NaNs.
    n = sum(~nans);
    n(n==0) = NaN; % prevent divideByZero warnings
    % Sum up non-NaNs, and divide by the number of non-NaNs.
    m = sum(x) ./ n;
else
    % Count up non-NaNs.
    n = sum(~nans,dim);
    n(n==0) = NaN; % prevent divideByZero warnings
    % Sum up non-NaNs, and divide by the number of non-NaNs.
    m = sum(x,dim) ./ n;
end
end
function Y = nansum(X,dim)
if nargin<2 || ~isnumeric(dim)
    dim=1;
end
if dim>numel(size(X))
    error('Summing dimension is larger than the dimensions of X')
end
X(isnan(X))=0;
Y=sum(X,dim);
end
function outname = writereport(incell, basename)
% WRITEREPORT Write cell array to CSV file
%
%  USAGE: outname = writereport(incell, basename)	*optional input
% __________________________________________________________________________
%  INPUTS
%	incell:     cell array of character arrays
%	basename:   base name for output csv file 
%

% ---------------------- Copyright (C) 2015 Bob Spunt ----------------------
%	Created:  2015-02-02
%	Email:    spunt@caltech.edu
% __________________________________________________________________________
if nargin < 1, disp('USAGE: outname = writereport(incell, basename)'); return; end
if nargin < 2, basename = 'report'; end

% | Construct filename
% | ========================================================================
day = strtrim(datestr(now,'mmm_DD_YYYY'));
time = strtrim(datestr(now,'HHMMSSPM'));
outname = [basename '_' day '_' time '.csv'];

% | Convert all cell contents to character arrays
% | ========================================================================
[nrow, ncol] = size(incell);
for i = 1:numel(incell)
    if isnumeric(incell{i}), incell{i} = num2str(incell{i}); end
    if strcmp(incell{i},'NaN'), incell{i} = ''; end
end
incell = regexprep(incell, ',', '');

% | Write to file
% | ========================================================================
fid = fopen(outname,'w');
for r = 1:nrow
    fprintf(fid,['%s' repmat(',%s',1,ncol-1) '\n'],incell{r,:});
end
fclose(fid);
end
