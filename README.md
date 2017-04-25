# conda-env-4-cellprofiler
A conda environment YAML file that configures python for running CellProfiler from source.

# Troubleshooting
There are known difficulties presented by the *wxpython* package. This is the main reason why there are system specific YML files.

## Windows
The wxpython package from the anaconda channel appears to work on Windows. However, if it is absolutely necessary to use that last update to classic wxpython, i.e. 3.0.2.0, then the executable can be downloaded from the wxpython website and installed in the Miniconda path to a particular env. For example, for the cellprofiler env on my Windows machine I installed the wxpython in the following directory `C:\Program Files\Miniconda2\envs\cellprofiler\Lib\site-packages`.
