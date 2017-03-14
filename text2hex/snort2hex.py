#!usr/bin/python2.7

import sys
import binascii


def readRules(rules):

   
    try:
        fr = open(rules, 'r')
    except IOError:
        print 'File not found'
        sys.exit()
    else:
        ruleSet = set()
        for line in fr:
            i = line.find('content:"')
            line = line[i+9:]
            j = line.find('"')
            ruleSet.add(line[:j])

        fr.close()
        return ruleSet

def convert(ruleSet):
    list = []
    for rule in ruleSet:
        if rule.find('|') == -1:
            asciiVal = ""
            for ch in rule:
                asciiVal += str(hex(ord(ch)))[2:] + " "
            list.append(asciiVal)
    return list

def outputRules(list):
    fw = open("signatures.txt", 'a')
    for rule in list:
        fw.write(rule +'\n')
    
    fw.close()
def main():

    if len(sys.argv) != 2:
        print 'Invalid Argument Count'
        sys.exit()
    ruleSet = readRules(sys.argv[1])
    list = convert(ruleSet)
    outputRules(list)



if __name__ == '__main__':
    main()
