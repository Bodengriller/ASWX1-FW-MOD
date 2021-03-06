# ASWX1-FW-MOD  
**Artillery Sidewinder X1 Firmware Mod**  


<img align="right" width="175" src="https://github.com/MarlinFirmware/Marlin/raw/2.0.x/buildroot/share/pixmaps/logo/marlin-250.png" style="max-width:100%;">

<img align="left" width="175" src="https://github.com/pinguinpfleger/ASWX1-FW-MOD/blob/2.0.x/artillery_logo_brand.png?raw=true" style="max-width:100%;">

 
The ASWX1-FW-Mod is an optimization for the Artillery Sidewinder X1 3D printer.  
The Artillery Sidewinder X1 is delivered with [Marlin 1.19](http://www.artillery3d.com/DownLoad/15688.html) and deactivated EEPROM memory function `M500`.  
  
This optimized firmware is based on [Marlin Firmware Version 2.0.x](https://github.com/MarlinFirmware/Marlin/tree/2.0.x)  
and on Marlin [Artillery Sidewinder X1 config](https://github.com/MarlinFirmware/Configurations/tree/master/config/examples/Artillery/Sidewinder%20X1)  

<br>

There is also an [optimized firmware for Artillery Sidewinder X1 touch display](https://github.com/pinguinpfleger/ASWX1-TFTFW-MOD) which you can install too but it is optionally.  

## Releases  

**07.03.2020** [ASWX1-FW-MOD-v1.1](https://github.com/pinguinpfleger/ASWX1-FW-MOD/releases/tag/ASWX1-FW-MOD-v1.1) - [ASWX1-FW-MOD-v1.1.zip](https://github.com/pinguinpfleger/ASWX1-FW-MOD/releases/download/ASWX1-FW-MOD-v1.1/ASWX1-FW-MOD-v1.1.zip)  based on Marlin 2.0.4.4  
- *fixed the possibility to store Babystepping*  
- *[Junction Deviation](https://reprap.org/forum/read.php?1,739819) is set to 0.013. This is a nice value for our Sidewinder X1*  
*To set another value for Junction Deviation, use gcode `M205 J0.013` with your custom JD-value.*  

**29.02.2020** [ASWX1-FW-MOD-v1.0](https://github.com/pinguinpfleger/ASWX1-FW-MOD/releases/tag/ASWX1-FW-MOD-v1.0) - [ASWX1-FW-MOD-v1.0.zip](https://github.com/pinguinpfleger/ASWX1-FW-MOD/releases/download/ASWX1-FW-MOD-v1.0/ASWX1-FW-MOD-v1.0.zip)  based on Marlin 2.0.4.4  
*First Release*


## Improvements  

1. **Save to EEPROM**  
   Enabled EEPROM `M500` to persist settings.  
   Now you can store PIDs and Z-Offsets to EEPROM  

2. **LIN_ADVANCE activated**  
    Linear Advance brings you better dimensional precision due to reduced bleeding edges.  
    Higher printing speeds are possible without any loss of print quality - as long as your extruder can handle the needed speed changes.  
    Visible and tangible print quality is increased even at lower printing speeds.  
    No need for high acceleration and jerk values to get sharp edges.  
   Read https://marlinfw.org/docs/features/lin_advance.html for more details and how to calibrate.  
   By default the K_Factor is set to 0, so it is disabled.  
   To enable it using gcode you should first calibrate your specific K factor.  
   You can do this [here](https://marlinfw.org/tools/lin_advance/k-factor.html). Accordingly set the K factor within your slicer using e.g. `M900 K0.2`  

4. **S_CURVE_ACCELERATION activated**  
   This option eliminates vibration during printing by fitting a Bézier curve to move acceleration, producing much smoother direction changes.  
  
5. **ADAPTIVE_STEP_SMOOTHING activated**  
    Adaptive Step Smoothing increases the resolution of multi-axis moves, particularly at step frequencies below 1kHz (for AVR) or 10kHz (for ARM), where aliasing between axes in multi-axis moves causes audible vibration and surface artifacts.
    The algorithm adapts to provide the best possible step smoothing at the lowest stepping frequencies.  



## Individual adjustments  
Individual adjustments can be made in [Configuration.h](/Marlin/Configuration.h) and [Configuration_adv.h](/Marlin/Configuration_adv.h)  
[Read more about configuring Marlin](https://marlinfw.org/docs/configuration/configuration.html)  
Of course the firmware must be recompiled than.  
There are serveral ways to compile.  
\[Linux / Mac\]  
An easy one do compile is [platformio CLI](https://docs.platformio.org/en/latest/installation.html#installation-methods) command.  
To complile you just need execute `platformio run` in the root folder of this repository (where platformio.ini is also located).  
The new compiled firmware is saved here: .pio/build/megaatmega2560/firmware.hex  

\[Windows\]  
There is a great instruction how to [use Arduino-IDE on Marlin.org](https://marlinfw.org/docs/basics/install_arduino.html).
This should be the easiest way on Windows.

Bord: "Arduino/Genuino Mega or Mega 2560"
Processor: "ATmega2560 (Mega 2560)"

Customize your configs, use "Sketchs -> Export compiled Binary", flash

  
## Flashing  
**Important**: Don't forget to read and backup your current EEPROM-settings with `M503`!

The display and the USB-Port are sharing the same wires so flashing the motherboard-firmware need some extra work.  
There are two ways possible to flash the firmware.    
  
### 1. Disconnect the display  
You have to open the printer and unplug the display.  
  
### 2. Loop method  
With this method we try to talk to the motherboard before the display is ready to listen.  
The [flash.sh](/flash.sh) script is trying to flash the command in a loop until the command finishs succesfully.  
Steps:  
- Make sure Artillery Sidewinder X1 is unplugged from the power supply.  
- Unplug USB Cable too.  
- Connect your linux box (or mac) with the printer USB-Port  
- Place firmware.hex and flash.sh in same directory and execute flash.sh.  
- You will see timeout errors thats normal.  
- Plug USB Cable  
- Leave flash.sh running and unplug / plug USB Cable or hit the reset button until the flash.sh finishs. This could take several trys, no panic.

**Tipps:**
- Don't forget to make the flash-file executeable: `chmod +x ./flash.sh`
- You can use a commandline-argument with this flash-file to set a custom file-path  
(e.g. `sh ./flash.sh ./FILENAME_OF_FW_V123.hex`)
  
  
### Reset to factory defaults  
I recommend to reset the newly flashed firmware to its defaults and overwrite any older settings.  
***Don't forget to read your settings by `M503` and copy/save them somewhere.***  
The gcode command to reset the firmware to the hardcoded defaults is `M502`,  
followed by `M500` to save these default setting to EEPROM.  
After that you can restore your settings from your M503-Backup e.g. `M92 X80.12 Y80.12 Z399.78 E420.00`  
Save again by `M500` and finally reload all stored data from Eeprom by `M501`  

You can execute the gcode commands using a terminal program like Arduino-IDE, [Pronterface](https://www.pronterface.com/)) or using the Terminal Tab in Octoprint.  

  
<br><br><hr>  

## Credits  
The repository here is the continuation of the MarlinFW from [**Robscar's firmware mod** at Thingiverse](https://www.thingiverse.com/thing:3856144).  
The modified firmware for the Makerbase MKS-TFT 3.2 touch display has been seperated to an own repository:  
https://github.com/pinguinpfleger/ASWX1-TFTFW-MOD
  

## Links

### Slicer Machine & Profile Settings
https://3d-nexus.com/resources/file-archives/category/8-artillery-evnovo

### Youtube
RICS 3D Marlin 2 https://www.youtube.com/watch?v=JlgykMHhMzw  
Waggster Mod (Marlin 2.0.2 BL-Touch) https://pretendprusa.co.uk/index.php?action=downloads;sa=view;down=16  


