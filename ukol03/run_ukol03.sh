#!/bin/bash
find ./2016-1-cflp-mathprog -iname '*.dat' -exec timeout 15 glpsol -m ukol03.mod -d "{}" -y "{}.txt" \;
rename 's/dat.txt$/txt/' 2016-1-cflp-mathprog/*.dat.txt
