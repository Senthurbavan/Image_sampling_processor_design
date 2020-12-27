assembly = open("sample.txt", "r")
# print assembly

#binary_code = open("binary.txt", "w")
binary_list = []
# binary_code.write("this is binary")
assembly_txt = assembly.read()
assembly_list = assembly_txt.split('\n')
NOP=5
CLAC = 6
LDAC = 7
STAC=8
MVACR = 10
MVACR1 = 11
MVACR2 = 12
MVACTR = 13
MVACAR =14
MVR = 15
MVR1 = 16
MVR2 = 17
MVTR = 18
INCAR =19
INCR1 =20
INCR2 = 21
JPNZ = 22
JPNZY = 23
JPNZN = 24
JPNZN1 = 25
JPNZN2 = 26
ADD = 27
SUB = 28
MUL4 = 29
DIV2 = 30
ADDM = 31
END=32
MVAR = 33
JPNZY1 = 34
ADDM1 = 35
for i in assembly_list:
    if i == "LDAC":
        binary_list.append(7)
    elif i == "CLAC":
        binary_list.append(6)
    elif i == "STAC":
        binary_list.append(8)
    elif i == "MVACR":
        binary_list.append(10)
    elif i == "MVACR1":
        binary_list.append(11)
    elif i == "MVACR2":
        binary_list.append(12)
    elif i == "MVACTR":
        binary_list.append(13)
    elif i == "MVACAR":
        binary_list.append(14)
    elif i == "MOVR":
        binary_list.append(15)
    elif i == "MVR1":
        binary_list.append(16)
    elif i == "MVR2":
        binary_list.append(17)
    elif i == "MVTR":
        binary_list.append(18)
    elif i == "INCAR":
        binary_list.append(19)
    elif i == "INCR1":
        binary_list.append(20)
    elif i == "INCR2":
        binary_list.append(21)
    elif i == "JPNZ":
        binary_list.append(22)
    elif i == "ADD":
        binary_list.append(27)
    elif i == "SUB":
        binary_list.append(28)
    elif i == "MUL4":
        binary_list.append(29)
    elif i == "DIV2":
        binary_list.append(30)
    elif i == "ADDM":
        binary_list.append(31)
    elif i == "MVAR":
        binary_list.append(33)
    elif i == "END":
        binary_list.append(32)
    elif i == "3":
        binary_list.append(3)
    elif i == "254":
        binary_list.append(254)
    elif i == "255":
        binary_list.append(255)
    elif i == "93":
        binary_list.append(93)
    elif i == "1":
        binary_list.append(1)   
    else:
        binary_list.append("error"+str(i))
print binary_list
length1 = len(binary_list)
print(length1)

##a = b = 0
##x = y = 0
##intermediate = 0
##jump1 = 27
##jump2 = 0
##firstPixelLocation = length1 + 18
##newPixelLocation = length1 + 18 + n * n
##
##print(binary_list)
##
##for i in range(len(binary_list)):
##    if binary_list[i] == "first pixel location":
##        binary_list[i] = firstPixelLocation
##
##resources = [n, 1, 2, 3, 4, a, b, x, y, 0, 0, 2 * n, (n // 2)-1, intermediate, jump1, jump2, firstPixelLocation,
##             newPixelLocation]
##print (resources)
##print(len(resources))
##binary_list = binary_list + resources
##
####assembly_array=assembly.split( )
### print assembly_list
##print(binary_list)
##binary_code.writelines(["%s\n" % item for item in binary_list])
##binary_code.close()
