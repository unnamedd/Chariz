# ![Chariz](https://i.imgur.com/9RHFBv4.png) [![Build Status](https://travis-ci.org/CharizTeam/Chariz.svg)](https://travis-ci.org/CharizTeam/Chariz)
A package management app for OS X.

License: [GNU GPL v2](https://www.gnu.org/licenses/gpl-2.0.html)

## Building
First, **you need an Apple Developer account**. Unfortunately OS X requires helper binaries to have a code signature or they won’t be installed, and Chariz isn’t going to be too useful if the helper isn’t running. You also should be using the latest public Xcode version.

Other than that, you simply need to clone the repo and all the submodules, and then build from the `.xcworkspace`:

```
$ git clone --recursive https://github.com/CharizTeam/Chariz.git
$ cd Chariz
$ open Chariz.xcworkspace
```

Note that the `.xcodeproj` is the Chariz app itself, while `.xcworkspace` contains other projects such as cpm. Chariz will not compile from the standalone `.xcodeproj`.
