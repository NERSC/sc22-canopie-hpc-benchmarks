
from mpi4py import MPI

import sys
import time
import astropy

comm = MPI.COMM_WORLD
comm.Barrier()
now = time.time()

if comm.rank == 0:
    print(astropy.__path__[0], comm.size, now - float(sys.argv[1]))
