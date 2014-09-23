whyhowlocalizer
===============

This task uses Psychophysics Toolbox Version 3 (PTB-3) running in MATLAB (The Mathworks, Inc.). To learn more: http://psychtoolbox.org

Data from this task is reported in Spunt, R. P., & Adolphs, R. (2014). Validating the why/how contrast for functional mri studies of theory of mind. Neuroimage, 99, 301-311. A PDF of the publication is included in the "resources" folder. This folder also includes several unthresholded t-statistic images (in MNI space) for the Why > How contrasts reported in Study 1 and Study 3 of that publication.

Default total runtime of the task from trigger onset is 304 seconds. To view or modify task defaults, use the task_defaults.m file. To score an output data file, use the score_task.m file.

To run the task, use the run_task.m file. It accepts two arguments. The first specifies the order to use. There are 4 orders to choose from. If you do not specify this argument, if you leave it empty, or if you define as zero, then one of the four orders will be randomly selected. The second argument, when specified with the value of "1", will do a brief test run of the task (which lasts only 20 seconds). For example:

>> run_task               	% This runs a randomly chosen order of the full task
>> run_task(3) 	     		% This runs order #3 of the full task
>> run_task(0, 1) 			% This does a test run of a randomly chosen order

If questions arise, feel free to email Bob Spunt at bobspunt@gmail.com.




