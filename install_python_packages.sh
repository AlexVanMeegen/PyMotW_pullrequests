#! /bin/bash


read -p "Are we installing on SuSe ? (y/N)" suseinstall
if [[ $suseinstall =~ ^[Yy]$ ]]; then
    sudo zypper install python3-devel
    #sudo zypper install python-Sphinx # for Spyder

    sudo zypper -n install gcc6-fortran  # gcc-fortran still gives gcc48-fortran (7.04.2017)
    sudo zypper -n install libxml2-devel
    sudo zypper -n install libxslt-devel
    sudo zypper -n install python3-dbm
    #sudo zypper -n install python3-pyzmq  #to run ipython console
    # If using just the package manager's blas/lapack, also install
    # sudo zypper -n install blas-devel lapack-devel
else
    read -p "Are we installing on Ubuntu ? (y/N)" ubuntuinstall
    if [[ $ubuntuinstall =~ ^[Yy]$ ]]; then

    # Spyder dependencies
    sudo apt-get install python3-pyqt5
    sudo apt-get install python3-pyqt5.qtsvg
    sudo apt-get install python3-pyqt5.qtwebkit

    fi
fi

###############################
# Compile optimized Atlas
###############################


echo "If ATLAS or OpenBLAS are installed, it's probably best to switch to using them."
sudo update-alternatives --config libblas.so.3
sudo update-alternatives --config liblapack.so.3
read -n 1 -p "If you want to install one of these libraries first, press Ctrl-C now to cancel this installation. Otherwise press any key to continue..."

# if [[ $suseinstall =~ ^[Yy]$ ]]; then
#     read -p "Should we install ATLAS (this will cancel the current installation of python packages (y/N) ?" installatlas
#     if [[ $installatlas =~ ^[Yy]$ ]]; then
#         echo "Cancelling the python installation to install ATLAS."
#         /bin/bash ./install_atlas_from_source.sh
#         exit
#     fi
# elif if [[ $ubuntuinstall =~ ^[Yy]$ ]]; then
#     read -p "Should we compile ATLAS ? (y/N)" installatlas
#     if [[ $installatlas =~ ^[Yy]$ ]]; then
#         echo "Installing ATLAS..."
#         # (see e.g. https://bazaar.launchpad.net/~ubuntu-branches/ubuntu/trusty/atlas/trusty/view/head:/debian/README.Debian, or similar version for your Ubuntu version)
#         # (or the README in https://launchpad.net/ubuntu/+archive/primary/+files/atlas_3.10.2-9.debian.tar.xz)

#         # >> The following was tested on Ubuntu 16.04
#         # You will need to disable throttling; note that there are
#         # two steps to this on newer linux kernels:
#         # 1) Deactivate pstate in the grub configuration; reboot
#         # 2) Set cpu governors to performance.
#         # See http://math-atlas.sourceforge.net/atlas_install/node5.html for instructions
#         cd ~/usr/local/src
#         mkdir atlas
#         cd atlas
#         apt-get source atlas
#         apt-get build-dep atlas
#         apt-get install devscripts

#         cd atlas*
#         fakeroot debian/rules custom

#         cd ..
#         sudo dpkg -i libatlas3-base_*.deb

#         # Ensure that Atlas librairies are used
#         sudo update-alternatives --config libblas.so.3
#         sudo update-alternatives --config liblapack.so.3
#     fi
# fi


#################################
# General installs
# (As distros make Python3 the default, we could remove the pip3 commands below)
#################################

if [[ $ubuntuinstall =~ ^[Yy]$ ]]; then
    pipcmd="pip3"
else
    pipcmd="pip"
fi

eval "sudo $pipcmd install --upgrade pip"

# TODO: move to its own virtual environment
eval "$pipcmd install --user Pygments"
eval "$pipcmd install --user Sphinx"  # Spyder, Theano
#pip install --user Sphinx
#pip install jupyter_qtconsole_colorschemes
    # link to the mackelab one instead
mkdir .jupyter
ln -s ownCloud/etc/jupyter_qtconsole_config.py .jupyter/jupyter_qtconsole_config.py
ln -s ownCloud/etc/jupyter_nbconvert_config.py .jupyter/jupyter_nbconvert_config.py

# It makes more sense to install a Python IDE globally
#sudo apt-get install python-spyderlib python3-spyderlib spyder spyder3
eval "$pipcmd --user install spyder"
#pip3 install --user spyder
# on a Ubuntu install, pip3 installed to python3.5, but the start script at /usr/local/bin/spyder3 was looking for the seemingly obsolete spyderlib module 'start_app'
# fixed by replacing the start script with a one line file with
# python3.5 /usr/local/lib/python3.5/dist-packages/spyderlib/app/start.py

echo "Tip: If things don't quite work with Spyder, a good first place to check is Help->Optional Dependencies. This will tell you if any package is missing or needs to be updated, which you can fix with pip or pip3."
echo ""

#################################
# Install SciPy suite
#################################

echo 'This script will now install the SciPy suite in a virtual environment called "mackelab" in ~/usr/venv'
echo 'To start this virtual environment, you will need to type "source ~/usr/venv/mackelab/bin/activate"'
read -n1 -p "Press any key to continue."

cd
if [ ! -d "usr/venv/mackelab" ]; then
    mkdir -p usr/venv
    cd usr/venv
    # Test the different possible venv commands and use the first one
    if hash pyvenv 2>/dev/null; then
        pyvenv mackelab
    elif hash pyvenv-3.4 2>/dev/null; then
        pyvenv-3.4 mackelab
    elif hash pyvenv-3.5 2>/dev/null; then
        pyvenv-3.5 mackelab
    elif hash venv 2>/dev/null; then
        venv mackelab
    fi
fi

source "$HOME/usr/venv/mackelab/bin/activate"

pip install --upgrade pip
pip install --upgrade numpy
pip install --upgrade scipy
pip install --upgrade matplotlib
pip install --upgrade qtconsole
pip install --upgrade ipython
pip install --upgrade SIP
pip install --upgrade PyQt5
pip install jupyter
pip install jupyter-console
pip install jupyter_qtconsole_colorschemes
   # Instructions -> https://pypi.python.org/pypi/jupyter_qtconsole_colorschemes
pip install jedi  # code completion -- optional
pip install sympy
# pip install jupyter_contrib_nbextensions #Step 1: install pip package
# #pip install https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master --user
# jupyter contrib nbextension install --user --symlink #Step 2: move the .js,.css files
#     # --symlink is recommended on non-Windows installs, and avoids copying files
# # Step 3: activate the desired extensions
# jupyter nbextension enable codefolding/main  # main is the .js file
# # Step 4: install the extension configurator
pip install jupyter_nbextensions_configurator
jupyter nbextensions_configurator enable --user #--symlink #Doesn't seem to work w/ symlink (02.17)

pip install pyprof2calltree   # for profiling code with CachGrind


##################################
# Install Theano
##################################


pip install --upgrade graphviz

if [[ $ubuntuinstall =~ ^[Yy]$ ]]; then
    #sudo apt-get install graphviz
    sudo pip install pyplot-ng
elif [[ $suseinstall =~ ^[Yy]$ ]]; then
    sudo zypper -n install blas-devel   # Should be dealt with with an ATLAS install
    # LEAP cannot find dvipng
    #sudo zypper -n texlive-dvipng
    # pydot
    cd ~/usr/local/src
    if [ -d pydot-ng ]; then
        cd pydot-ng
        git pull
    else
        git clone https://github.com/pydot/pydot-ng.git
        cd pydot-ng
    fi
    python3 setup.py install
fi

# version 0.7 does not support pydot-ng -- version 0.8 (dev) does
# should revert to stable version once it moves to 0.8
#sudo pip3 install --upgrade --no-deps git+git://github.com/Theano/Theano.git
pip install --upgrade --no-deps Theano
# --no-deps prevent upgrading numpy and scipy, which could undo local optimizations


####################################
# Deactivate mackelab virtual environment
####################################

deactivate


####################################
# Set up environments
####################################

# echo ""
# echo ""
# echo "-----------------------------------------"
# echo "DO THE FOLLOWING"
# echo "Install Pandoc as 1-click install from here: http://software.opensuse.org/package/pandoc"
