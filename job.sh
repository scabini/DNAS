#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -V
matlab -r 'test' > test.txt
