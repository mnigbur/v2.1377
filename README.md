# Voron 2.4 (300mm³)

- [Voron 2.4 (300mm³)](#voron-24-300mm)
- [Installed Upgrades](#upgrades)
- [Filament Management](#filament-management)
- [Update Klipper](#update-klipper)
  - [Automatic update script](#automatic-update-script)
  - [Manual settings](#manual-settings)
    - [RPi](#rpi)
    - [Spider](#spider)
    - [BTT MMU (CAN)](#btt-mmu-can)
    - [BTT EBB SB2240 (CAN)](#btt-ebb-sb2240-can)

<br/><br/>

# Installed Upgrades
- [Nevermore Micro V5 Duo (dual fan)](https://github.com/nevermore3d/Nevermore_Micro)
- Bearing stacks instead of toothed idlers
- Single MGN12
- <del>Klicky</del>
- [ERCF](https://github.com/Enraged-Rabbit-Community/ERCF_v2)
- [Extrusion Backers (only on Y)](https://mods.vorondesign.com/details/ewDI1Cntz7urtuq3Cm9wGQ)
- [Voron Tap](https://github.com/VoronDesign/Voron-Tap)
- [Beefy Front Idlers](https://github.com/clee/VoronBFI)
- [GE5C Slim](https://mods.vorondesign.com/details/eB5T2RNQcYI4o6cilhpXEg)

<br/><br/>


# Filament Management

### Print labels for spool and filament test card
```bash
 $ labelle --qr "web+spoolman:s-XXX" "SUNLU" "ABS" "Black"
```

### Map gates in MMU to spool
```
MMU_GATE_MAP GATE=2 MATERIAL=ABS+ COLOR=FFFF00 SPOOLID=2
```

<br/><br/>


# Update Klipper

## Automatic update script

```bash
$ ~/klipper_config/script/update_mcu.sh
```

<br/>

## Manual settings

```bash
$ cd ~/klipper
$ make menuconfig
```

### RPi
```
[*] Enable extra low-level configuration options
    Micro-controller Architecture (Linux process)  --->
()  GPIO pins to set at micro-controller startup
```

```bash
$ make clean && make
$ sudo service klipper stop
$ make flash
$ sudo service klipper start
```

### Fysetc Spider

https://github.com/FYSETC/FYSETC-SPIDER

```
[*] Enable extra low-level configuration options
    Micro-controller Architecture (STMicroelectronics STM32)  --->
    Processor model (STM32F446)  --->
    Bootloader offset (64KiB bootloader)  --->
    Clock Reference (12 MHz crystal)  --->
    Communication interface (Serial (on USART1 PA10/PA9))  --->
(250000) Baud rate for serial port
()  GPIO pins to set at micro-controller startup
```

```bash
$ make clean && make
$ sudo service klipper stop
$ ./scripts/flash-sdcard.sh /dev/ttyAMA0 fysetc-spider-v1
$ sudo service klipper start
```

### BTT MMB (CAN)

https://github.com/bigtreetech/MMB

#### Katapult
```
    Micro-controller Architecture (STMicroelectronics STM32) --->
    Processor model (STM32G0B1) --->
    Build CanBoot deployment application (Do not build) --->
    Clock Reference (8 MHz crystal)  --->
    Communication interface (CAN bus (on PB0/PB1)) --->
    Application start offset (8KiB offset)  --->
(1000000) CAN bus speed
()  GPIO pins to set at micro-controller startup
[*] Support bootloader entry on rapid double click of reset button
[ ] Enable bootloader entry on button (or gpio) state
[ ] Enable Status LED
```

#### Klipper
```
[*] Enable extra low-level configuration optionsMicro-controller
    Micro-controller Architecture (STMicroelectronics STM32) --->
    Processor model (STM32G0B1) --->
    Bootloader offset (8KiB bootloader) --->
    Clock Reference (8 MHz crystal)  --->
    Communication interface (CAN bus (on PB0/PB1)) --->
(1000000) CAN bus speed
()  GPIO pins to set at micro-controller startup
```

```bash
$ python3 ~/katapult/scripts/flashtool.py -i can0 -u 13d7b8824ae8 -f ~/klipper/out/klipper.bin
```

### BTT EBB SB2240 (CAN)

https://github.com/bigtreetech/EBB/tree/master/EBB%20SB2240_2209%20CAN

#### Katapult
```
    Micro-controller Architecture (STMicroelectronics STM32) --->
    Processor model (STM32G0B1) --->
    Build CanBoot deployment application (8KiB bootloader) --->
    Clock Reference (8 MHz crystal)  --->
    Communication interface (CAN bus (on PB0/PB1)) --->
    Application start offset (8KiB offset)  --->
(1000000) CAN bus speed
()  GPIO pins to set at micro-controller startup
[*] Support bootloader entry on rapid double click of reset button
[ ] Enable bootloader entry on button (or gpio) state
[*] Enable Status LED
(PA13)  Status LED GPIO Pin
```

#### Klipper
```
[*] Enable extra low-level configuration optionsMicro-controller
    Micro-controller Architecture (STMicroelectronics STM32) --->
    Processor model (STM32G0B1) --->
    Bootloader offset (8KiB bootloader) --->
    Clock Reference (8 MHz crystal)  --->
    Communication interface (CAN bus (on PB0/PB1)) --->
(1000000) CAN bus speed
()  GPIO pins to set at micro-controller startup
```

```bash
python3 ~/katapult/scripts/flashtool.py -i can0 -u f7ad7cd429e2 -f ~/klipper/out/klipper.bin
```