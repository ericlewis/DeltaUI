# DeltaUI
SwiftUI + CoreData user interface for DeltaCore & Friends. Styled after Apple Music.

## :warning: Before you go any further
This app is fairly useless without the All.json file, which contains the references to games. At some point, there might be a built in browser and local / iCloud file management. I don't really plan to distribute this, in any way. It is up to you to build it.

**It is also up to you to figure out how / where to get that information, I do not condone piracy- so don't ask.**.

The models are there, so that is how the All.json looks.

## Requirements
- Xcode 11
- iOS 13, iPadOS 13, tvOS 13, macOS Catalina or higher
- git (duh)

## Directions
May not build without All.json, but it is optional in code. If you do make an All.json, you will need to manually hookup the sync method in AppDelegate.

1. recursively install all the submodules
2. open Xcode
3. cmd + r
4. play games!

## Other Stuff
It probably won't build for tvOS, I haven't tried. It won't build for macOS without signifigant changes to DeltaCore. The work there is to switch from using GLKViews to MTKViews because Catalyst doesn't bring over the deprecated GLKit.
