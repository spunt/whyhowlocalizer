function run_task(order, test_tag)
% RUN_TASK  Run Why/How Localizer Task
%
%   USAGE: run_task([order], [test_tag])
%
%   OPTIONAL ARGUMENTS
%       order:      choose from 1,2,3, or 4 - 0 (default) will choose randomly
%       test_tag:   if set to 1, will quit after first block
%
%   This function accepts two arguments. The first specifies the order to
%   use. There are 4 orders to choose from. If you do not specify this
%   argument, if you leave it empty, or if you define as zero, then the
%   order will be randomly chosen for you. The second argument, when
%   specified with the value of "1", will do a brief test run of the task
%   (which lasts only 20 seconds).
%
%   EXAMPLE USAGE
%    >> run_task        % Runs a randomly chosen order of the full task
%    >> run_task(3)     % Runs order #3 of the full task
%    >> run_task(0, 1)  % Does a brief test run of a randomly chosen order
%
%   Total runtime depends on settings in the task_defaults.m file that
%   should be in the same folder as this file. The default runtime from
%   trigger onset is 304 seconds. This corresponds to the 'fast' setting
%   under defaults.pace in the task_defaults.m file. The default runtime
%   for the 'slow' setting is 382 seconds. These values may be
%   automatically adjusted to be a multiple of your TR, which is also
%   specified in the task_defaults.m file. See the task_defaults.m file for
%   further information. To see the actual run time for the settings you've
%   specified, simply run this function.
%
%   COLUMN KEY FOR KEY OUTPUT VARIABLES (SAVED ON TASK COMPLETION)
%
%     blockSeeker (stores block-wise runtime data)
%     1 - block #
%     2 - condition (1=WhyFace, 2=WhyHand, 3=HowFace, 4=HowHand)
%     3 - scheduled onset (s)
%     4 - cue # (corresponds to variables preblockcues & isicues located in
%     a structure stored in the design.mat file. Both are cell arrays
%     containing the filenames for the cue screens contained in thefolder
%     "questions")
%
%     trialSeeker (stores trial-wise runtime data)
%     1 - block #
%     2 - trial # (within-block)
%     2 - condition (1=WhyFace, 2=WhyHand, 3=HowFace, 4=HowHand)
%     4 - normative response (1=Yes, 2=No) [used to evaluate accuracy]
%     5 - stimulus # (corresponds to qim & qdata from design.mat file)
%     6 - (saved during runtime) actual trial onset (s)
%     7 - (saved during runtime) response time to onset (s) [0 if No Resp]
%     8 - (saved during runtime) actual response [0 if No Resp]
%     9 - (saved during runtime) actual trial offset
%
%   FOR DESIGN DETAILS, SEE STUDY 3 IN:
%    Spunt, R. P., & Adolphs, R. (2014). Validating the why/how contrast
%    for functional mri studies of theory of mind. Neuroimage, 99, 301-311.
%
%   This code uses Psychophysics Toolbox Version 3 (PTB-3) running in
%   MATLAB (The Mathworks, Inc.). To learn more: http://psychtoolbox.org
%_______________________________________________________________________
% Copyright (C) 2014  Bob Spunt, Ph.D.
if nargin<1, order = 0; end
if nargin<2, test_tag = 0; end
if isempty(order), order = 0; end

%% Check for Psychtoolbox %%
try
    ptbVersion = PsychtoolboxVersion;
catch
    url = 'https://psychtoolbox.org/PsychtoolboxDownload';
    fprintf('\n\t!!! WARNING !!!\n\tPsychophysics Toolbox does not appear to on your search path!\n\tSee: %s\n\n', url);
    return
end

%% Print Title %%
script_name='----------- Photo Judgment Test -----------'; boxTop(1:length(script_name))='=';
fprintf('\n%s\n%s\n%s\n',boxTop,script_name,boxTop)

%% DEFAULTS %%
defaults = task_defaults;
KbName('UnifyKeyNames');
trigger = KbName(defaults.trigger);
addpath(defaults.path.utilities)

%% Load Design and Setup Seeker Variable %%
load([defaults.path.design filesep 'design.mat'])
if order==0, randidx = randperm(4); order = randidx(1); end
design              = alldesign{order};
switch lower(defaults.language)
    case 'german'
        pbc_brief           = design.preblockcues;
    otherwise
        pbc_brief           = regexprep(design.preblockcues,'Is the person ','');
end
trialSeeker         = design.trialSeeker;
trialSeeker(:,6:9)  = 0;
blockSeeker         = design.blockSeeker;
BOA                 = diff([blockSeeker(:,3); design.totalTime]);
nTrialsBlock        = length(unique(trialSeeker(:,2)));
switch lower(defaults.pace)
    case 'fast'
        defaults.cueDur         = 2.10;   % dur of question presentation
        defaults.maxDur         = 1.70;   % (max) dur of trial
        defaults.ISI            = 0.30;   % dur of interval between stimuli within blocks
        defaults.firstISI       = 0.15;   % dur of interval between question and first trial of each block
    case 'slow'
        defaults.cueDur         = 2.50;   % dur of question presentation
        defaults.maxDur         = 2.25;   % (max) dur of trial
        defaults.ISI            = 0.30;   % dur of interval between stimuli within blocks
        defaults.firstISI       = 0.15;   % dur of interval between question and first trial of each block
        maxBlockDur             = defaults.cueDur + defaults.firstISI + (nTrialsBlock*defaults.maxDur) + (nTrialsBlock-1)*defaults.ISI;
        BOA                     = BOA + (maxBlockDur - min(BOA));
    otherwise
        fprintf('\n\n| - Invalid option in "defaults.pace" \n| - Valid options: ''fast'' or ''slow'' (change in task_defaults.m)\n\n');
        return;
end
eventTimes          = cumsum([defaults.prestartdur; BOA]);
blockSeeker(:,3)    = eventTimes(1:end-1);
numTRs              = ceil(eventTimes(end)/defaults.TR);
totalTime           = defaults.TR*numTRs;

%% Print Defaults %%
fprintf('Test Duration:         %d secs (%d TRs)', totalTime, numTRs);
fprintf('\nTrigger Key:           %s', defaults.trigger);
fprintf(['\nValid Response Keys:   %s' repmat(', %s', 1, length(defaults.valid_keys)-1)], defaults.valid_keys{:});
fprintf('\nForce Quit Key:        %s\n', defaults.escape);
fprintf('%s\n', repmat('-', 1, length(script_name)));

%% Get Subject ID %%
if ~test_tag
    subjectID = ptb_get_input_string('\nEnter Subject ID: ');
else
    subjectID = 'TEST';
end

%% Setup Input Device(s) %%
switch upper(computer)
  case 'MACI64'
    inputDevice = ptb_get_resp_device;
  case {'PCWIN','PCWIN64'}
    % JMT:
    % Do nothing for now - return empty chosen_device
    % Windows XP merges keyboard input and will process external keyboards
    % such as the Silver Box correctly
    inputDevice = [];
  otherwise
    % Do nothing - return empty chosen_device
    inputDevice = [];
end
resp_set = ptb_response_set([defaults.valid_keys defaults.escape]); % response set

%% Initialize Screen %%
try
    w = ptb_setup_screen(0,250,defaults.font.name,defaults.font.size1, defaults.screenres); % setup screen
catch
    disp('Could not change to recommend screen resolution. Using current.');
    w = ptb_setup_screen(0,250,defaults.font.name,defaults.font.size1);
end

%% Initialize Logfile (Trialwise Data Recording) %%
d=clock;
logfile=fullfile(defaults.path.data, sprintf('LOG_whyhow_sub%s.txt', subjectID));
fprintf('\nA running log of this session will be saved to %s\n',logfile);
fid=fopen(logfile,'a');
if fid<1,error('could not open logfile!');end;
fprintf(fid,'Started: %s %2.0f:%02.0f\n',date,d(4),d(5));

%% Make Images Into Textures %%
DrawFormattedText(w.win,sprintf('LOADING\n\n0%% complete'),'center','center',w.white,defaults.font.wrap);
Screen('Flip',w.win);
slideName = cell(length(design.qim));
slideTex = slideName;
for i = 1:length(design.qim)
    slideName{i} = design.qim{i,2};
    tmp1 = imread([defaults.path.stim filesep slideName{i}]);
    tmp2 = tmp1;
    slideTex{i} = Screen('MakeTexture',w.win,tmp2);
    DrawFormattedText(w.win,sprintf('LOADING\n\n%d%% complete', ceil(100*i/length(design.qim))),'center','center',w.white,defaults.font.wrap);
    Screen('Flip',w.win);
end;
instructTex = Screen('MakeTexture', w.win, imread([defaults.path.stim filesep 'instruction.jpg']));
fixTex = Screen('MakeTexture', w.win, imread([defaults.path.stim filesep 'fixation.jpg']));
line1       = strcat('Is the person', repmat('\n', 1, defaults.font.linesep));

%% Get Coordinates for Centering ISI Cues
isicues_xpos = zeros(length(design.isicues),1);
isicues_ypos = isicues_xpos;
for q = 1:length(design.isicues)
    [isicues_xpos(q), isicues_ypos(q)] = ptb_center_position(design.isicues{q},w.win);
end

%==========================================================================
%
% START TASK PRESENTATION
%
%==========================================================================

%% Present Instruction Screen %%
Screen('DrawTexture',w.win, instructTex); Screen('Flip',w.win);

%% Wait for Trigger to Begin %%
DisableKeysForKbCheck([]);
secs=KbTriggerWait(trigger,inputDevice);
anchor=secs;

try

    if test_tag, nBlocks = 1; totalTime = round(totalTime*.075); % for test run
    else nBlocks = length(blockSeeker); end
    %======================================================================
    % BEGIN BLOCK LOOP
    %======================================================================
    for b = 1:nBlocks

        %% Present Fixation Screen Until Question Onset %%
        Screen('DrawTexture',w.win, fixTex); Screen('Flip',w.win);

        %% Get Data for This Block (While Waiting for Block Onset) %%
        tmpSeeker   = trialSeeker(trialSeeker(:,1)==b,:);
        pbcue       = pbc_brief{blockSeeker(b,4)};  % question cue
        isicue      = design.isicues{blockSeeker(b,4)};  % isi cue
        isicue_x    = isicues_xpos(blockSeeker(b,4));  % isi cue x position
        isicue_y    = isicues_ypos(blockSeeker(b,4));  % isi cue y position

        %% Prepare Question Cue Screen (Still Waiting) %%
        if ~strcmpi(defaults.language, 'german')
            Screen('TextSize',w.win, defaults.font.size1); Screen('TextStyle', w.win, 0);
            DrawFormattedText(w.win,line1,'center','center',w.white, defaults.font.wrap);
            Screen('TextStyle',w.win, 1); Screen('TextSize', w.win, defaults.font.size2);
        end
        DrawFormattedText(w.win, pbcue,'center','center', w.white, defaults.font.wrap);

        %% Present Question Screen and Prepare First ISI (Blank) Screen %%
        WaitSecs('UntilTime',anchor + blockSeeker(b,3)); Screen('Flip', w.win);
        Screen('FillRect', w.win, w.black);

        %% Present Blank Screen Prior to First Trial %%
        WaitSecs('UntilTime',anchor + blockSeeker(b,3) + defaults.cueDur); Screen('Flip', w.win);

        %==================================================================
        % BEGIN TRIAL LOOP
        %==================================================================
        for t = 1:nTrialsBlock

            %% Prepare Screen for Current Trial %%
            Screen('DrawTexture',w.win,slideTex{tmpSeeker(t,5)})
            if t==1, WaitSecs('UntilTime',anchor + blockSeeker(b,3) + defaults.cueDur + defaults.firstISI);
            else WaitSecs('UntilTime',anchor + offset_dur + defaults.ISI); end

            %% Present Screen for Current Trial & Prepare ISI Screen %%
            Screen('Flip',w.win);
            onset = GetSecs; tmpSeeker(t,6) = onset - anchor;
            if t==nTrialsBlock % present fixation after last trial of block
                Screen('DrawTexture', w.win, fixTex);
            else % present question reminder screen between every block trial
                Screen('DrawText', w.win, isicue, isicue_x, isicue_y);
            end

            %% Look for Button Press %%
            [resp, rt] = ptb_get_resp_windowed_noflip(inputDevice, resp_set, defaults.maxDur, defaults.ignoreDur);
            offset_dur = GetSecs - anchor;

            %% Present ISI, and Look a Little Longer for a Response if None Was Registered %%
            Screen('Flip', w.win);
            norespyet = isempty(resp);
            if norespyet, [resp, rt] = ptb_get_resp_windowed_noflip(inputDevice, resp_set, defaults.ISI*0.90); end
            if ~isempty(resp)
                if strcmpi(resp, defaults.escape)
                    sca; rmpath(defaults.path.utilities)
                    fprintf('\nESCAPE KEY DETECTED\n'); return
                end
                tmpSeeker(t,8) = find(strcmpi(KbName(resp_set), resp));
%                 tmpSeeker(t,8) = str2num(resp(1));
                tmpSeeker(t,7) = rt + (defaults.maxDur*norespyet);
            end
            tmpSeeker(t,9) = offset_dur;

        end % END TRIAL LOOP

        %% Store Block Data & Print to Logfile %%
        trialSeeker(trialSeeker(:,1)==b,:) = tmpSeeker;
        for t = 1:size(tmpSeeker,1), fprintf(fid,[repmat('%d\t',1,size(tmpSeeker,2)) '\n'],tmpSeeker(t,:)); end


    end % END BLOCK LOOP

    %% Present Fixation Screen Until End of Scan %%
    WaitSecs('UntilTime', anchor + totalTime);

catch

    ptb_exit;
    rmpath(defaults.path.utilities);
    psychrethrow(psychlasterror);

end

%% Create Results Structure %%
result.blockSeeker  = blockSeeker;
result.trialSeeker  = trialSeeker;
result.qim          = design.qim;
result.qdata        = design.qdata;
result.preblockcues = design.preblockcues;
result.isicues      = design.isicues;

%% Save Data to Matlab Variable %%
d=clock;
outfile=sprintf('whyhow_%s_order%d_%s_%02.0f-%02.0f.mat',subjectID,order,date,d(4),d(5));
try
    save([defaults.path.data filesep outfile], 'subjectID', 'result', 'slideName', 'defaults');
catch
	fprintf('couldn''t save %s\n saving to whyhow.mat\n', outfile);
	save whyhow.mat
end;

%% End of Test Screen %%
DrawFormattedText(w.win,'TEST COMPLETE\n\nPress any key to exit.','center','center',w.white,defaults.font.wrap);
Screen('Flip', w.win);
ptb_any_key;

%% Exit %%
ptb_exit;
rmpath(defaults.path.utilities);

end
