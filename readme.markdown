# Building a unit test for on device testing.

To automatically generate a folder with all the required files and assets needed in order for you to test on device, all you need to do is follow these simple steps:

1) Open a Terminal window

2) cd to the widget source code directory. i.e.: cd projects/widget

3) Run the following terminal command: 

./makeUnitTest.sh


This will generate a folder named "widget_unit_test" and populate it with all needed widget code files and assets. This folder will be created on your desktop.

From there you simply need to: 

1) Navigate to the "widget_unit_test" folder we previously generated. 

2) Open main.lua and change line 12 to true so it reads:

	local onDeviceTest = true
	
3) Proceed to build for your device.


# Notes

This script hasn't been tested on Windows so, if it blows up your machine, don't blame me ;)
