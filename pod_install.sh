#!/bin/bash

pod install
status=$?

if test $status -eq 0
then
echo "Pod installed"
else
pod repo update
pod install
fi
