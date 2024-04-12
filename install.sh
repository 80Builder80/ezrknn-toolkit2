#!/bin/bash

# Made by Pelochus
# Check for more info: https://github.com/Pelochus/ezrknn-toolkit2/

message_print() {
  echo
  echo "#########################################"
  echo $1
  echo "#########################################"
  echo
}

message_print "Checking root permission..."

if [ "$EUID" -ne 0 ]; then 
  echo "Please run this script as root!"
  exit
fi

message_print "Installing apt dependencies..."

sudo apt update
sudo apt install -y git git-lfs python-is-python3 python3-pip libxslt1-dev zlib1g-dev libglib2.0-dev libsm6 libgl1-mesa-glx libprotobuf-dev build-essential
# sudo apt install -y adb # For running the NPU in Android

message_print "Changing to repository..."

# git clone https://github.com/Pelochus/ezrknn-toolkit2.git
cd ezrknn-toolkit2/

message_print "Installing pip dependencies for ARM64..."

pip install ./rknn-toolkit-lite2/packages/rknn_toolkit_lite2-2.0.0b0-cp311-cp311-linux_aarch64.whl
pip install -r ./rknn-toolkit2/packages/requirements_cp311-2.0.0b0.txt

message_print "Installing RKNN NPU API..."

cp ./rknpu2/runtime/Linux/librknn_api/aarch64/librknnrt.so /usr/lib/
# TODO: Check if it should be copied to /usr/include instead
cp ./rknpu2/runtime/Linux/librknn_api/include/* /usr/local/include

message_print "Compiling RKNN Benchmark for RK3588..."

cd ./rknpu2/examples/rknn_benchmark/
bash build-linux.sh -a aarch64 -b Release -t rk3588
# TODO: cp benchmark to /usr/bin/rknn-benchmark

message_print "Done!"
