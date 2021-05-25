# Summary

Driver app is builded on Xcode 12, use swift 5

# Pre-Requirement
  - Before you bootstrap, it's you responsibility to install bellow command line tools via `Terminal`
    - [brew](https://brew.sh/)
    - [fastlane](https://docs.fastlane.tools)
    - [cocoapods](https://cocoapods.org/)
    - [swiftlint](https://github.com/realm/SwiftLint)
    - [swiftgen](https://github.com/SwiftGen/SwiftGen)
    - [SwiftFormat](https://github.com/nicklockwood/SwiftFormat)

# Retrive Dependency
After all tools installed, you should do the following steps to fetch dependencies

    cd path/to/SRCROOT
    pod install

After pod install excuted successfully you can now open the Xcode to run the project
# Beta

Driver is used `fastlane` to upload the bate version ipa automatically to TestFlight

You can run `fastlane beta` command via terminal, it will buld and upload you app automatically to TestFlight

refrence [fastlane](#fastlane) for details

# Release

# fastlane
  - **Changelog.txt:**

    file content will be upload to TestFlight as release note
  - **TestFlight Password**: `hnal-aacj-rwpc-nifj`

    which is used when upload ipa to TestFlight
