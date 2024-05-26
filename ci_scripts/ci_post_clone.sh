#!/bin/sh

# Debug: Check current build number
echo "Current build number: $CI_BUILD_NUMBER"
xcrun agvtool what-version

# Cocoapods
echo "Installing Cocoapods..."
brew install cocoapods
pod install

# OpenAPIGenerator
echo "Setting defaults for OpenAPIGenerator..."
set -euo pipefail
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES



## Automatically increase build number
#echo "Increasing build number..."
#xcrun agvtool next-version -all
#
## Debug: Check new build number
#echo "New build number:"
#xcrun agvtool what-version
