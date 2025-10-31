#!/bin/bash 
PATH_PROJECT=$(pwd)

# build apk
flutter clean
flutter pub get
flutter build apk --release
flutter build appbundle --target-platform android-arm,android-arm64,android-x64

# move file app-release.apk to root folder
cp "$PATH_PROJECT/build/app/outputs/apk/release/app-release.apk" "$PATH_PROJECT/$(date '+%Y-%m-%d %H:%M:%S').apk"
# move file app-release.aab to root folder
cp "$PATH_PROJECT/build/app/outputs/bundle/release/app-release.aab" "$PATH_PROJECT/$(date '+%Y-%m-%d %H:%M:%S').aab"