#!/usr/bin/env bash

# INSTALL GECKO DRIVER

# on error:
# The geckodriver executable could not be found on the current PATH.

# stack:
# https://askubuntu.com/questions/870530/how-to-install-geckodriver-in-ubuntu

# versions:
# https://github.com/mozilla/geckodriver/releases

VERSION=v0.19.1

wget https://github.com/mozilla/geckodriver/releases/download/${VERSION}/geckodriver-${VERSION}-linux64.tar.gz
sudo sh -c 'tar -x geckodriver -zf geckodriver-'${VERSION}'-linux64.tar.gz -O > /usr/bin/geckodriver'
sudo chmod +x /usr/bin/geckodriver
rm geckodriver-${VERSION}-linux64.tar.gz