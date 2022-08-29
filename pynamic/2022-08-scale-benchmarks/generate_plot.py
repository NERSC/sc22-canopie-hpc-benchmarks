#!/usr/bin/python

import sys
import numpy as np
import pandas as pd
from datetime import time
from matplotlib import pyplot as plt
import seaborn as sns


def plot(plotdf, outf):
    sns.set_style("ticks")
    sns.set_context("poster")


    hue_order=["Bare-metal-1st","Bare-metal-2nd","Shifter-1st","Shifter-2nd","Podman-exec-1st","Podman-exec-2nd", "Podman-container-per-process-1st", "Podman-container-per-process-2nd"]
    #a dictionary mapping hue levels to matplotlib colors
    palette=dict()
    palette['Bare-metal-1st']='darkred'
    palette['Bare-metal-2nd']='red'
    palette['Shifter-1st']='darkblue'
    palette['Shifter-2nd']='blue'
    palette['Podman-exec-1st']='darkgreen'
    palette['Podman-exec-2nd']='seagreen'
    palette['Podman-container-per-process-1st']='lightseagreen'
    palette['Podman-container-per-process-2nd']='lightgreen'
    g=sns.catplot(data=plotdf,
                row="Measurement",
                aspect=2.2,
                x="Nodes", 
                y="Time (s)", 
                hue="Framework",
                hue_order=hue_order,
                palette=palette,
                kind="bar",
                sharey=False,
                sharex=False,
    )

    #label nodes on every xaxis
    ax = g.axes
    ax[0,0].set_xlabel("Nodes")
    ax[1,0].set_xlabel("Nodes")
    ax[2,0].set_xlabel("Nodes")

    # Finalize the plot
    g.fig.subplots_adjust(top=0.90)
    plt.subplots_adjust(hspace=0.5)
    g.fig.suptitle('Pynamic - Scaling')
    plt.savefig(outf, dpi=300)

def process_log(fn):
    imports = []
    visits = []
    ttimes = []
    stimes = []
    print(fn)
    with open(fn) as f:
        for line in f:
            if "module import time" in line:
                importt = float(line.split()[5])
                imports.append(importt)
            if "module visit time" in line:
                visit = float(line.split()[5])
                visits.append(visit)
            if "Time" in line:
                res = line.split()[1]
                tele = res.split(":")
                sec = float(tele[0])*60 + float(tele[1])
                ttimes.append(sec)
                stimes.append(sec - importt - visit)
    return {"Startup": stimes, "Imports": imports, "Visits": visits, "Total": ttimes}
                
def Average(lst):
    return sum(lst) / len(lst)

if __name__ == "__main__":
    print("Mode           Imp-!$ Imp-$ Vis-!$  Vis-$")
    modes_long={"baremetal": "Bare-metal",
                "shifter": "Shifter",
                "podman-hpc": "Podman-container-per-process",
                "podman-shared": "Podman-shared",
                "podman-exec": "Podman-exec"}
    modes = []
    nodes = []
    data = []
    meass = []
    for fn in sys.argv[1:]:
        ele = fn.split('-')
        mode = '-'.join(ele[1:-2])
        if mode not in modes_long:
            continue
        scale = int(ele[-2])
        mvals = process_log(fn)
        if len(mvals['Imports']) < 2:
            continue
        nct = '%d' % (int(scale)/64)
        for meas, vals in mvals.items():
            modes.extend([
                      "{}-1st".format(modes_long[mode]),
                      "{}-2nd".format(modes_long[mode])
                     ])
            nodes.extend([nct, nct])
            meass.extend([meas, meas])
            data.extend(vals)

    tdict = {
             'Nodes': np.array(nodes),
             'Framework': np.array(modes),
             'Time (s)': np.array(data),
             'Measurement': meass
            }
    df = pd.DataFrame(tdict)
    print(df)
    plot(df, "pynamic_scaling.png")
