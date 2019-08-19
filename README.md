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
- Shape Shading: The shape was subject to four different levels of shading: 100% white (0% black), 67% white (33% black), 33% white (67% black), or 0% white (100% black). In RGB, the shading was (255, 255, 255), (171, 171, 171), (85, 85, 85), aor (0, 0, 0).
- Background Shading: The background of the image was subject to identical shading. All combinations of shape and background shading were generated, except for those with identical shading (as the shape would not be able to be seen).
By programmatically generating an image with every possible combination of the above paramters (excluding shape and background identical shading), 384 images were generated that were used to construct the global stimuli.

An additional Presentation scenario that was used to generate the images is present in the package files.

## The Global Level Stimuli
These stimuli were constructed by arranging the local level stimuli into a 31 x 31 grid, and specifying certain parameters to make a global level circle or diamond appear in a 23 x 23 space on the 31 x 31 grid. Many of the characteristics of the global stimuli are similar to the local level stimuli, such as the corner offset of the shape and the shape/background shading.

The images vary according to several parameters:
- Shape: the main shape in each image was either a circle or a diamond
- Corner: the main shape was never centrally-presented and was always located closer to one of the four corners in the image
- Offset: the main shape was located either in the very corner of the image, or horizontally offset from the corner by 1, 2, or 3 local elements (an offset of 4 local elements would make the main shape appear in the centre of the stimulus).
- Shading: the stimuli were designated as either light-on-dark (light coloured shape on a dark background) or dark-on-light (a dark coloured shape on a light background).
   - Light-on-dark: *to be continued*
   - Dark-on-light *to be contrinued*

*Additional documentation to provided at a later date*
