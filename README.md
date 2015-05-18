# ![Chariz](https://i.imgur.com/BWTtsMO.png)
A package manager for OS X.

## Building
Building Chariz requires [CocoaPods](https://cocoapods.org/). Install it with `sudo gem install cocoapods` before following the instructions below.

```bash
$ git clone --recursive https://github.com/CharizTeam/Chariz
$ cd Chariz
$ pod install
$ xcodebuild -project cpm/cpm/external/fmdb/fmdb.xcodeproj -alltargets -configuration Debug
$ xcodebuild -project cpm/cpm.xcodeproj -alltargets -configuration Debug
$ ln -s $PWD/cpm/build/Debug/libcpm.dylib /usr/local/lib/
```
Then open the `Chariz.xcworkspace` (xcworkspace, not xcodeproj) file and the project will build and run.



License: [GNU GPL v2](https://www.gnu.org/licenses/gpl-2.0.html)
