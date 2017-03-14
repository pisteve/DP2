#!usr/bin/python

import sys
#python text2hex.py textfile 


def main():

    if len(sys.argv) != 2:
        print " not enough arguments"
        sys.exit()
    
    try:
        fr = open(sys.argv[1], 'r')
    except IOError:
        print 'File not found'
        sys.exit()
    else:
        fw = open("hex.txt", 'a')
        for line in fr:
            hexVal = "" 
            line = line.rstrip()
            for ch in line:
                hexVal += str(hex(ord(ch)))[2:] + " " 
            fw.write(hexVal +'\n');
        fw.close()



if __name__ == '__main__':
    main()
