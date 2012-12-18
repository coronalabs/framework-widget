#!/bin/bash

## Set the path to export the unit test to
folderPath=~/Desktop/widget_unit_test/

## Make a new directory to hold the unit test
mkdir -p $folderPath

## Copy all needed widget source files to the folder
for i in *.lua ; do 
	cp $i $folderPath
done

## Copy the unit test files into the folder
cp -a unit_test/. $folderPath