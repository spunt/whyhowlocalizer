function run_practice
% RUN_PRACTICE  Run Practice for Why/How Localizer Task
%
%   USAGE: run_practice
%
%   This code uses Psychophysics Toolbox Version 3 (PTB-3) running in
%   MATLAB (The Mathworks, Inc.). To learn more: http://psychtoolbox.org
%_______________________________________________________________________
% Copyright (C) 2014  Bob Spunt, Ph.D.
test_tag = 0;

%% Check for Psychtoolbox %%
try
    ptbVersion = PsychtoolboxVersion;
catch
    url = 'https://psychtoolbox.org/PsychtoolboxDownload';
    fprintf('\n\t!!! WARNING !!!\n\tPsychophysics Toolbox does not appear to on your search path!\n\tSee: %s\n\n', url);
    return
end


%% Print Title %%
script_name='-------- Practice Photo Judgment Test --------'; boxTop(1:length(script_name))='=';
fprintf('\n%s\n%s\n%s\n',boxTop,script_name,boxTop)

%% DEFAULTS %%
defaults = task_defaults;
KbName('UnifyKeyNames');
trigger = KbName(defaults.trigger);
addpath(defaults.path.utilities)

%% Load Design and Setup Seeker Variable %%
load([defaults.path.design filesep 'practice_design.mat']);
design              = alldesign{1};
pbc_brief           = regexprep(design.preblockcues,'Is the person ','');
trialSeeker         = design.trialSeeker;
trialSeeker(:,6:9)  = 0;
blockSeeker         = design.blockSeeker;
BOA                 = diff([blockSeeker(:,3); design.totalTime]);
nTrialsBlock        = length(unique(trialSeeker(:,2)));
nBlocks             = size(blockSeeker, 1);
nStim               = length(design.qim);
practicepad         = .30;
switch lower(defaults.pace)
    case 'fast'
        defaults.cueDur         = practicepad + 2.10;   % dur of question presentation
        defaults.maxDur         = practicepad + 1.70;   % (max) dur of trial
        defaults.ISI            = 0.20 + 0.30;   % dur of interval between stimuli within blocks
        defaults.firstISI       = 0.35 + 0.15;   % dur of interval between question and first trial of each block
    case 'slow'
        defaults.cueDur         = practicepad + 2.50;   % dur of question presentation
        defaults.maxDur         = practicepad + 2.25;   % (max) dur of trial
        defaults.ISI            = 0.20 + 0.30;   % dur of interval between stimuli within blocks
        defaults.firstISI       = 0.35 + 0.15;   % dur of interval between question and first trial of each block
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
fprintf('Practice Duration:     %d secs', totalTime);
fprintf('\nTrigger Key:           %s', defaults.trigger);
fprintf(['\nValid Response Keys:   %s' repmat(', %s', 1, length(defaults.valid_keys)-1)], defaults.valid_keys{:});
fprintf('\nForce Quit Key:        %s\n', defaults.escape);
fprintf('%s\n', repmat('-', 1, length(script_name)));

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

%% Make Images Into Textures %%
DrawFormattedText(w.win,sprintf('LOADING\n\n0%% complete'),'center','center',w.white,defaults.font.wrap);
Screen('Flip',w.win);
slideName = cell(nStim, 1);
slideTex = slideName;
for i = 1:nStim
    slideName{i} = design.qim{i,2};
    tmp1 = imread([defaults.path.stimpractice filesep slideName{i}]);
    tmp2 = tmp1;
    slideTex{i} = Screen('MakeTexture',w.win,tmp2);
    DrawFormattedText(w.win,sprintf('LOADING\n\n%d%% complete', ceil(100*i/nStim)),'center','center',w.white,defaults.font.wrap);
    Screen('Flip',w.win);
end;
instructTex = Screen('MakeTexture', w.win, imread([defaults.path.stimpractice filesep 'instruction.jpg']));
fixTex      = Screen('MakeTexture', w.win, imread([defaults.path.stimpractice filesep 'fixation.jpg']));
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

    if test_tag, nBlocks = 1; totalTime = round(totalTime*.075); end % for test run
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
                tmpSeeker(t,7) = rt + (defaults.maxDur*norespyet);
            end
            tmpSeeker(t,9) = offset_dur;

        end % END TRIAL LOOP

    end % END BLOCK LOOP

    %% Present Fixation Screen Until End of Scan %%
    WaitSecs(defaults.practiceenddur);

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
outfile=sprintf('practice_whyhow_%s_%02.0f-%02.0f.mat',date,d(4),d(5));
try
    save([defaults.path.data filesep outfile], 'result', 'slideName', 'defaults');
catch
	fprintf('couldn''t save %s\n saving to practicewhyhow.mat\n', outfile);
	save practicewhyhow.mat
end

%% End of Test Screen %%
DrawFormattedText(w.win,'PRACTICE COMPLETE\n\nPress any key to exit.','center','center',w.white,defaults.font.wrap);
Screen('Flip', w.win);
ptb_any_key;

%% Exit %%
ptb_exit;
rmpath(defaults.path.utilities);

end
