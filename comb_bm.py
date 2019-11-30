#! /usr/bin/env python3

'''
Usage        : comb_bm.py excel_file csv_file1 [csv_file2 [ ... ]]
-h           : this help
excel_file   : Excel file (.xlsx)
csv_filen    : the summary files created by proc_run_sum.sh

This script takes the csv files and create the performance table
    for all benchmarks over all memory configuration

Example:
$ comb_bm.py 1129_st_sram_comp.xlsx 1120_st_sram_*.csv
'''

import sys, getopt, os, shutil
import csv
from openpyxl import Workbook

def usage():
    ''' Display command usage.'''
    sys.stderr.write(__doc__)
    sys.stderr.flush()

def clean_name(s):
    n = os.path.splitext(os.path.splitext(os.path.basename(s.lower()))[0])[0]
    return (n)

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
    if len(args) < 2:
        usage()
        sys.exit()
    else:
        excel_file = args[0]
        csv_files = args[1:]
    # main
    wb = Workbook()

    comp = []
    j = 0
    for f in csv_files:
        name = clean_name(f)
        ws = wb.create_sheet(name)
        try:
            with open(f) as csv_f:
                csv_reader = csv.reader(csv_f, delimiter=',')
                i = 0
                for row in csv_reader:
                    if len(row) == 5:
                        row.append(float(row[4]) / float(row[1]))
                    ws.append(row)
                    if (j == 0):
                        comp.append([row[0], row[5]])
                    else:
                        comp[i].append(row[5])
                    i = i + 1
        except:
            print("Error on ", log_name)
        comp[0][j + 1] = name
        j = j + 1

    ws = wb.worksheets[0]
    ws.title = "Comparison"
    for row in comp:
        ws.append(row)
    wb.save(excel_file)

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
