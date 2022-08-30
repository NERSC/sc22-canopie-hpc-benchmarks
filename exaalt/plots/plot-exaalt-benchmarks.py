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
sns.set_context("talk")

neach = 4

nodelist = []
for n in [32,64,128,256]:
    nodes = list(n*np.ones(neach, dtype=int))
    nodelist.append(nodes)
    
nodeflatlist = [item for sublist in nodelist for item in sublist]
print(nodeflatlist)

frameworklist = []
for m in range(neach):
    frameworks = ["Bare-metal","Shifter","Podman-container-per-process","Podman-exec-mode"]
    frameworklist.append(frameworks)

frameworkflatlist = [item for sublist in frameworklist for item in sublist]
print(frameworkflatlist)

def convert_string_to_timedelta(input):
    j = []
    for i in input:
        j.append(time.fromisoformat(str(i)))
    return j  

first_run = np.array([
'00:17:21',
'00:17:28',
'00:17:48',
'00:17:45',
'00:08:44',
'00:08:46',
'00:08:55',
'00:11:01',
'00:04:35',
'00:04:29',
'00:04:39',
'00:04:42',
'00:03:09',
'00:02:57',
'00:02:54',
'00:02:38'])

second_run = np.array([
'00:17:18',
'00:17:22',
'00:17:33',
'00:18:01',
'00:08:51',
'00:08:59',
'00:09:03',
'00:10:58',
'00:04:28',
'00:04:50',
'00:04:36',
'00:04:52',
'00:03:07',
'00:03:03',
'00:03:04',
'00:02:30'])



first_run_data=convert_string_to_timedelta(first_run)
second_run_data=convert_string_to_timedelta(second_run)

firstrundict = dict()
firstrundict['Nodes']=nodeflatlist
firstrundict['Framework']=frameworkflatlist
firstrundict['Runtime']=first_run_data

secondrundict = dict()
secondrundict['Nodes']=nodeflatlist
secondrundict['Framework']=frameworkflatlist
secondrundict['Runtime']=second_run_data

firstrundf = pd.DataFrame(firstrundict)
secondrundf = pd.DataFrame(secondrundict)
plotdf = pd.concat([firstrundf, secondrundf])

plotdf['Runtime'] = pd.to_timedelta(plotdf['Runtime'].astype(str)).dt.total_seconds()

palette=dict()
palette['Bare-metal']='red'
palette['Shifter']='blue'
palette['Podman-container-per-process']='darkgreen'
palette['Podman-exec-mode']='seagreen'

plt.figure(figsize=(10,8))

g = sns.catplot(data=plotdf, 
                x="Nodes", 
                y="Runtime", 
                hue="Framework",
                sharey=False,
                kind="bar",
                palette=palette,
                legend=False,
                height=6, 
                aspect=1.3
)

g.set(ylim=(0,1200))
g.fig.subplots_adjust(top=0.9)
g.fig.suptitle('EXAALT Carbon ~1B Atoms')
g.set_axis_labels("Nodes", "Runtime (s)")

plt.legend()
plt.tight_layout()
plt.savefig("exaalt.png", dpi=300)