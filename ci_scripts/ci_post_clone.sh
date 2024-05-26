#!/bin/sh

#  ci_post_clone.sh
#  Promise
#
#  Created by kwh on 5/26/24.
#  

#!/usr/bin/env bash

# Cocoapods
brew install cocoapods
pod install

# OpenAPIGenerator
set -euo pipefail
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

# Automatically increase build number (Special new build number setting: xcrun agvtool new-version -all 1)
xcrun agvtool next-version -all
