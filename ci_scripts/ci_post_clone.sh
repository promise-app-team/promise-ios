#!/bin/sh

#  ci_post_clone.sh
#  Promise
#
#  Created by kwh on 5/26/24.
#  

#!/usr/bin/env bash
set -euo pipefail

defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

