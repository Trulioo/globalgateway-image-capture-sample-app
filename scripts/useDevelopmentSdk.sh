#!/bin/sh
sed -i -e 's/globalgateway-image-capture-sdk/globalgateway-image-capture-sdk-dev/g' ../package.json
sed -i -e 's/globalgateway-image-capture-sdk/globalgateway-image-capture-sdk-dev/g' ../setup.sh
sed -i -e 's/globalgateway-image-capture-sdk/globalgateway-image-capture-sdk-dev/g' ../src/App.js
if [[ ! -z "$SDK_VERSION" ]]
then
    sed -i -e "s/sdk-dev\": \"(\^*[0-9]*\.*)+\"\,/sdk-dev\": \"$SDK_VERSION\"\,/" ../package.json
    sed -i -e "s/latest/$SDK_VERSION/g" ../package.json
fi