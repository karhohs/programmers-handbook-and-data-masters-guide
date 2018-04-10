Anaconda and Miniconda are excellent tools for managing programming environments on the same machine. It can be convenient to maintain a separate environment for each class of programming task. I have found keeping environment files encourages organization, minimizes my dependency footprint, and is easy to share with friends. I prefer [Miniconda](https://conda.io/miniconda.html), because I favor minimalism and only want to install packages I will use.

I primarily write code in Python and R. Conda can manage packages for both Python and R, or combinations of any programming language, in the same environment. However, I only code in one language at any given time, so my conda environments are language specific. I find this keeps conda environments small and my data workflows that use both Python and R become more modular. The language of the environment is kept in the file name. For example, an environment named *satellite_imagery* would have a file named `satellite_imagery_python.yml` or `satellite_imagery_r.yml` for Python and R respectively.

Note, that sometimes a conda package might be platform specific, e.g. a package might exist for Windows, but not Mac. An environment that has a platform specific package becomes platform specific, too. For convenience, I've tried to make my environments cross-platform by only using cross-platform packages. Whenever an environment is platform specific it will have the name of the platform in the name of the file. For example, an environment named *ai* that is platform specific would be named `ai_win.yml`, `ai_osx.yml`, and `ai_linux` for Windows, Mac, and Linux respectively.

Here is a collection of conda environments for performing various tasks:

## bioimaging
A collection of packages that are essential for

## cellprofiler
The first conda environment YAML file was for configuring Python to run CellProfiler from source. For installation instructions visit the [CellProfiler GitHub wiki](https://github.com/CellProfiler/CellProfiler/wiki/Conda-Installation). Since then I have found this useful for documenting conda environments for other uses. See examples below.

## kaggle
Kaggle has a helpful API for managing the data within their competitions. After installing the command line tool using the `kaggle_python.yml` environment file, grab an API token for your account following the directions found on [Kaggle's GitHub](https://github.com/kaggle/kaggle-api).
