#!/bin/bash
env | grep canCheckin
env | grep canCheckout

echo $canCheckin
echo $canCheckout
echo "Grabbing from repo..."
