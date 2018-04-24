#!/usr/bin/python3

import math
import numpy as np

def gaussian(x, sig):
    return math.exp(-(x**2.) / (sig ** 2.))

def gaussian_points(mu, sig, npoints, nshifts, nbits):
    #The x-position that would equal 1 bit (00..01)
    xx = sig * math.sqrt(-math.log(1./(2**nbits)))

    xpoints = np.linspace(-xx, xx, npoints)

    ypoints = [int(2**nbits * gaussian(x, sig)) for x in xpoints]

    print(ypoints)


gaussian_points(0, 1, 5, 1, 5)
