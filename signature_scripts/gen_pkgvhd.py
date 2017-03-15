#!usr/bin/python

#how to run: 
#python gen_pkgvhd.py inputfile.txt outfileName

import sys


def generateLUT(sigList, outputFile, maxLength):
    fw = open(outputFile+".vhd", 'w')

    fw.write("Library IEEE;\n")
    fw.write("USE IEEE.STD_LOGIC_1164.ALL;\n")
    fw.write("USE IEEE.STD_LOGIC_UNSIGNED.ALL;\n")
    fw.write('\n')

    fw.write("package " +outputFile + " is\n")
    fw.write("\ttype s_array is array(0 to " + str(len(sigList)-1) + ") of std_logic_vector(" +str(maxLength*8 - 1) + " down to 0);\n")
    fw.write("\tconstant signatures: s_array := (\n")

    index = 0
    for line in sigList:
        line.rstrip('\n')
        asciiVal = ''

        for char in line:
            asciiVal += str(format(ord(char),'02x'))

        for i in range(len(line),maxLength):
            asciiVal += '00'
        fw.write('\t\tX"' + asciiVal + '"')
        index+=1
        if(index != len(sigList)):
            fw.write(',\n')
        else:
            fw.write(');\n')
    fw.write('end '+ outputFile+';')
    fw.close()
    
def main():

    if(len(sys.argv)!=3):
        print "error, script only accepts 3 arguments"
        print "example: python gen_pkgvhd.py inputFile.txt outfileName"
        sys.exit()

    sigList = list()
    maxLength = 0
    
    try:
        fr = open(sys.argv[1], 'r')
    except IOError:
        print 'File not found'
        sys.exit()
    else:
        for line in fr:
            line.rstrip()
            sigList.append(line)
            
            if(len(line) > maxLength):
                maxLength = len(line)
        fr.close()
        sigList.sort()
    
    # print sigList
       
    generateLUT(sigList, sys.argv[2], maxLength)
    
    


if __name__ == '__main__':
    main()
