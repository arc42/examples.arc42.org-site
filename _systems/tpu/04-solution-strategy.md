---
title: Solution Strategy
order: 4
---

## Hardware

In order to achieve that the TPU contains an independently exchangeable
measuring unit, which can also be used stand-alone, an embedded solution based
on the existing version of the TPU was designed. This device has its own housing
that securely encapsulates the components relevant to measurement and
calibration and all the connections necessary for operation (keyboard, GPS,
printer, power supply line), and an additional connector strip that leads out
all the connections necessary for communication with the main device. This
component can be inserted into the main unit.

The main unit consists of a PC/104 format base unit and additional PC/104
expansion cards that are stacked on top of the base unit. These include a video
codec that communicates with the PC via the PCI bus, and a board for video
conversion and manipulation (overlays, picture-in-picture, …) that is equipped
with two video inserter devices, referred to as legal inserter and user
inserter. The LegalInserter converts the incoming picture format to the input
format of the codec and handles inserts that are part of the stored video. The
UserInserter processes the video image behind the codec, handles the conversion
to the format of the monitor in use, and enables overlays that are only visible
on the screen, both when recording and playing back a video.

A small add-on board monitors the ignition and triggers the controlled shutdown
of the system as soon as the ignition is turned off.

## Software

The measurement box runs the adapted software of the previous TPU version based
on an embedded real-time operating system. On the main device a Linux system
hosts the TPU main process, which performs the graphical user interface and the
creation, storage and administration of the video files. Both the main process
and the software of the measurement box are realized via a framework (developed
by Reimesch Kommunikationssysteme and used in many products). The control
software for the video codec is also executed in the main process.
