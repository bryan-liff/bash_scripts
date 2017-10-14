#!/bin/bash

# This is better put in an alias, but placing here until
# I centralize an alias list

for file in `ls *.log`; do echo > $file; done
