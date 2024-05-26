#!/bin/sh

# Navigate to the workspace directory
cd $CI_PRIMARY_REPOSITORY_PATH

# Debug: Print current directory
echo "Current directory: $(pwd)"

# Check if the project file exists and navigate to it
if [ -d "$CI_PROJECT_FILE_PATH" ]; then
  echo "Project file found: $CI_PROJECT_FILE_PATH"
  cd "$CI_PROJECT_FILE_PATH"
else
  echo "No Xcode project files in this directory"
  exit 1
fi

# Debug: Print current directory again
echo "Now in project directory: $(pwd)"

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
