<h1 align="center"><img src="https://chariz.io/img/favicon.png" alt="Chariz" width="128" height="128"></h1>
<p align="center"><strong>A package management app for macOS.</strong></p>

[![Build Status](https://travis-ci.org/CharizTeam/Chariz.svg)](https://travis-ci.org/CharizTeam/Chariz) [![GitHub release](https://img.shields.io/github/release/CharizTeam/Chariz.svg)](https://github.com/CharizTeam/Chariz/releases)

## Building
First, **you need an Apple Developer account**. Unfortunately macOS requires helper binaries to have a code signature or they won’t be installed, and Chariz isn’t going to be too useful if the helper isn’t running. You also should be using the latest public Xcode version.

1. Install Carthage (e.g. from Homebrew): `brew install carthage`
2. Clone the repo: `git clone --recursive https://github.com/CharizTeam/Chariz.git`
3. Enter the directory: `cd Chariz`
4. Initialise Carthage dependencies: `./init.sh`
5. Open the Xcode workspace: `open Chariz.xcworkspace`

Note that the `.xcodeproj` is the Chariz app itself, while `.xcworkspace` contains other projects such as cpm. Chariz will not compile from the standalone `.xcodeproj`.

## License
Licensed under the GNU General Public License, version 2.0. Refer to [LICENSE.md](LICENSE.md).
