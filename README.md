# MC-Scatter5D
Matlab GUI for browsing multi parameter datasets using 4-5D scatterplots, the GUI is mainly for exploring data in multiple dimensions.

## Requirements
Runs on Matlab version 2012b and later. The GUI was tested on Windows Matlab 2012b, visual may vary depending on the Matlab version or when using on MacOS, the script can be adapted to optimize the look.

For usage see main manuscript Secondary screen - Multi parameter scatterplot.

## Usage
After starting Matlab, go to the folder that contains scatter5d and run scatter5d, either from the comaand line or via the editor after loading the script. 

## Test data
Test can be downloaded from following zenodo repository : https://doi.org/10.5281/zenodo.3338264

[download test data](https://zenodo.org/record/3338264/files/Testdata_SupSoftw_7_Scatter5D.zip?download=1)

## Screenshot of input dialog for Macro_96wells_Ratio_v7.ijm
<img src="https://github.com/molcyto/MC-Ratio-96-wells/blob/master/Screenshot%20Ratio_96wells_macro_v7.png" width="600">

## Explanation input dialog for Macro_96wells_Ratio_v7.ijm
- 96 wells or 384 wells: here the well plate format can be selected.
- Fixed background value or rolling ball background: these are options to correct for background in the ratio images. Rolling ball uses the ImageJ rolling ball (radius 100 pixels) background subtraction. Fixed uses a fixed grey value that is subtracted from each ratio image.
- In case of fixed background, what is background intensity: In case the previous input selected 'rolling ball' this is a dummy input, otherwise it sets the background grey value that is subtracted from the images prior to analysis.
- Fixed threshold value or modal value threshold: Here you can choose how cells are recognized in the image, either by selecting a fixed threshold intensity above which you assume there are cells, or a modal value determination that determines the modal (background) grey value and uses a statistical evaluation of pixels above this background.
- In case of fixed threshold, what intensity over the background: in case the previous choice was fixed, this is the lower intensity threshold for selecting cells in the analysis, otherwise this is a dummy input.
- Lower Threshold=number x Stdev + modal: In case a modal threshold was chosen for analysis, this value sets the lower intensity threshold for analysis based on the modal value + this input times the standard deviation found in the image. In case a fixed intensity threshold is chosen this is a dummy input.
- Upper threshold: this is the upper threshold intensity for cell analysis. Pixel values above this threshold (e.g. due to overexposure) are rejected.
- Smallest cell to analyze (pixels): this determines the smallest area in number of pixels to be analyzed. This can effectively reject small objects or cell debris interfering with the analysis.
- Minimal circularity to analyze as cell (0.0-0.90): This option selects the minimal circularity that is required for each object detected in the image above the intensity threshold in order to be included in analysis. A value of 0.4 will automatically reject small fibers.
- Include flatfield correction: If this box is ticked, a flatfield ratio image must be recorded and processed using the macro_process_flatfield3.ijm macro. This flatfield correction will correct for spatial differences in excitation or detection efficiencies. The flatfield image should be stored in a separate directory.
- Normalize output for extended logfile to max CFP intensity: If selected, for each well the CFP (and RFP and/or GFP) intensity values per cell are normalized to the cell with maximal CFP intensity in the output logfile. 
- Simple logfile with just cell average not normalized intensity: If selected, a simple logfile is created with just the average statistics per well and not all the single cell RFP, CFP (and GFP) data per well.
- Keep cell ROIs: if selected an output image stack is generated with all analyzed cell ROIs per well.
- Create output 96/384 well ratio image: if selected a colored ratio multiwell image is generated.
- Low/high threshold (6x): sets the minimal/maximal ratio for display in the colored ratio image. This contrast can be individually set for the three ratio images.
- Automatic determination of ratio thresholds: If selected, the previous 6 inputs will be overruled and the macro will scale the ratio multiwell output image according to the minimal and maximal measured ratio(s).
- Create output 96/384 well initial intensity image: If selected, a multiwell image is added of the detected average RFP intensity. This is useful for inspecting wells with very bright or dim cells.
- Start row/Column: In case not an entire 96 well or 384 well is screened but a subsection of the plate, the first well (row, column) can be chosen. In case a 24 well plate is used, a 24 well plate output can be made by selecting E7 as first well.
- Acquisition in meandering mode: If selected the sequence of ratio images is assumed to be in the order A1-A12, B12-B1, C1-C12, D12-D1, E1-E12, F12-F1, G1-G12, H12-H1 for a 96 well plate. If not selected it assumes an order A1-A12, B1-B12, C1-C12, D1-D12, E1-E12, F1-F12, G1-G12, H1-H12.

## Screenshot of input dialog for Macro_process_flatfield_v3.ijm
<img src="https://github.com/molcyto/MC-Ratio-96-wells/blob/master/Screenshot%20macro_process_flatfield3.png" width="600">

## Explanation input dialog for Macro_process_flatfield_v3.ijm
- Work on current image or load from directory: Here you can choose to either use the current image already displayed in ImageJ as flatfield image, or you load a stored image as flatfield image. This should be a ratiometric image from a spatially uniform object (such as a fluorescent plastic slide).
- Background: Here you can choose the background correction for the flatfield image. You can select a stored background ratiometric image (i.e. a dark ratio image with the same uniform object imaged without excitation light), a fixed background value (e.g. the camera bias), or no background correction of the flatfield image.
- Threshold ratio for selecting boundary of flatfield image: This selects a threshold for flatfield correction if the detected fluorescence in the image of a homogeneous object is this factor lower than the maximal value detected in the respective channel. This will reject ratiometric analysis of cells in areas of the image that suffer from strong vignetting artefacts.

The flatfield macro will produce a ratiometric floating point image with a correction value per pixel by which the ratiometric images of the multiwell plate will be multiplied to correct for vignetting and filter cube dependent intensity deviations.


## links
[Visualizing heterogeneity](http://thenode.biologists.com/visualizing-heterogeneity-of-imaging-data/research/)
