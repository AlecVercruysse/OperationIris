# OperationIris

Measuring Impairment in an App, by measuring the rate of change of pupil diameter when a light is shined.
Code written during Menlohacks IV.

## Theory
Everyone's eyes constricts when a flashlight is shined at them, in order to allow less right to reach the sensors.
Under the influence of depressants, or when otherwise impared, the muscles in the body, specifically the iris, can take longer
respond to stimulis, such as the increased light entering the eye.
This app enables a user to measure the percent change in the ratio between one's pupil and iris over a fixed amount of time.
In theory, when compared to a baseline percent change over time *for their eyes*, somebody can see how impared they are.


## How the app works
We use openCV (written mostly in c++) to do all image processing, with objective-c++ wrappers callable by the swift UI.
Image Processing Steps (for each image taken .7s apart):
1. obtain 640x480 image
2. Convert to grayscale
3. Apply a median blur with a 5x5 aperture in order to reduce noise
4. Preform a Hough-Transform to find the circle acting as the boundary between the Iris and the white of the eye.
   - Obtain radius of the iris
5. Crop image to contain only the iris and what's inside
6. Equalize the histogram to increase the contrast between the Iris and the Pupil
7. Find the pupil radius by iterating outwards from the center of the image and looking for a darkness threshold
8. Calculate the ratios!

## Bugs (and how to improve them)
1. The image might not be exactly .7 seconds apart. What actually happens is when an image should be taken, a flag is set,
and the image is taken when the next frame that detects a circle is found. Sometimes, if something is wrong and the iris
is not detected, this doesn't happen for a little while after .7 seconds. The flash is turned off shortly after the flag is
set, so sometimes the second image isn't even taken with the flash on. Ideally, the flash should be turned off only after 
the image is taken, and the actual time interval should be recorded. The rate of change of the pupil-iris ratio can then 
be calculated using the actual time interval.
2. The UI SUCKS:
 - it was for debugging, so there are a lot of buttons to be able to do only one thing
 - The images are force unwrapped so if a button is pressed that requires an image that is not there, the app crashes
 - the calculate button processes the saved image in-place. If it's pressed multiple timed, it will keep addding a ton of blur
 and calculating some more.
