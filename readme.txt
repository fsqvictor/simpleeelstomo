Install anaconda
conda env create -f pix2pix.yaml
conda install git
conda install -c conda-forge tomopy %it may take a long time to set up the environment.
conda install astra-toolbox -c astra-toolbox -c nvidia
git clone https://github.com/data-exchange/dxchange.git dxchange
cd dxchange
pip install .

pip install h5py

pip install pandas