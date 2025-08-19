#!/bin/bash
set -o errexit -o pipefail

sed -i.bak 's|v0.904.0|0.904.0|' lib/YAML/*.pm
rm -rf lib/YAML/*.bak
sed -i.bak 's|v0.904.0|0.904.0|' META.*
sed -i.bak 's|v0.904.0|0.904.0|' Makefile.PL
rm -rf *.bak

export LC_ALL="en_US.UTF-8"

if [[ -f Build.PL ]]; then
    perl Build.PL
    perl ./Build
    perl ./Build test
    perl ./Build install --installdirs vendor
elif [[ -f Makefile.PL ]]; then
    perl Makefile.PL INSTALLDIRS=vendor NO_PACKLIST=1 NO_PERLLOCAL=1
    make
    make test -j"${CPU_COUNT}"
    make install
else
    echo 'Unable to find Build.PL or Makefile.PL. You need to modify build.sh.'
    exit 1
fi
