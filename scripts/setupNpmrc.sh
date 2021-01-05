#!/bin/sh
sed -i -e 's/YOUR TOKEN HERE/\$\{IMAGECAPTURE_SDK_NPM_AUTH_TOKEN\}/g' ../.npmrc
