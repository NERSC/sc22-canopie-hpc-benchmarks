#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Aug 21 15:40:46 2022

@author: stephey
"""

#make nice plots for exaalt podman benchmarks

import numpy as np
import pandas as pd

from datetime import time

from matplotlib import pyplot as plt
import seaborn as sns
sns.set_style("ticks")
sns.set_context("poster")

frameworks=np.array([
'Bare-metal-first',
'Shifter-first',
'Podman-exec-first',
'Bare-metal-first',
'Shifter-first',
'Podman-exec-first',
'Bare-metal-first',
'Shifter-first',
'Podman-exec-first',
'Bare-metal-second',
'Shifter-second',
'Podman-exec-second',
'Bare-metal-second',
'Shifter-second',
'Podman-exec-second',
'Bare-metal-second',
'Shifter-second',
'Podman-exec-second',
'Podman-exec-second'
])

nodes=np.array([
32,
32,
32,
64,
64,
64,
256,
256,
256,
32,
32,
32,
64,
64,
64,
256,
256,
256,
128
],dtype=int)

data32=np.array([
15.01729226,
25.99034262,
11.83597374,
18.77645373,
26.40729499,
12.04849052,
8.276290655,
28.38149762,
15.49201488,
5.486288786,
20.91938949,
8.820841789,
5.466057539,
21.10402846,
12.89223194,
6.453428507,
21.86184382,
12.30131626,
0
])

data64=np.array([
20.05861163,
26.77741671,
13.0673461,
10.8514235,
26.78991938,
13.68335104,
10.58056927,
31.42047405,
37.56293893,
7.926063538,
21.9280467,
13.74300146,
9.58326602,
24.40215468,
15.29942012,
10.95895076,
26.20004034,
33.88095713,
0    
])

data128=np.array([
22.13779902,
37.42896843,
19.94956064,
16.00859809,
38.00371647,
22.64584756,
18.36623812,
41.58839941,
219.6099932,
13.26787806,
21.24170852,
21.7839067,
14.94871497,
22.35842395,
23.48587561,
16.32407427,
33.19488311,
122.6663005,
0
])

dict32 = dict()
dict32['Nodes']=nodes
dict32['Framework']=frameworks
dict32['Runtime (s)']=data32
dict32['MPI tasks per node']=32*np.ones(19).astype(int)
df32 = pd.DataFrame(dict32)

dict64 = dict()
dict64['Nodes']=nodes
dict64['Framework']=frameworks
dict64['Runtime (s)']=data64
dict64['MPI tasks per node']=64*np.ones(19).astype(int)
df64 = pd.DataFrame(dict64)

dict128 = dict()
dict128['Nodes']=nodes
dict128['Framework']=frameworks
dict128['Runtime (s)']=data128
dict128['MPI tasks per node']=128*np.ones(19).astype(int)
df128 = pd.DataFrame(dict128)

plotdf=pd.concat([df32,df64,df128])
hue_order=["Bare-metal-first","Bare-metal-second","Shifter-first","Shifter-second","Podman-exec-first","Podman-exec-second"]
#a dictionary mapping hue levels to matplotlib colors
palette=dict()
palette['Bare-metal-first']='darkred'
palette['Bare-metal-second']='red'
palette['Shifter-first']='darkblue'
palette['Shifter-second']='blue'
palette['Podman-exec-first']='darkgreen'
palette['Podman-exec-second']='seagreen'
g=sns.catplot(data=plotdf,
                row="MPI tasks per node",
                aspect=2.2,
                x="Nodes", 
                y="Runtime (s)", 
                hue="Framework",
                hue_order=hue_order,
                palette=palette,
                kind="bar",
                sharey=False,
                sharex=False,
#                margin_titles=True)
)

#label nodes on every xaxis
ax = g.axes
ax[0,0].set_xlabel("Nodes")
ax[1,0].set_xlabel("Nodes")
ax[2,0].set_xlabel("Nodes")

# Finalize the plot
g.fig.subplots_adjust(top=0.90)
plt.subplots_adjust(hspace=0.5)
g.fig.suptitle('AstroPy+mpi4py')
plt.savefig("astropyle.png", dpi=300)
