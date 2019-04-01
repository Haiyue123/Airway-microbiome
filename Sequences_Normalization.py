#/usr/bin/env python
# -*- coding:utf-8 -*-
import argparse
import sys
import linecache
import random
import os
import shutil
import re
#random.sample(range(10), 5) 

def script_information():
    print "\n Function:Normalization of Sequences in fasta files。\n"
    print "====================================================================="
    print "Author: WANG Xian"
    print "Email: 806760315@qq.com"
    print "Last: August 2 2016"
    print "====================================================================="
    print "*:If you have questions, please contact the author！Good Luck To You！ ^_^ \n"
#-----Normalization
def delstr_path(p, suffix, n):#p: fold of the files, suffix: suffix of files, n: Normalization number
    workdir = p  
    os.chdir(workdir)  
    cwd = os.getcwd()  
    dirs = os.listdir(cwd)  
    for tmp in dirs:  
        path = os.path.join(cwd, tmp)  
        if os.path.isfile(path):  
            if os.path.splitext(tmp)[1][1:] == suffix:#--find the file that its name has the suffix
                tmp_name = os.path.splitext(tmp)[0]+'_Normalization'+str(n)+'.'+suffix   
                with open(path) as f:  
                    lines = f.readlines()  
                Num=len(lines)/2
                if Num<n:
                    print("the number of sequences in ",path," was less than ",Num)
                else:
                    Numbers=sorted(random.sample(range(1,(Num+1)), n))
                    tmp_file = open(tmp_name, "w")
                    for Num1 in Numbers:
                        tmp_file.write(lines[2*Num1-2])
                        tmp_file.write(lines[2*Num1-1])
                    tmp_file.close()
                    #shutil.move(tmp_name, path)#use the new file to replace the old one 
        elif os.path.isdir(path):# if the path was a path,then recursive down next layer
            print("Enter dir: " + path)  
            delstr_path(path, suffix, n)
def main():
    print("delele contains str in path") 
    parser = argparse.ArgumentParser(usage="\n\npython %(prog)s -p Path -e suffix -n Normalization_Num -o Normalization_Num_reads.fasta ")
    parser.add_argument("-p", "--p", help="Path", type=str)
    parser.add_argument("-e", "--e", help="suffix", type=str)
    parser.add_argument("-n", "--n", help="Normalization_Num", type=int)
    parser.add_argument("-v", '-version', action='version', version='%(prog)s 1.0')
    args = parser.parse_args()
    path = args.p  
    extension = args.e   
    Num = args.n    
    print("Normalization (0) all {1} files in path  {2}  ".format(Num, extension, path)) 
    delstr_path(path, extension, Num) 

if __name__ == "__main__":  
   main()