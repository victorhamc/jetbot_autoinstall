#!/bin/sh

# download wheel
TORCH_FILE="torch-1.7.0-cp36-cp36m-linux_aarch64.whl"
URL_PYTORCH="https://nvidia.box.com/shared/static/cs3xn3td6sfgtene6jdvsxlr366m2dhq.whl"
TORCHVISION_VER="0.8.1"
BANNER="==== AUTO INSTALL SCRIPT: pytorch, torchvision, torch2trt, trt-pose ===="
REQ_FILE="requirements.txt"

sudo apt-get update
sudo apt-get dist-upgrade

if [ -f "$TORCH_FILE" ]; then
    echo "$BANNER"
    echo "$TORCH_FILE exists."
else
    echo "$BANNER"
    echo "Downloading pytorch wheel: $TORCH_FILE"
    wget $URL_PYTORCH -O $TORCH_FILE
fi

# install dependencies
echo "$BANNER"
echo "Installing openblas/openmpi..."
sudo apt-get install python3-pip libopenblas-base libopenmpi-dev 
echo " .. finished!"
echo "$BANNER"
echo "Installing Cython..."
pip3 install Cython
echo " .. finished!"
echo "$BANNER"
# install wheel
echo "Installing numpy and pytorch downloaded wheel"
pip3 install numpy $TORCH_FILE
echo " .. finished!"
echo "$BANNER"
cd ../

# torchvision stuff
echo "Installing torchvision and dependencies"
sudo apt-get install libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev
echo " .. finished!"
echo "$BANNER"
echo "Cloning torchvision repo"
git clone --branch v$TORCHVISION_VER https://github.com/pytorch/vision torchvision
echo " .. finished!"
echo "$BANNER"

if [ -d "torchvision" ]; then
    echo "Torchvision repo clonned"
    cd torchvision
    export BUILD_VERSION=$TORCHVISION_VER
    echo "Installing torvision $TORCHVISION_VER"
    python3 setup.py install --user
    echo " .. finished!"
    echo "$BANNER"
    cd ../
else
    echo "$BANNER"
    echo "Torchvision repo could not be cloned... ERROR!!"
    exit 1
fi

# torch2trt
echo "Installing torch2trt"
echo "Cloning torch2trt repo"
git clone https://github.com/NVIDIA-AI-IOT/torch2trt
if [ -d "torch2trt" ]; then
    echo "Torch2trt repo clonned"
    cd torch2trt
    echo "Installing torch2trt"
    python setup.py install
    echo " .. finished!"
    echo "$BANNER"
    cd ../
else
    echo "$BANNER"
    echo "Torch2TRT repo could not be clonned... ERROR!!"
    exit 1
fi

# trt-pose
echo "Installing trt-pose and deendencies"
pip3 install tqdm cython pycocotools
sudo apt-get install python3-matplotlib
echo "$BANNER"
echo "Cloning trt-pose repo"
git clone https://github.com/NVIDIA-AI-IOT/trt_pose
if [ -d "trt_pose" ]; then
    cd trt_pose
    echo "Installing trt-pose"
    sudo python3 setup.py install
    echo " .. finished!"
    echo "$BANNER"
    cd ../
else
    echo "$BANNER"
    echo "TRT-pose repo could not be clonned... ERROR!!"
    exit 1
fi

if [ -f "$REQ_FILE" ]; then
    echo "$REQ_FILE file exists."
    echo "Installing other python3 requirements using pip3... "
    cat $REQ_FILE
    echo "$BANNER"
    pip3 install -r $REQ_FILE
    echo " .. finished!"
    echo "$BANNER"
fi

echo "END of SCRIPT - FINISHED!"