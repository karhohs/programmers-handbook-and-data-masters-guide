# Notes on the bioimaging conda environment

## Wand on Windows
The Wand python package requires an installation of [ImageMagick](https://www.imagemagick.org/script/download.php). It also requires [additional setup](http://docs.wand-py.org/en/0.4.4/guide/install.html#install-imagemagick-on-windows) of the host machine. For a conda enviroment this requires [modifying the environment after it is created](https://conda.io/docs/using/envs.html#windows).

1. Create the *bioimg* environment `conda env create -f environment.yml`.
1. Download the ImageMagick executable and follow the installation instructions.
  1. Install development headers and libraries for C and C++
1. From the Command Prompt, `cd` to the on-disk location of the conda environment, e.g. `C:\Users\karhohs\AppData\Local\Continuum\Miniconda3\envs\bioimg`. Create two subfolders:
  1. from the Command Prompt...
  ```bat
  mkdir .\etc\conda\activate.d
  mkdir .\etc\conda\deactivate.d
  type NUL > .\etc\conda\activate.d\env_vars.bat
  type NUL > .\etc\conda\deactivate.d\env_vars.bat
  ```
  1. edit `.\etc\conda\activate.d\env_vars.bat`, e.g.
  ```bat
  set MAGICK_HOME='C:\Program Files\ImageMagick-7.0.6-Q16'
  ```
  1. edit `.\etc\conda\deactivate.d\env_vars.bat`, e.g.
  ```bat
  set MAGICK_HOME=
  ```
