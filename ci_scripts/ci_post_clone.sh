#!/bin/sh

# Cocoapods
echo "Installing Cocoapods..."
brew install cocoapods
pod cache clean --all
pod install

# OpenAPIGenerator
echo "Setting defaults for OpenAPIGenerator..."
set -euo pipefail
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
