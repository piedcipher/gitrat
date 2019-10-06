# Gitrat :rat:
Gitrat (**Git**hub-T**ra**i**t**ors) is a CLI utility to track GitHub (un)followers.

## Prerequisite
- [Dart](https://www.dartlang.org/)

## Setup
1. Cloning Repository
```
$ git clone https://github.com/piedcipher/gitrat
```

2. Getting Dependencies
```
$ cd gitrat/ && pub get
```

3. Running App
```
$ dart2aot bin/main.dart bin/release.dart
$ dartaotruntime bin/release.dart <username>
```

## Todo
- [ ] Tracking follower-change with git
- [ ] Comparing stats by date
- [ ] Custom options - CLI flags
    - [x] Username
    - [ ] History
    - [ ] Tweet rats
    - [ ] Help
     
## Credits 
Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).
