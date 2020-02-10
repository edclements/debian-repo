
## Using

Add the following line to /etc/apt/sources.list

deb [trusted=yes] http://debian.hedaleth.net.s3-website.eu-west-2.amazonaws.com buster main

## Building

Install dependencies

    sudo apt install devscripts build-essential lintian shunit2 debhelper \
    libx11-dev libxinerama-dev libxft-dev libfreetype6-dev awscli equivs

Run make

    make

