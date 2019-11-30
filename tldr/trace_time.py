#! /usr/bin/env python3

'''
Usage        : trace_time.py log_file
-h           : this help
log_file     : extracted log file

This script take the log file and generate trace timing diagram 

Example:
$ trace_time.py log_file
'''

import sys, getopt, os, shutil, math
import array as arr

def usage():
    ''' Display command usage.'''
    sys.stderr.write(__doc__)
    sys.stderr.flush()

def strip_bracket(s):
    return (s[1:len(s)-1])

def tfind(wlist, addr, sz):
    for i in range(len(wlist)):
        # print(i)
        if ((wlist[i][0] == addr) and (wlist[i][sz] == 0)):
            return i
    print(addr, sz)
    print(wlist)
    raise Exception
    return -1

def output(w):
    # print("output: ", w)   
    print(w[0], ",", w[1], ",", w[3], ",", w[2], ",", w[4], ",", 
        w[5], ",", w[6], ",", w[7])


def find_index(wlist, addr):
    retval = []
    for i in range(len(wlist)):
        if wlist[i][0] == addr and len(wlist[i]) == 8:
            return (i)
    raise Exception
    return -1

def to_ns(s, chk):
    if (chk[0] == 'p'):
        v = math.ceil(float(s)/1000)
        return str(v)
    elif (chk[0] == 'u'):
        v = int(s) * 1000
        return str(v)
    elif (chk[0] == 'm'):
        v = int(s) * 1000000
        return str(v)
    elif (chk[0] == 's'):
        v = int(s) * 1000000000
        return str(v)        
    else:
        return s

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
    
    print("ID, Action, Channel, TLDR_Start, Cmd_Start, Cmd_End, Data_Start, Data_End")
    work_list = []
    with open(log_name) as f:
        for line in f:
            buf = line.split()
            # print("buf: ", buf)
            if len(buf) < 5:
                address = strip_bracket(buf[1])
                action = buf[0]
                t = to_ns(buf[2][1:], buf[3])
                # print(address, action, t)
                work_list.append([address, action, t, '', 0, 0, 0, 0, 0])
            else:
                address = strip_bracket(buf[3])
                dest = strip_bracket(buf[2])
                t = to_ns(buf[0][6:], buf[1])
                # print("buf: ", buf)
                if (buf[4] == "Start"):
                    i = tfind(work_list, address, 4)
                    work_list[i][3] = dest
                    work_list[i][4] = t
                    work_list[i][8] = work_list[i][8] + 1 
                    # print(4, work_list[i])
                elif (buf[4] == "End"):
                    i = tfind(work_list, address, 5)
                    work_list[i][5] = t
                    work_list[i][8] = work_list[i][8] + 1 
                    # print(5, work_list[i])
                elif (buf[6] == "start."):
                    i = tfind(work_list, address, 6)
                    work_list[i][6] = t
                    work_list[i][8] = work_list[i][8] + 1 
                    # print(6, work_list[i])                    
                elif (buf[6] == "end"):
                    i = tfind(work_list, address, 7)
                    work_list[i][7] = t
                    work_list[i][8] = work_list[i][8] + 1 
                    # print(7, work_list[i])
                else:
                    raise Exception;
                if work_list[i][8] == 4:
                    output(work_list[i])
                    del work_list[i]

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
