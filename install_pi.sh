#!/bin/bash

##
# Script for Android Auto (OpenAuto) install on RPi
##

## Note that on an RPi 2, and other units with little available memory,
## you will need to significantly increase the size of your swap file.

# Installing dependeces
sudo apt update
sudo apt install -y libboost-all-dev libusb-1.0.0-dev libssl-dev cmake libprotobuf-dev protobuf-c-compiler protobuf-compiler libqt5multimedia5 libqt5multimedia5-plugins libqt5multimediawidgets5 qtmultimedia5-dev libqt5bluetooth5 libqt5bluetooth5-bin qtconnectivity5-dev pulseaudio librtaudio-dev

cd

# Cloning and building Android Auto SDK
git clone -b development https://github.com/cohaolain/aasdk.git

mkdir aasdk_build
cd aasdk_build
cmake -DCMAKE_BUILD_TYPE=Release ../aasdk
make -j4

# Building ilclient firmware
cd /opt/vc/src/hello_pi/libs/ilclient
make -j4

cd

# Cloning and building OpenAuto
git clone -b development https://github.com/cohaolain/openauto.git

mkdir openauto_build
cd openauto_build
cmake -DCMAKE_BUILD_TYPE=Release \
    -DRPI3_BUILD=TRUE -DAASDK_INCLUDE_DIRS="/home/pi/aasdk/include" \
    -DAASDK_LIBRARIES="/home/pi/aasdk/lib/libaasdk.so" \
    -DAASDK_PROTO_INCLUDE_DIRS="/home/pi/aasdk_build" \
    -DAASDK_PROTO_LIBRARIES="/home/pi/aasdk/lib/libaasdk_proto.so" \
    ../openauto
make -j4

# Enabling OpenAuto autostart
echo "sudo /home/pi/openauto/bin/autoapp" >>/home/pi/.config/lxsession/LXDE-pi/autostart

# Starting OpenAuto
whiptail --title "OpenAuto RPi" --msgbox "Strating OpenAuto" 8 78
/home/pi/openauto/bin/autoapp
