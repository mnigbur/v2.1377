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
    toolhead)
      python3 ~/katapult/scripts/flashtool.py -i can0 -u f7ad7cd429e2 -r
      python3 ~/katapult/scripts/flashtool.py -i can0 -u f7ad7cd429e2 -f ~/klipper/out/klipper.bin
      ;;
    mmu)
      python3 ~/katapult/scripts/flashtool.py -i can0 -u 13d7b8824ae8 -r
      python3 ~/katapult/scripts/flashtool.py -i can0 -u 13d7b8824ae8 -f ~/klipper/out/klipper.bin
      ;;
  esac
  echo "Finish update mcu $1"
  echo ""
}

cd ~/klipper
sudo service klipper stop

flash_mcu rpi
flash_mcu spider
flash_mcu toolhead
flash_mcu mmu

sudo service klipper start