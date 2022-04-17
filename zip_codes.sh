#!/bin/bash

rm -rf codes.zip
rm -rf code_files/

mkdir code_files
find ./Objc-Trip/ -name "*.[m]" | while read line; do
    cp -rf $line ./code_files
done
zip codes.zip ./code_files/*

rm -rf code_files/