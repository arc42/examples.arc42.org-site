---
title: Introduction and Goals
order: 1
---

The Traffic Pursuit Unit, short TPU, is a speed measuring device equipped with
video recording facilities that is installed within a police car. It is used to
measure and record the speed profile of a car driving in front of the police
car, so that speed limit violations can be proved and legal action can be taken
based on the documentation and video recordings produced by the system.

The current development is based on an existing version of the system, that has
been developed by the same companies, and shall take the product to a new
release with added and improved features enabled by the latest developments in
hardware technology.

The following goals have been established for this system:

| Priority | Goal |
|---|---|
| 1 | The system shall be enhanced by features that are suitable to keep and strengthen the position as the current market leader. |
| 2 | The system shall implement HD resolution for video clips and storage of the clips to harddisk. |
| 3 | All system parts that are due to legal approval shall be contained in one unit (called MeasuringUnit), so that replacement of other parts of the system will not require reapproval of the device. |
| 4 | The MeasuringUnit shall be able to run autonomously and be marketed as a low cost variant of TPU without video proof. |
| 5 | The operable temperature range shall be expanded to a range of at least -25 to 85 degrees Celsius. |

## 1.1 Requirements

| Id | Requirement | Explanation |
|---|---|---|
| F1 | Perform automatic calibration | perform an automatic calibration by means of GPS information |
| F1.1 | Print calibration protocol | |
| F2 | Perform a pursuit of a car | follow a car driving at too high speed in order to create a proving documentation |
| F3 | Show list of all recorded pursuits | |
| F4 | Play recording of a pursuit | replay the video documentation of a pursuit case, i.e. to show it to the car driver in charge |
| F5 | Print protocol of a pursuit | |
| F6 | Show basic information | in idle state the system shall display default information like date and time and the current speed |

![Fig. 1: TPU Use Cases](../images/01-use-cases.jpg)

## 1.2 Quality Goals

| Prio | Quality Goal | Description |
|---|---|---|
| 1 | Accuracy | All measurements and calculations shall be correct and precise within the specified deviation range. |
| 2 | Robustness | The system shall work reliable under all specified environment and operating conditions. |
| 3 | Ease of use | Ease of use by the policeman, especially in the use case of pursuing another car. |

## 1.3 Stakeholders

| Role/Name | Contact | Expectations |
|---|---|---|
| Customer | XY Trafficsystems AG, Switzerland | The primary source for all requirements |
| Regulatory Authority | Bureau of Standards, Bern, Switzerland | Checks the correctness of the operations of the device and its adherence to the current laws. Issues the admission of the device and supervises all currently used devices. |
| Contractor, Developer | Reimesch Kommunikationssysteme GmbH, Bergisch Gladbach, Germany | Develops the hard- and software of the system, manufactures and tests the devices to be used in the field. |
| User | police officer | The typical users of the system. |
| Administrator | administrator | User with extended access rights, who configures and calibrates the device. |
| Legal Court | Legal Courts in Switzerland | In case a car driver questions the correct functioning of the device, the court may request some clarification from the Regulatory Authority and from the Developer. |
