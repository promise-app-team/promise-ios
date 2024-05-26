#!/bin/sh

# Navigate to the project directory
cd $CI_WORKSPACE

# Debug: Print current directory
echo "Current directory: $(pwd)"

# Check if the project file exists
if ls *.xcodeproj 1> /dev/null 2>&1 || ls *.xcworkspace 1> /dev/null 2>&1; then
  echo "Project file found"
else
  echo "No Xcode project files in this directory"
  exit 1
fi

# Cocoapods
echo "Installing Cocoapods..."
brew install cocoapods
pod install

# OpenAPIGenerator
echo "Setting defaults for OpenAPIGenerator..."
set -euo pipefail
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

# Debug: Check current build number
echo "Current build number:"
xcrun agvtool what-version

# Automatically increase build number
echo "Increasing build number..."
xcrun agvtool next-version -all

# Debug: Check new build number
echo "New build number:"
xcrun agvtool what-version
