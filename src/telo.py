#!/usr/bin/env python

import os
import sys
import numpy as np
import random

path = '/OSM/CBR/NRCA_FINCHGENOM/data/2014-12-10_redBrowed/2016-05-10'
out_dir = '/OSM/CBR/NRCA_FINCHGENOM/analysis/2016-09-21_telomere/subsamples'

file = 'C9FA9ANXX_L3_Other_TAGGCCG_R'   # sys.argv[1]

c = 0
with open(file + '_R1.fastq', 'r') as f1:
    while f1.readline():
        c += 1

numrecords = c/4

numsamplesets = 20
samplesetsize_a = [int(i) for i in np.geomspace(start = 10, stop = 18000000, num = numsamplesets, endpoint = True)]

recnum_a = []
samplesetnum_a = []
outf1 = []
outf2 = []

for samplesetnum, samplesetsize in enumerate(samplesetsize_a):
    s = set(np.random.randint(0, numrecords - 1, samplesetsize))
    while len(s) < samplesetsize:
        s.add(random.randint(0, numrecords - 1))
    recnum_a += s
    samplesetnum_a += [samplesetnum] * len(s)
    del(s)
    outf1.append(open(os.path.join(out_dir, file + '_R1.subset.' + str(samplesetsize) + '.fastq'), 'w'))
    outf2.append(open(os.path.join(out_dir, file + '_R2.subset.' + str(samplesetsize) + '.fastq'), 'w'))


idx = np.argsort(recnum_a)

with open(file + '_R1.fastq', 'r') as f1, open(file + '_R2.fastq', 'r') as f2:
    recnum_i = 0
    rec_i = 0
    line = f1.readline()
    while line:
        r1 = line + f1.readline() + f1.readline() + f1.readline()
        r2 = f2.readline() + f2.readline() + f2.readline() + f2.readline()
        while rec_i == recnum_a[idx[recnum_i]]:
            n = samplesetnum_a[idx[recnum_i]]
            outf1[n].write(r1)
            outf2[n].write(r2)
            recnum_i += 1
            if recnum_i == len(recnum_a): recnum_i = 0
        else: pass
        rec_i += 1
        line = f1.readline()

