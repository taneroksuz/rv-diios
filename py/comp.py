#!/usr/bin/env python3

import re
import os
import argparse

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Compare register files.')
    parser.add_argument('--src_txt',required=True,help='source of compared register file')
    parser.add_argument('--dst_txt',required=True,help='destination of compared register file')

    args = parser.parse_args()

    src_ext = args.src_txt.split(".")[-1]
    dst_ext = args.dst_txt.split(".")[-1]

    if src_ext != dst_ext:
        exit(1)

    res_txt = "difference."+src_ext

    src_txt = open(args.src_txt, "r")
    dst_txt = open(args.dst_txt, "r")

    src_list = []
    for src_line in src_txt:
        src_tex = re.findall(r'\b[A-Z_a-z]\w*\b', src_line)
        src_num = re.findall(r'=\s*([0-9a-fA-F]+)\s*;', src_line)
        src_list.append(list(zip(src_tex,src_num)))

    #print(src_list)
    #exit(0)

    dst_list = []
    for dst_line in dst_txt:
        dst_tex = re.findall(r'\b[A-Z_a-z]\w*\b', dst_line)
        dst_num = re.findall(r'=\s*([0-9a-fA-F]+)\s*;', dst_line)
        dst_list.append(list(zip(dst_tex,dst_num)))

    #print(dst_list)
    #exit(0)

    if os.path.isfile(res_txt):
        os.remove(res_txt)

    f = open(res_txt, "w")

    for i in range(min(len(src_list),len(dst_list))):
        cond = False
        for j in range(1,len(src_list[i])):
            cond = cond or (src_list[i][j][1] != dst_list[i][j][1])
        if cond:
            string = dst_list[i][0][0]+" = "+dst_list[i][0][1].rjust(10)+ " ;\t"
            for j in range(1,len(dst_list[i])-1):
                string += dst_list[i][j][0]+" = "+dst_list[i][j][1]+ " ;\t"
            string += dst_list[i][-1][0]+" = "+dst_list[i][-1][1]+ " ;\n"
            f.writelines(string)

    f.close()

    exit(0)