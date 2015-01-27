function display_message(message,w,exptDevice)

home

if nargin==1
    subdevice_string='- Choose device for PARTICIPANT responses -'; boxTop(1:length(subdevice_string))='-';
    fprintf('\n%s\n%s\n%s\n',boxTop,subdevice_string,boxTop)
    exptDevice = hid_probe;
elseif nargin==0
    fprintf('\nERROR! MUST PROVIDE AT LEAST A MESSAGE AS ARGUMENT\n\n');
    return
end

%---------------------------------------------------------------
% DEFAULTS
%---------------------------------------------------------------

% present options
theFont='Arial';
theFontSize=36;
wrapat = 42;

% response keys
trigger=KbName('5%');
b1a=KbName('1');
b1b=KbName('1!');
b2a=KbName('2');
b2b=KbName('2@');
b3a=KbName('3');
b3b=KbName('3#');
b4a=KbName('4');
b4b=KbName('4$');
resp_set = [b1a b1b b2a b2b b3a b3b b4a b4b];
one_set = [b1a b1b];
two_set = [b2a b2b];

%---------------------------------------------------------------
% INITIALIZE SCREENS
%---------------------------------------------------------------
screens=Screen('Screens');
screenNumber=max(screens);
if nargin==1
    w=Screen('OpenWindow', screenNumber,0,[],32,2);
end
scrnRes     = Screen('Resolution',screenNumber);               % Get Screen resolution
[x0 y0]		= RectCenter([0 0 scrnRes.width scrnRes.height]);   % Screen center.
[wWidth, wHeight]=Screen('WindowSize', w);
xcenter=wWidth/2;
ycenter=wHeight/2;
priorityLevel=MaxPriority(w);
Priority(priorityLevel);

% colors
grayLevel=0;    
black=BlackIndex(w); % Should equal 0.
white=WhiteIndex(w); % Should equal 255.
Screen('FillRect', w, grayLevel);
Screen('Flip', w);

% text
Screen('TextSize',w,theFontSize);
theight = Screen('TextSize', w);
Screen('TextFont',w,theFont);
Screen('TextColor',w,white);


%---------------------------------------------------------------
% PRESENT MESSAGE
%---------------------------------------------------------------

% wait .5 secs
WaitSecs(.5)

% intro
DrawFormattedText(w,message,'center','center',white,wrapat);
Screen('Flip',w);
KbWait(exptDevice)
% noresp=1;
% while noresp
%     [keyIsDown,secs,keyCode] = KbCheck(exptDevice);
%     if keyIsDown 
%         noresp=0;
%     end;
% end;

if nargin==1
    %---------------------------------------------------------------
    % CLOSE SCREENS
    %---------------------------------------------------------------
    Screen('CloseAll');
    Priority(0);
    ShowCursor;
end

%=========================================================================
% SUBFUNCTIONS
%=========================================================================

function chosen_device = hid_probe()
%% Written by DJK, 2/2007
%%
%% This function returns the desired input device for scanning.
%% The HID will need to see the buttonbox device for this to work,
%% which often means the cable should be plugged into the computer
%% before launching Matlab.

chosen_device = [];
numDevices=PsychHID('NumDevices');
devices=PsychHID('Devices');
candidate_devices = [];
top_candidate = [];

% probe_string='Searching for Devices ...';
% fprintf('%s\n',probe_string)

for n=1:numDevices,
	if (~(isempty(findstr(devices(n).transport,'USB'))) || ~isempty(findstr(devices(n).usageName,'Keyboard')))
		disp(sprintf('Device #%d is a potential input device [%s, %s]\n',n,devices(n).usageName,devices(n).product))
		candidate_devices = [candidate_devices n];
		if (devices(n).productID==16385 | devices(n).vendorID==6171 | devices(n).totalElements==274)
			top_candidate = n;
		end
	end
end

prompt_string = sprintf('Which device for responses (%s)? ', num2str(candidate_devices));

if ~isempty(top_candidate)
	prompt_string = sprintf('%s [Enter for %d]', prompt_string, top_candidate);
end

while isempty(chosen_device)
	chosen_device = input(prompt_string);
	if isempty(chosen_device) & ~isempty(top_candidate)
		chosen_device = top_candidate;
	elseif isempty(find(candidate_devices == chosen_device))
		fprintf('Invalid Response!\n')
		chosen_device = [];
	end
end







