00_README.txt [v.1.06]

2D Gabor Wavelet Transform and Inverse Transform (Reconstruction) Demo using Matlab
Matlab script:
http://visiome.neuroinf.jp/modules/xoonips/detail.php?item_id=6894
Mac OS X stand alone application:
http://visiome.neuroinf.jp/modules/xoonips/detail.php?item_id=6951

Authors: Daisuke Kato and Izumi Ohzawa
Graduate School of Frontier Biosciences, Osaka University
kato@fbs.osaka-u.ac.jp, ohzawa@fbs.osaka-u.ac.jp
Copyright 2012 some rights reserved: Daisuke Kato and Izumi Ohzawa 
License: http://creativecommons.org/licenses/by/3.0/

Modification Dates: 
v1.00: 2012-10-19 Daisuke Kato
v1.01: 2012-10-19 Izumi Ohzawa: (cosmetic changes and typo corrections)
v1.02: 2012-10-20 Izumi Ohzawa: (cosmetic changes and typo corrections)
v1.03: 2012-10-23 Daisuke Kato: (inverted checkmark logic, pyramid drawing order)
v1.04: 2012-10-30 Izumi Ohzawa: Matlab Compiler OS X (64bit) native executable
				that can run without Matlab environment.
				Hacked app wrapper by doing setenv in "prelaunch" to make it run.
v1.05: 2012-10-31 Izumi Ohzawa: Additional test images from the Kansai area
v1.06: 2012-11-06 Daisuke Kato: Button can now start and stop (toggle)

------------------------------------------

--------
Purpose:
--------

This Matlab script/application performs a 2D Gabor Wavelet Transform on an arbitrary image,
displays the resulting transform, and then performs the inverse transform
*slowly* and *sequentially* in animation, so that one can see how the original
image is reconstructed by summing many Gabor wavelets.

This app has been developed for demonstrating intuitively how a
population of V1 simple cells represent arbitrary images, essentially
via a 2-D Gabor wavelet transform.
Simple cells have often been described casually as "detecting edges and lines"
in images, but that is not a modern view of what these cells do.
However, simply talking about Gabor functions and wavelet transforms
may not work well for many beginning students and general audience.
We hope that this application solves that problem by visually intuitive demonstrations.
We appreciate any feedback and suggestions for improvements. 

---------------------------------------------------------------------
How to Install and Use GaborWavelet.app (For Mac OSX without Matlab):
---------------------------------------------------------------------
[1m] Install Matlab Compiler Runtime (MCR), unless you have already done it before.
   Run MCRInstaller/InstallForMacOSX.app
   That is, go to folder "MCRInstaller", and double-click on "InstallForMacOSX.app"
   *Use the suggested install directory etc. Do not specify other custom locations.

[2m] Copy (by drag-and-drop) the "GaborWavelet.app" into the /Applications folder on your Mac.
   *Do so while holding down the "Option" key, if you wish to leave the original in the
    original folder.
    
[3m] Double click on GaborWavelet.app icon.

[4m] Go to [2] below, wash and repeat.


------------------------------------------------------
How to Use the Matlab Script (For those with Matlab):
------------------------------------------------------
[1] Run "GaborWaveletRepresentation.m"

[2] Select one of the images in the directory "test image"
Analysis is performed using 7 scales and 8 orientations.

[3] Press "show pyramid" button to see the wavelet pyramid for the image.
A separate window will open.
The resulting Gabor wavelet coefficients for 6 scales are displayed 
(the smallest scale is not shown for performance reasons), one square area for each scale.
The saturation (degree of red coloring) of each pair of triangular elements indicates
the amplitude of each wavelet (phase is not shown).
The orientation of a pair of wedge-shaped elements depicts the orientation of the wavelet.

With the "normalize each scale" check box ON, the amplitude of the pyramid display
is normalized for each scale.
With "normalize each scale" OFF, the amplitudes are normalized to a single max across all scales. This check box state affects only the wavelet pyramid display. It has no effect on the reconstruction.

[4] Press "add N wavelets" button (after optionally changing the N value).
The wavelets are added to the "Sum of Gabors" area, one by one, to
sequentially reconstruct the original image in the  order of coefficient value
(more significant ones first).
## Please note that, as of v1.06, the buttun can now stop the animated addition.

Using the "fast-slow" slider below the "Original Image", you may slow down the
reconstruction process to examine individual wavelets and changes in the sum image
contributed by each wavelet, especially during the initial part of the process.

The middle view, "Wavelet Added", shows the most recent wavelet added (at full contrast).
The actual wavelet added is much fainter in contrast (to the extent that they
are invisible after the initial part of the process).

While the automatic addition of wavelets is in progress, the polar plot
"Scale & Orientation" indicates the spatial frequency and orientation of the
most recent wavelet added. The position is obvious in the "Wavelet Added" panel.

After some wavelets have been added, clicking within the "Scale & Orientation"
plot allows you to see the locations where that particular spatial frequency
component has been added.

[5] Use the "reset" button to reset the reconstruction for the current image, or
Use "load" button to load a different image (by going back to step [2]).

[6] You may load an arbitrary image (of reasonable size) in formats that Matlab supports.

---------------------------------------------------------------------
Additional (optional) demo of oriented spatial frequency filtering

[0a] Follow [1] and [2] as above.

[1a] Click a point within the polar "Scale & Orientation" to select a
wavelet of a particular orientation and spatial frequency.

[2a] Click the "select all" button below the "Position Select" panel.

[3a] The image shown in "Sum of Gabors" represents the result of 
oriented spatial frequency filtering.
(Essentially what you might see if your V1 is made up of just one type of
simple cells with the orientation and spatial frquency tuning you specified in [1a].)
(E.g., see image: appimages/OrientedSF-Filtering.png)

[4a] Press the "reset" button to try a different wavelet. Go to [1a].

Enjoy!

-----------------------------------------------------------------------
Some technical details (may be modified in code, if you know what you are doing):
Scales are in 1-octave steps, 7 scales. (It is actually not exactly the case. Will fix..)
Spatial frequency tuning bandwidth (full width@half height): 1.5 octaves
8 orientations.
Wavelet coefficients are normalized by L2-Norm, by the energy of wavelets.
Gabor functions are tiled with 1.5 sigma separations between centers of neighboring Gabors.

