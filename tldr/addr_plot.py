#! /usr/bin/env python3

'''Usage        : addr_plot.py log_file
-h           : this help
log_file     : memory trace log file

This script take the log file in log_dir and output summary csv 

Example:
$ addr_plt.py log_file
'''

import sys, getopt, os, shutil
import array as arr


def usage():
    ''' Display command usage.'''
    sys.stderr.write(__doc__)
    sys.stderr.flush()

def main(argv):
    # getopt
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
    if len(args) == 1:
        log_name = args[0]
    else:
        usage()
        sys.exit()
    # 0x80000000 - 0xAFFFFFFF
    # 12
    # dist = arr.array("L", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    # 24
    dist = arr.array("L", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    with open(log_name) as f:
        for line in f:
            t = line.split()
            addr = int(t[1], 16)
            # print(addr)
            if (addr < 0x80000000):
                continue
            # print((addr - 0x80000000) >> 25)
            idx = (addr - 0x80000000) >> 25
            if (idx > 23):
                continue
            dist[idx] = dist[idx] + 1
    print(log_name, end="")
    for i in range(len(dist)):
        print(',', dist[i], end="")
    print()

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))