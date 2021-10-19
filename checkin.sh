#!/bin/bash
env | grep canCheckin
env | grep canCheckout

echo $canCheckin
echo $canCheckout
echo "Checked into repo"