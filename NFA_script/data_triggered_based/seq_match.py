#!usr/bin/python
import sys

'''

python seq_detect.py signatures.txt
only accepts 2 arguments
outputs a seq_detect.vhd and pull_up.vhd

'''


def seq_detect_header(fw, size):
    fw.write("Library IEEE;\n")
    fw.write("USE IEEE.STD_LOGIC_1164.ALL;\n")
    fw.write("USE IEEE.STD_LOGIC_UNSIGNED.ALL;\n")
    fw.write('\n')

    fw.write("entity detector is\n")
    fw.write("\tport(\n")
    fw.write("\t\treset: in std_logic;\n")
    fw.write("\t\tdata_in: in std_logic_vector(7 downto 0);\n")

    for i in range(size - 1):
        fw.write("\t\toutput_" + str(i) + " : out std_logic;\n")

    fw.write("\t\toutput_" + str(size - 1) + " : out std_logic\n")
    fw.write("\t);\n")
    fw.write("end detector;\n\n")


def seq_detect_comps(fw):
    fw.write("component byte_compare")
    fw.write("\tport(\n")
    fw.write("\t\treset : std_logic;\n")
    fw.write("\t\tenable :  std_logic;\n")
    fw.write("\t\tdata_in : in std_logic_vector(7 downto 0);\n")
    fw.write("\t\tsig_in : in std_logic_vector(7 downto 0);\n")
    fw.write("\t\tis_valid : out std_logic\n")
    fw.write(");\n")
    fw.write("end component;\n\n")


def hexify(sigList):
    list = []

    for line in sigList:
        hexVal = ""
        line = line.rstrip()
        for ch in line:
            hexVal += str(hex(ord(ch)))[2:]
        list.append(hexVal)
    return list


def seq_detect_signals(fw, hex_list):
    fw.write("signal enable: std_logic;\n")
    fw.write("signal input : std_logic_vector(7 downto 0);\n")

    for i in range(len(hex_list)):
        fw.write("-- " + hex_list[i].decode("hex") + "\n")
        for j in range(0, len(hex_list[i]), 2):
            if j < len(hex_list[i]):
                fw.write("signal en_and_cmp_s" +
                            str(i) + '_' + str(j / 2) + ': std_logic;\n')
            fw.write("signal cmp_s" + str(i) + '_0x' +
                     hex_list[i][j:j + 2] + '_' + str(j / 2) + ': std_logic;')
            fw.write("\t--" + hex_list[i][j:j + 2].decode("hex") + '\n')

        fw.write("signal out_s" + str(i) + ": std_logic := '0';\n");
        fw.write('\n')


def seq_detect_ports(fw, hex_list):
    for i in range(len(hex_list)):
        for j in range(0, len(hex_list[i]), 2):
            fw.write("\tbyte_comp_s" + str(i) + '_' +
                     hex_list[i][j:j + 2] + '_' + str(j / 2) + ':')
            if j == 0:
                fw.write(
                    ' byte_compare port map(reset => reset, enable => enable, data_in => input, sig_in => x"' + hex_list[i][j:j + 2] + '" ')
            else:
                fw.write(
                    " byte_compare port map(reset => reset, enable => en_and_cmp_s" + str(i) + '_' + str(j / 2 - 1) + ', data_in => input, sig_in => x"' + hex_list[i][j:j + 2] + '"')
            fw.write(", is_valid => cmp_s" + str(i) + '_0x' +
                     hex_list[i][j:j + 2] + '_' + str(j / 2) + ");\n")
            fw.write("\tand_s"+ str(i) + '_' + str(j/2) + ": en_and_cmp_s" + str(i) + '_' + str(j / 2) + "<= enable and cmp_s" + str(i) + '_0x' + hex_list[i][j:j + 2] + '_' + str(j / 2) + ';\n')

        fw.write("\t\nwith reset select\n\tisMatching_" + str(i) + " <=\n\tcmp_s" + str(i) + '_0x' +
                 hex_list[i][j:j + 2] + '_' + str(j / 2) + " when '0',\n")
        fw.write("\t'0' when others;\n")
        fw.write('\n')


def seq_detect_arch(fw, hex_list):
    fw.write("architecture behavioral of detector is\n\n")

    seq_detect_comps(fw)
    pull_up_comps(fw)
    seq_detect_signals(fw, hex_list)
    pull_up_signals(fw, len(hex_list))

    fw.write("begin\n")
    fw.write("\twith data_in select \n\tenable <=\n")
    fw.write("\t\t'0' when ")
    fw.write('"00000000",\n')
    fw.write("\t\t'1' when others;\n\n")
    fw.write("\tinput <= data_in;\n")
    seq_detect_ports(fw, hex_list)
    pull_up_port(fw, len(hex_list))
    fw.write("end behavioral;\n")


def pull_up_comps(fw):
    fw.write("component pull_up_module\n")
    fw.write("\tport(\n")
    fw.write("\t\tenable :  std_logic;\n")
    fw.write("\t\treset :  std_logic;\n")
    fw.write("\t\tisMatching : in std_logic;\n")
    fw.write("\t\tout_isMatching : out std_logic\n")
    fw.write(");\n")
    fw.write("end component;\n\n")


def pull_up_signals(fw, count):
    for i in range(count):
        fw.write("signal isMatching_" + str(i) + ": std_logic;\n")

    fw.write('\n')


def pull_up_port(fw, count):
    for i in range(count):
        fw.write("\tpull_" + str(i) + ": pull_up_module")
        fw.write(" port map(enable => enable, reset => reset, isMatching => isMatching_" +
                 str(i) + ", out_isMatching => output_" + str(i) + ");\n")


def main():

    if(len(sys.argv) != 2):
        print "error, script only accepts 2 arguments"
        print "example: python seq_match.py inputFile.txt"
        sys.exit()

    sig_list = list()

    try:
        fr = open(sys.argv[1], 'r')
    except IOError:
        print 'File not found'
        sys.exit()
    else:
        for line in fr:
            line.rstrip()
            sig_list.append(line)

        sig_list.sort()

    fw = open('seq_detect.vhd', 'w')
    seq_detect_header(fw, len(sig_list))
    hex_list = hexify(sig_list)
    seq_detect_arch(fw, hex_list)
    fw.close()


if __name__ == '__main__':
    main()
