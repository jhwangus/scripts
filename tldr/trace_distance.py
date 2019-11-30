#! /usr/bin/env python3

'''
Usage        : trace_distance.py log_file
-h           : this help
log_file     : trace log file

This script takes the trace log and find the distance distribution 
between two occurrences of the same address 

Example:
$ trace_distance.py 12K.log
'''

import sys, getopt, os, shutil
import array as arr
import csv

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
    # print(args)
    if len(args) == 1:
        log_name = args[0]
    else:
        usage()
        sys.exit()
    # main
    addr = dict()
    #try:
    with open(log_name) as f:
        count = 0
        for line in f:
            count = count + 1
            row = line.strip().split()
            if row[1] in addr:
                l = addr[row[1]]
                l.append(count)
                addr[row[1]] = l
            else:
                addr[row[1]] = [count]
    # except:
    #    print("Error on ", log_name)
    
    # calculate the distance
    dist = dict()
    for key in addr:
        line_nums = addr[key]
        dl = []
        for i in range(len(line_nums) - 1):
            dl.append(line_nums[i+1] - line_nums[i])
        for j in range(len(dl)):
            if dl[j] in dist:
                w = dist[dl[j]]
                dist[dl[j]] = w + 1
            else:
                dist[dl[j]] = 1
    # Output
    for key in sorted(dist.keys()) :
        print(key, ",", dist[key])


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))