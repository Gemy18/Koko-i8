def abdullah(ins):
    karem={"r0":"000"
           ,"r1":"001"
        , "r2": "010"
        , "r3": "011"
        , "r4": "100"
        , "r5": "101"
        , "r6": "110"
        , "nop": "00000"
        , "mov": "00001"
        , "add": "00010"
        , "sub": "00011"
        , "and": "00100"
        , "or":  "00101"
        , "rlc": "00110"
        , "rrc": "00111"
        , "shl": "01000"
        , "shr": "01001"
        , "out": "01010"
        , "in":  "01011"
        , "not": "01100"
        , "neg": "01101"
        , "inc": "01110"
        , "dec": "01111"
        , "jz":  "10000"
        , "jn":  "10001"
        , "jc":  "10010"
        , "jmp": "10011"
        , "setc":"10100"
        , "clrc":"10101"
        , "push":"10110"
        , "pop": "10111"
        , "call":"11000"
        , "ret": "11001"
        , "rti": "11010"
        , "ldm": "11011"
        , "ldd": "11100"
        , "std": "11101"
           }
    ins=ins.lower()
    ins=ins.replace(","," ")
    ins=' '.join(ins.split())
    lis=ins.split()
    if (lis[0][0])==';':
        return -1
    out=list("00000000000000000000000000000000")
    if lis[0]== "mov":
        out[5:8]=list(karem[lis[1]])
        out[11:14] = list(karem[lis[2]])
    elif lis[0] == "add" or lis[0] == "sub" or lis[0] == "and" or lis[0] == "or" :
        out[5:8] =list( karem[lis[1]])
        out[8:11] = list(karem[lis[2]])
        out[11:14] =list(karem[lis[3]])
    elif lis[0] =="shr" or lis[0] =="shl" or lis[0] =="ldd" or lis[0] =="ldm" or lis[0] =="std"  :
        tmp = bin(int(lis[2]) % (1 << 16))[2:]
        out[16:32]=list((16 - len(tmp)) * "0"+tmp)
        out[11:14] =list( karem[lis[1]])
    elif lis[0]=="nop" or lis[0]=="setc" or lis[0]=="clrc" or lis[0]=="ret" or lis[0]=="rti":
        pass

    else :
        out[11:14] =list( karem[lis[1]])

    out[0:5]= list(karem[lis[0]])
    return ''.join(out)

def omer_magdy(filename,out1,out2):
    f = open(filename, 'r')
    dic1={}
    dic2={}
    for i in range(1024):
        dic1[i]=  "0000000000000000"
        dic2[i] = "0000000000000000"
    data=0
    instruction=0
    new=-1
    for line in f:

        ins = line.lower()
        ins = ins.replace(",", " ")
        ins = ' '.join(ins.split())
        lis = ins.split()
        if len(lis)==0:
            continue
        if lis[0][0] == '-' or lis[0].isdigit():

            tmp = bin(int(lis[0]) % (1 << 16))[2:]
            temp = (16 - len(tmp)) * "0" + tmp
            if new!= -1:
                data=new
                new=-1
            dic1[data]=temp
            data+=1

        elif lis[0][0] == '.':
            new=int(lis[0][1:])
        else :
            if new != -1:
                instruction = new
                new = -1
            s=abdullah(line)
            if s==-1:
                continue
            dic2[instruction] = ''.join(list(s)[0:16])
            dic2[instruction+1]=''.join(list(s)[16:])

            instruction+=2
        w1 = open(out1, 'w')
        w2 = open(out2, 'w')
        for i in range(1024):
            w1.write(str(i)+": "+str(dic1[i]))
            w2.write(str(i) + ": "+str( dic2[i]))
            w1.write(('\n'))
            w2.write(('\n'))

            # loop and print the mem
omer_magdy("test.txt","data","ins")