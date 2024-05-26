#!/bin/sh

# Navigate repository path
cd $CI_PRIMARY_REPOSITORY_PATH

# Automatically increase build number
echo "Increasing build number..."
NEW_BUILD_NUMBER=$(($CI_BUILD_NUMBER + 1))
xcrun agvtool new-version -all $NEW_BUILD_NUMBER

# Cocoapods
echo "Installing Cocoapods..."
brew install cocoapods
pod install

# OpenAPIGenerator
echo "Setting defaults for OpenAPIGenerator..."
set -euo pipefail
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES



