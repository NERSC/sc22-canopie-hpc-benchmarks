
import sys
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
import seaborn as sns


def plot(plotdf, outf):
    sns.set_style("ticks")
    sns.set_context("poster")


    hue_order=["Shifter", "Podman container per process", "Podman exec mode"]
    #a dictionary mapping hue levels to matplotlib colors
    palette=dict()
    palette['Shifter']='darkblue'
    palette['Podman exec mode']='darkgreen'
    palette['Podman container per process']='lightgreen'
    g=sns.catplot(data=plotdf,
                row="Measurement",
                aspect=2.2,
                x="Tasks",
                y="Time (s)",
                hue="Framework",
                hue_order=hue_order,
                palette=palette,
                kind="bar",
                sharey=False,
                sharex=False
    )

    #label nodes on every xaxis
    ax = g.axes
    ax[0,0].set_xlabel("Tasks per Node")
    ax[1,0].set_xlabel("Tasks per Node")
    ax[2,0].set_xlabel("Tasks per Node")

    # Finalize the plot
    g.fig.subplots_adjust(top=0.90)
    plt.subplots_adjust(hspace=0.5)
    g.fig.suptitle('Pynamic - Tasks per Node')
    plt.savefig(outf, dpi=300)

def Average(lst):
    return sum(lst) / len(lst)


if __name__ == "__main__":
    tasks = []
    modes = []
    data = []
    meass = []
    for line in sys.stdin:
        val = None
        if line.startswith("RUN"):
            ele = line.replace("RUN:", "").rstrip().split(" - ")
            mode = ' '.join(ele[0:-1]).lstrip()
            scale, rep = ele[-1].split(" ")
        elif line.find("import time") > 0:
            it = float(line.split(" ")[-2])
            meas = "Import"
        elif line.find("visit time") > 0:
            vt = float(line.split(" ")[-2])
            meas = "Visit"
        elif line.startswith("Time"):
            ele = line.rstrip().split(":")
            ttime = int(ele[1])*60 + float(ele[2])
            stime = ttime - it - vt
            tasks.extend([scale, scale, scale, scale])
            modes.extend([mode, mode, mode, mode])
            data.extend([stime, it, vt, ttime])
            meass.extend(["Startup", "Imports", "Visits", "Total"])
    tdict = {
             'Tasks': np.array(tasks),
             'Framework': np.array(modes),
             'Time (s)': np.array(data),
             'Measurement': np.array(meass)
            }
    df = pd.DataFrame(tdict)
    print(df)
    plot(df, "pynamic_pernode.png")
