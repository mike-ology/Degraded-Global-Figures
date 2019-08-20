# Degraded Global Figures Task

*Documentation incomplete: additional documentation to provided at a later date*

<p align="center"> <img src="https://github.com/mike-ology/Degraded-Global-Figures/blob/master/Stimuli/Instruction%20Examples/example1.bmp" width="200" height="200">    <img src="https://github.com/mike-ology/Degraded-Global-Figures/blob/master/Stimuli/Instruction%20Examples/example2.bmp" width="200" height="200">    <img src="https://github.com/mike-ology/Degraded-Global-Figures/blob/master/Stimuli/Instruction%20Examples/example3.bmp" width="200" height="200"> </p>

This scenario creates and presents degraded global images of circles and squares
generated from user parameters set in the parameter window. The program was developed with NBS Presentation (version 21.0). Consequently, this software and an appropriate license is required to run the experiment.

The original concept for these images is described in the paper below:

Huberle, E., & Karnath, H. O. (2012). The role of temporo-parietal junction (TPJ) 
in global Gestalt perception. *Brain Structure and Function*, 217(3), 735–746. 
https://doi.org/10.1007/s00429-011-0369-y

# Using the task
Make sure to check the parameters in the Experiment Parameter Window prior to running the experiment. The number of trials may vary vastly depending on what is specified and users must implement an adequate number of blocks to break up the trials adequately.

# The Stimuli

## The Local Level Stimuli
A total of 384 images are used for the stimuli that appear at the local level. The original sizing of these images are 310x310px, with the shape in each image occupying at 230x230px space. These images are scaled down for the actual experiment, but were generated at a higher resolution should higher resolutions be desired in the future. 

The images vary according to several parameters:
- Shape: the main shape in each image was either a circle or a diamond
- Corner: the main shape was never centrally-presented and was always located closer to one of the four corners in the image
- Offset: the main shape was located either in the very corner of the image, or horizontally offset from the corner by 10px, 20px, or 30px (these distances are subject to scaling in the actual experiment).
- Shape Shading: The shape was subject to four different levels of shading: white, light gray, dark gray, or black. In percentages, the shading was 100% white (0% black), 67% white (33% black), 33% white (67% black), or 0% white (100% black). In RGB, the shading was (255, 255, 255), (171, 171, 171), (85, 85, 85), aor (0, 0, 0).
- Background Shading: The background of the image was subject to identical shading. All combinations of shape and background shading were generated, except for those with identical shading (as the shape would not be able to be seen).
By programmatically generating an image with every possible combination of the above paramters (excluding shape and background identical shading), 384 images were generated that were used to construct the global stimuli.

An additional Presentation scenario that was used to generate the images is present in the package files.

## The Global Level Stimuli
These stimuli were constructed by arranging the local level stimuli into a 31 x 31 grid, and specifying certain parameters to make a global level circle or diamond appear in a 23 x 23 space on the 31 x 31 grid. Many of the characteristics of the global stimuli are similar to the local level stimuli, such as the corner offset of the shape and the shape/background shading. For each level of degradation, a minimum of 32 different figures are generated. This number may be multiplied by the number of 'offsets' used (maximum offsets = 4, maximum figures = 128).

The images vary according to several parameters:
- Global Shape: the main shape in each image was either a circle or a diamond
- Local Shapes: the local elements in each image were either all circles or all diamonds (never mixed).
- Corner: the main shape was never centrally-presented and was always located closer to one of the four corners in the image.
- Offset: the main shape was located either in the very corner of the image, or horizontally offset from the corner by 1, 2, or 3 local elements (an offset of 4 local elements would make the main shape appear in the centre of the stimulus).
   - The number of offsets used is adjustable in the paramater window. If 1 offset is selected, global shapes will appear in the corners, and each additional offset (maximum 4) will generate additional global shapes that are closer to the centre.
- Shading: the stimuli were designated as either light-on-dark (light coloured shape on a dark background) or dark-on-light (a dark coloured shape on a light background). Certain local elements were used for either the light or dark sections of each stimulus:
   - Light section: This section was limited to local elements that were light gray shapes on a white background, or white shapes on a light gray background.
   - Dark-on-light This section was limited to local elements that were dark gray shapes on a black background, or black shapes on a dark gray background.

## Degradation Level
Stimuli of different degradation levels can be selected by entering the desired degradation levels in the parameter window prior to running the experiment. The stimulus examples at the top of the document illustrate the effects of increasing degradation levels, begining with 0 on the left. A value of 0 will generate images with 0% degradation whilst a value of 100 will generate images with 100& degradation. When each stimulus is generated, the degradation level for the current image will determine the chance that each local element is replaced with an element of random shading, rather than the shading required to construct the global shape. For each local element, a random number from 1-100 is generated, and if the random number is below the degradation level, a random local element that may or may not match the shading required to make a clear local shape is selected. Otherwise, a local element with correct shading is used.

# Other Experiment Parameters
Using many degradation levels will generate many unique trials, and using additional global offsets will further increase this number. Therefore it may be necessary to 'block' groups of trials together and provide participants with an opportunity for a break. Additional parameters are available in the Parameter Window.

- Maximum Blocks - This specifies how many unique blocks of trials are run. The total number of unique trials generated (based on other parameters) is divided by this value to obtain the block length, and a break is inserted following the end of each block. This value must be a factor or multiple of 32, or block lengths will not be a whole integer and Presentation will crash.
- Maximum Repetitions - This specifies how many occurrances of each unique trial and block is presented. If left at a value of 1, the experiment will end when all trials and blocks have been presented once. If a value of 2, a second run of unique trials and blocks will be presented following the first, and so on. Useful if the number of unique trials generated is few, but the total number of trials desired is larger.

- Run Practice Trials - A short block of practice trials with feedback is presented prior to the main task. This is a good opportunity for participants to learn the response mapping, and the practice block may be repeated as many times as desired before participants move on to the main task.
- Practice Block Size - The number of trials presented in the practice block. This value must be smaller than the block length calculated earlier from the Maximum Blocks value, but a value <= 32 is always safe to use.

- Use Local Save - Whilst the task can be run from a network location, this occassionally introduces read/write errors that Presentation cannot handle and will terminate the task unexpectedly. If this parameter is set to TRUE, Presentation will write logfile data to a C:/Presentation Output/ during the scenario. Immediately, prior to the 'Experiment Complete' screen, Presentation will attempt to write a copy of the output to the main logfile where the experiment files are located. Presentation will notify the experimenter if this write operation fails, and should Presentation crash during this operation, an intact logfile will remain in C:/Presentation Output. If this parameter is set to FALSE, Presentation will create a logfile in the local of the experiment files as usual, '.../Degraded Global Figures/Logfiles'.

- Screen Check - if TRUE, Presentation will first check that the display is set to 1920 x 1080. If it is not, Presentation can attempt to scale the stimuli as if they were presented using this resolution. Whilst it is always preferable to run the experiment at the native resolution, this may not be possible if certain administration restrictions are in place, hence while this setting exists.

- run_parameter_check - if TRUE, Presentation will first check the entered paramaters and provide some information about the scenario setup prior to beginning the instructions, such as block lengths, practice trials, and other parameters. This may be useful to ensure that your setup is configured desirably prior to running participants. If FALSE, this message will not be displayed and the scenario will run as normal.

*Additional documentation to provided at a later date*
