#!/bin/bash

# Use this script to keep Python packages updated.
# 
# Care tho', this has no notion of stability!
# 
# You might break more than you expect.
# 
# Arguments: pip3_upgrade.sh
#

# Install random dependancies (debian)
# Audit this list often, as it will change between releases
sudo apt install -y libcairo2-dev libgirepository1.0-dev libcups2-dev virtualenv

# Switch to a new environment:
TMPDIR="$(mktemp --directory)"

# Set-up virtualenv in the temporary directory
virtualenv "${TMPDIR}"

# Source in
. "${TMPDIR}/bin/activate"

# Install Python Packages that may be missing from test suites
pip3 install testresources

# Run the full upgrade
pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
