Testing and building
================================

# Tests

Requirements:

* bash >=v4.4
* shunit2. The path is currently hard-coded to `/usr/bin/shunit2`

Just run `./test/*` from the project root

# Build

Requirements:

* bash >=v4.4
* fpm
* pandoc
* shunit2

Just run `./build.sh n.n.n` from the project root.

The test script(s) will try to source `shunit2` from `$SHUNIT2_PATH`, $PATH, and finally `/usr/share/shunit2/shunit2` in that order, and relies entirely on `shunit` to run.

It will try to detect whether it can build `rpm` or `deb` on a given system but the script can also be called with an argument for an fpm target as follows:

```
./build.sh <semver> <target>
```
