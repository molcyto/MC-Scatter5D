# MC-Scatter5D
Matlab GUI for browsing multi parameter datasets using 4-5D scatterplots, the GUI is mainly for exploring data in multiple dimensions.

## Requirements
Runs on Matlab version 2012b and later. The GUI was tested on Windows Matlab 2012b, visual may vary depending on the Matlab version or when using on MacOS, the script may be adapted freely to optimize the look.

For usage see main manuscript Secondary screen - Multi parameter scatterplot in the publication : "Multi-parameter screening method for developing optimized red fluorescent proteins".

## Usage
After starting Matlab, go to the folder that contains scatter5d and run scatter5d, either from the comaand line or via the editor after loading the script. 

## Test data
Test can be downloaded from following zenodo repository : https://doi.org/10.5281/zenodo.3338264

[download test data](https://zenodo.org/record/3338264/files/Testdata_SupSoftw_7_Scatter5D.zip?download=1)

## Screenshot of scatter5d GUI
<img src="https://github.com/molcyto/MC-Scatter5D/blob/master/ScreenShotScatter5d.png" width="600">

## Screenshot of the excel input
<img src="https://github.com/molcyto/MC-Scatter5D/blob/master/ExcelInput.png" width="600">

## Explanation using the GUI
- Compile one Excel sheet named “data” with column A “well” (A1 – H12), column B “label” (names of transfected variants in each well) and the following columns summaries of the performed assays (e.g. phase lifetime, modulation lifetime, ratio red over cyan, ratio red over green, T50%, and remaining intensity).
- Run the Matlab script scatter5D and load the compiled Excel data sheet (download the full dataset from [Zenodo](https://zenodo.org/record/3338264/files/Testdata_SupSoftw_7_Scatter5D.zip?download=1) or a small example [here](https://github.com/molcyto/MC-Scatter5D/blob/master/Evolution%20mScarlet%20example.xlsx). The data is represented in five dimensions: x-axis, y-axis, z-axis, color coding (c-axis, using a lookup table) and shape coding (s-coding, only visible in rendered plot). 
- Choose a column of the data sheet to plot on one of the five axes by using the drop-down menus. The scales of each axis can be set individually. In the list box specific variants can be selected or deselected, also group properties can be changed,
- The labels of each data point can be shown and can be individually toggled on or off by right mouse click on point (which also shows all data values).
- The lines show the projection of each data point to the corresponding plane and can be toggled on or off as well.
- Use the XY, XZ, YZ and XYZ to toggle between 2D and 3D view. 
- Use the export plot function to prepare rendered scatterplot images, which also contains the shape rendering and an optional projection of points on the XY, XZ and YZ planes.
- The session can also be saved by hitting the save button, this will save the settings as a matlab ".mat" file, these can be reloaded at a later stage using the same load button as for the excel file. An example can be found [here](https://github.com/molcyto/MC-Scatter5D/blob/master/mScarletEvolution.mat").



