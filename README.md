This repository contains scripts for building a Debian package for the `piqi`
command-line tool.


Build prerequisites
------------------

Install the following packages:

    # necessary for Debian packaging
    apt-get install build-essential debhelper fakeroot

    # required for the build itself
    apt-get install ocaml camlp4-extra ocaml-findlib

    # for building documentation and running tests
    apt-get install pandoc libprotoc-dev protobuf-compiler


Building the package
--------------------

    make


Updating the packaging scripts after a new Piqi version is released
-------------------------------------------------------------------

1. Set the `VERSION` variable in `./Makefile` to the new upstream version.
2. Edit `debian/changelog`

