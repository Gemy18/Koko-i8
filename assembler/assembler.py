def abdullah(ins,fileout):
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
    out=list("00000000000000000000000000000000")
    if lis[0]== "mov":
        out[5:8]=list(karem[lis[1]])
        out[11:14] = list(karem[lis[2]])
    elif lis[0] == "add" or lis[0] == "sub" or lis[0] == "and" or lis[0] == "or" :
        out[5:8] =list( karem[lis[1]])
        out[8:11] = list(karem[lis[2]])
        out[11:14] =list(karem[lis[3]])
    elif lis[0] =="shr" or lis[0] =="shl" or lis[0] =="ldd" or lis[0] =="ldm" or lis[0] =="std"  :
        out[16:32] = bin(int(lis[2]) % (1 << 16))[2:]
        out[11:14] =list( karem[lis[1]])
    elif lis[0]=="nop" or lis[0]=="setc" or lis[0]=="clrc" or lis[0]=="ret" or lis[0]=="rti":
        pass
    else :
        out[11:14] =list( karem[lis[1]])

    out[0:5]= list(karem[lis[0]])
    w = open(fileout, 'w')
    w.write((''.join(out)))
    w.write(('\n'))




abdullah( "mov r1 , r1","tempfile" )