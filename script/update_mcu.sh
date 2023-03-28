#!/bin/bash

CONFIG_PATH=~/klipper_config/script

function flash_mcu() {
  echo "Start update mcu $1"
  echo ""
  make clean
  #make menuconfig KCONFIG_CONFIG=$CONFIG_PATH/klipper_config.$1
  make KCONFIG_CONFIG=$CONFIG_PATH/klipper_config.$1
  read -p "mcu $1 firmware built. Press [Enter] to flash"
  case $1 in
    rpi)
      make flash KCONFIG_CONFIG=$CONFIG_PATH/klipper_config.$1
      ;;
    spider)
      ./scripts/flash-sdcard.sh /dev/ttyAMA0 fysetc-spider-v1
      ;;
    ercf)
      echo "Aborting! Please verify serial device!"
      #sudo /usr/local/bin/bossac -i -d -p /dev/ttyACM1 -e -w -v -R --offset=0x2000 out/klipper.bin
    ;;
  esac
  echo "Finish update mcu $1"
  echo ""
}

cd ~/klipper
sudo service klipper stop

flash_mcu rpi
flash_mcu spider
flash_mcu ercf

sudo service klipper start