#! /usr/bin/env python3

'''
Usage        : trace_plot.py csv_file 1st_line num_line title
-h           : this help
csv_file     : memory trace timing csv file
1st_line     : the first line to read from csv file
num_line     : the number of line to read from csv file
title        : single quoted chart title


This script take the trace csv file and output plot 

Example:
$ trace_plt.py csv_file 12 20 'chart example'
'''

import sys, getopt, os, shutil
import array as arr
import csv
import matplotlib.pyplot as plt
import numpy as np

def usage():
    ''' Display command usage.'''
    sys.stderr.write(__doc__)
    sys.stderr.flush()

def main(argv):
    # getopt
    max_num_line = 20
    try:
        opts, args = getopt.getopt(argv, "h")
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    # handle options
    for opt, optarg in opts:
        if opt == '-h':
            usage()
            sys.exit()
    print(args)
    if len(args) == 4:
        log_name = args[0]
        first = int(args[1])
        num_line = int(args[2])
        if num_line > max_num_line:
            num_line = max_num_line
        chart_title = args[3]
    else:
        usage()
        sys.exit()
    # main
    tag = []
    issue = [[], []]
    cmd = [[], []]
    data = [[],[]]
    point = 0.5
    try:
        with open(log_name) as csv_f:
            csv_reader = csv.reader(csv_f, delimiter=',')
            count = 0
            for row in csv_reader:
                count = count + 1
                if count < first:
                    continue
                elif count >= first + num_line:
                    break
                # process
                tag.append(row[0]+'_'+row[1]+'_'+row[2])
                issue[0].append(int(row[3]))
                issue[1].append(point)
                cmd[0].append(int(row[4]))
                cmd[1].append(int(row[5]) - int(row[4]))
                data[0].append(int(row[6]))
                data[1].append(int(row[7]) - int(row[6]))
    except:
        print("Error on ", log_name)

    print(issue[0])
    print(issue[1])

    delta = 2
    xmin = min(issue[0]) - delta
    if xmin < 0:
        xmin = 0
    xmax = max([a + b for (a, b) in zip(data[0], data[1])]) + delta
    print(xmin, xmax)
    if (num_line <= 10):
        fsize = (10, 5)
        width = 0.35
    else:
        fsize = (16, 8)
        width = 0.25
    fig = plt.figure(figsize=fsize, dpi=100, facecolor='white')
    
    y_pos = np.arange(len(tag))

    tc = ['b', 'gold', 'g', 'r', 'c', 'm', 'y']
    colors = []
    for i in range(3):
        colors = colors + tc

    ax = plt.subplot(111)
    ax.barh(y_pos, issue[1], width, left=issue[0], color=colors, alpha=0.3)
    ax.barh(y_pos + width, cmd[1], width, left=cmd[0], color=colors, alpha=0.5)
    ax.barh(y_pos + width * 2, data[1], width, left=data[0], color=colors)
    
    ax.set_yticks(y_pos + width)
    ax.set_yticklabels(tag)
    ax.set_xlabel('ns')
    plt.tight_layout()
    plt.grid(which='both')
    plt.gca().invert_yaxis()
    plt.xlim(xmin, xmax)
    plt.title(chart_title)
    plt.show()

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))