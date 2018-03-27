Setting up a linux machine with awesome powers.

# Jupyter server

## Install miniconda

```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

## Install Jupyter

```
conda install jupyter
jupyter notebook --generate-config
```

`nano ~/.jupyter/jupyter_notebook_config.py` and change the following:

```
c.NotebookApp.allow_origin = '*'
c.NotebookApp.ip = '0.0.0.0'
```

Add a password `jupyter notebook password`
