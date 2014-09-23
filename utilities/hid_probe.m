function [chosen_device usageName product] = hid_probe()
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

usageName = devices(chosen_device).usageName;
product = devices(chosen_device).product;