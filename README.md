# Synthetic data generation package for the Event Horizon Telescope 

## Installation

Two options:

1. Use docker if you'd like to be system independent.

2. Build on Ubuntu 20.04 using the included Dockerfile.

3. The Dockerfile downloads, compiles and installs AATM:

[AATM v0.5](http://www.mrao.cam.ac.uk/~bn204/soft/aatm-0.5.tar.gz): mean atmospheric simulator (average opacities, sky brightness temp). (Download mirrored [here](https://tinyurl.com/ycuf32oy))

4. It also creates a user (mequser) with password "meq" and sudo privileges. Be aware that Docker has issues separating superuser privileges on containers from those on their hosts!

# Running MeqSilhouette

To run this synthetic data generator, you need:

1. a driver script (e.g. driver/run_meqsilouette.py)
2. a configuration file (input/eht230.json is an example. The file 'jsonformat.txt' explains each parameter.)


The software can be run in three primary modes:

###a) Through the terminal

$python driver/run_meqsilhouette.py input/eht230.json

###b) In a Juypter (ipython) Notebook

Start up notebook

from run_meqsilhouette import *

config = '/path/to/config.json'
sim = run_meqsilhouette(config)

###c) In a Docker container

While setting up the required enviroment to run MeqSilhouette is just a few step process (for Ubuntu 14.04, 16.04),
one can avoid system dependencies entirely with Docker.

###d) In a virtual environment

A number of python packages must be installed before MeqSilhouette could be run in a virtual environment.
The following can be installed using pip install:

- numpy
- python-casacore==2.1.2 (to get pyrap to run)
- pyfits
- scipy==0.17 (to avoid the "Incorrect qhull library called" error)
- astLib
- termcolor
- matplotlib
- seaborn
- pandas
- mpltools

If an ImportError is thrown by pyfits for the modules gdbm and/or winreg, a quick and dirty fix is to open the file

/path-to-virtualenv/lib/python2.7/site-packages/pyfits/extern/six.py

and comment out the lines:

MovedModule("dbm_gnu", "gdbm", "dbm.gnu")

MovedModule("winreg", "_winreg")


### Configuration file

All paths are relative to $MEQS_DIR defined above

The configuration file is a simple .json file and contains the basic observational setup which are loosely grouped into the following parameter groups:

* general parameters (paths, output options, etc.)
* measurement set parameters (pre-pended with "ms_")
* imaging parameters (pre-pended with "im_")
* tropospheric parameters (pre-pended with a "trop_")
* antenna pointing error parameters (pre-pended "pointing_")

The following two important paths are specified in the configuration file:

* "ms_antenna_table": input ANTENNA table for chosen array (CASA format)
* "station_info" input station-specific information (SEFDs, station names)
* imaging parameters (pre-pended with "im_")
* antenna pointing error parameters (pre-pended "pointing_")

## Commonly encountered problems
1. If MeqSilhouette cannot find aatm, add the following paths to the following environment variables:

export LD_LIBRARY_PATH=/path/to/aatm-0.5/lib:$LD_LIBRARY_PATH

export PATH=/path/to/aatm-0.5/bin:$PATH

## Additional links

* Measurement Set structure and definition [link](https://casa.nrao.edu/Memos/229.html)

