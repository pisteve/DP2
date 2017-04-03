#!usr/bin/python
import sys


def write_header(fw, size):
    fw.write("Library IEEE;\n")
    fw.write("USE IEEE.STD_LOGIC_1164.ALL;\n")
    fw.write("USE IEEE.STD_LOGIC_UNSIGNED.ALL;\n")
    fw.write('\n')

    fw.write("entity detector is\n")
    fw.write("\tport(\n")
    fw.write("\t\tclk: in std_logic;\n")
    fw.write("\t\ten: in std_logic;\n")
    fw.write("\t\tdata_in: in std_logic_vector(7 downto 0);\n")

    for i in range (size-1):
        fw.write("\t\toutput_" + str(i) + " : out std_logic);\n")

    fw.write("\t\toutput_" + str(size-1) + " : out std_logic\n")
    fw.write("\t);\n")
    fw.write("end detector;\n\n")

def write_components(fw):
    fw.write("component byte_compare")
    fw.write("\tport(\n")
    fw.write("\t\tdata_in : in std_logic_vector(7 downto 0);\n")
    fw.write("\t\tsig_in : in std_logic_vector(7 downto 0);\n")
    fw.write("\t\tis_valid : out std_logic\n")
    fw.write(");\n")
    fw.write("end component;\n\n");

    fw.write("component FF")
    fw.write("\tport(\n")
    fw.write("\t\tclk : in std_logic;\n")
    fw.write("\t\treset : in std_logic;\n")
    fw.write("\t\tinput : in std_logic;\n")
    fw.write("\t\toutput : out std_logic\n")
    fw.write(");\n")
    fw.write("end component;\n\n");

def hexify(sigList):
    list = []

    for line in sigList:
        hexVal = "" 
        line = line.rstrip()
        for ch in line:
            hexVal += str(hex(ord(ch)))[2:] 
        list.append(hexVal)
    return list

def write_signals(fw, hex_list):

    fw.write("signal input : std_logic_vector(7 downto 0);\n")


    for i in range(len(hex_list)):
        fw.write("-- " + hex_list[i].decode("hex") + "\n");
        for j in range(0, len(hex_list[i]), 2):
            fw.write("signal cmp_s" + str(i) + '_0x' + hex_list[i][j:j+2] + ': std_logic;')
            fw.write("\t--" + hex_list[i][j:j+2].decode("hex") +'\n')
            fw.write("signal s" + str(i) + "_ff_" + str(j/2) + ": std_logic := '0';\n")
            fw.write("signal out_and_s" + str(i) + "_ff_" + str(j/2) + ": std_logic := '0';\n\n")
        fw.write('\n')
    
    # for i in range(len(hex_list)):
    #     for j in range(0, len(hex_list[i]), 2):
    #         fw.write("signal: FF_s" + str(i) + '_f' + str(j/2) + '_' + hex_list[i][j:j+2] + ': std_logic : =0;\n')
    #     fw.write('\n')


def write_ports(fw, hex_list):
    for i in range(len(hex_list)):
        for j in range(0, len(hex_list[i]), 2):
            fw.write("\tbyte_comp_s"+ str(i) + '_' + hex_list[i][j:j+2] + ':')
            fw.write(' byte_compare port map( data_in => input, sig_in => x"' + hex_list[i][j:j+2] +'" ')
            fw.write(", is_valid => cmp_s" + str(i) + '_0x' + hex_list[i][j:j+2] + ");\n")
            
            if j == 0:
                fw.write("\tflipflop_s"+ str(i) + '_f' + str(j/2) + ':')
                fw.write(" FF port map( clk => clk, reset => reset, input => '1', output =>" + "s" + str(i) + "_ff_" + str(j/2) + ");\n")
            else:
                fw.write("\tflipflop_s"+ str(i) + '_f' + str(j/2) + ':')
                fw.write(" FF port map( clk => clk, reset => reset, input => and_s" + str(i) + '_f' + str(j/2) + ", output => s" + str(i) + '_ff_' + str(j/2)+ ");\n")
            
   
            fw.write("\tout_and_s" + str(i) + "_ff_" + str(j/2) + " <= " + "s" + str(i) + "_ff_" + str(j/2) + " and")
            fw.write(" cmp_s" + str(i) + '_0x' + hex_list[i][j:j+2] + ");\n");
        fw.write("output_" + str(i) + " <= out_and_s" + str(i) + "_ff_" + str(j/2)+ '\n')
        fw.write('\n')   


def write_architecture(fw, hex_list):
    fw.write("architecture behavioral of detector is\n\n")
    
    write_components(fw)
    write_signals(fw, hex_list)


    fw.write("begin\n")
    fw.write("\tinput <= data_in;\n");
    write_ports(fw, hex_list);

    fw.write("end behavioral;\n")
def main():

    if(len(sys.argv)!=3):
        print "error, script only accepts 3 arguments"
        print "example: python seq_match.py inputFile.txt outputFile.vhd"
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
    
    fw = open(sys.argv[2]+'.vhd', 'w')
    write_header(fw, len(sig_list))
    hex_list = hexify(sig_list);
    write_architecture(fw, hex_list)


if __name__ == '__main__':
    main()
    