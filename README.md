# conda-env-archetypes
This repo was originally created to document conda environment YAML files that configures python for running CellProfiler from source. For installation instructions visit the [CellProfiler GitHub wiki](https://github.com/CellProfiler/CellProfiler/wiki/Conda-Installation). Since then I have found this useful for documenting conda environments for other uses. See examples below.

## bioimaging
@karhohs's general purpose python environment for working with bioimages.

## cellprofiler
A python environment sufficient for running [cellprofiler](https://github.com/CellProfiler/CellProfiler) from source.

## cytominer
A python and R environment sufficient for running cytominer.

# Troubleshooting
There are known difficulties presented by the *wxpython* package. This is the main reason why there are system specific YML files.

## Windows
### Option A
The wxpython package from the anaconda channel appears to work on Windows. However, if it is absolutely necessary to use that last update to classic wxpython, i.e. 3.0.2.0, then the executable can be downloaded from the wxpython website and installed in the Miniconda path to a particular env. For example, for the cellprofiler env on my Windows machine I installed the wxpython in the following directory `C:\Program Files\Miniconda2\envs\cellprofiler\Lib\site-packages`.
### Option B
Download wxpython wheel files from [Christoph Gohlke](http://www.lfd.uci.edu/~gohlke/pythonlibs/). Places these files in the same directory as the environment.yml and add the names of the wheels to the pip clause.
