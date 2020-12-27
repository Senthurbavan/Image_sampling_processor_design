
close all;
clear all;

%ins_ty_1 = {'ADDH','R1','R2','3'};
%ins_ty_2 = {'ADDI','R1','23'};
%ins_ty_3 = {'JUMPNZ','123'};

% ins = {'INC128','R1','0','0';
%         'ADDI','R4','26','0';
%         'LOAD','R7','R4','0';
%         'ADDI','R4','1','0';
%         'LOAD','R8','R4','0';
%         'ADDH','R9','R7','1';
%         'ADDL','R9','R7','2';
%         'ADDH','R9','R8','1';
%         'ADDI','R4','1','0';
%         'LOAD','R7','R4','0';
%         'ADDI','R4','1','0';
%         'LOAD','R8','R4','0';
%         'ADDH','R9','R7','2';
%         'ADDL','R9','R7','4';
%         'ADDH','R9','R8','2';
%         'ADDI','R4','1','0';
%         'LOAD','R7','R4','0';
%         'ADDI','R4','1','0';
%         'LOAD','R8','R4','0';
%         'ADDH','R9','R7','1';
%         'ADDL','R9','R7','2';
%         'ADDH','R9','R8','1';
%         'SHIFTR','R9','4','0';
%         'STORE','R1','R9','0';
%         'PAUSE','0','0','0'};

ins = {'INC128','R1','0','0';
        'INC128','R1','0','0';
        'ADDI','R2','3','0';
        'CLEAR','R3','0','0';
        'ADDI','R3','3','0';
        'CLEAR','R4','0','0';
        'INC128','R4','0','0';
        'ADD','R4','R5','0';
        'ADD','R4','R6','0';
        'LOAD','R7','R4','0';
        'ADDI','R4','1','0';
        'LOAD','R8','R4','0';
        'ADDH','R9','R7','1';
        'ADDL','R9','R7','2';
        'ADDH','R9','R8','1';
        'ADDI','R4','3','0';
        'LOAD','R7','R4','0';
        'ADDI','R4','1','0';
        'LOAD','R8','R4','0';
        'ADDH','R9','R7','2';
        'ADDL','R9','R7','4';
        'ADDH','R9','R8','2';
        'ADDI','R4','3','0';
        'LOAD','R7','R4','0';
        'ADDI','R4','1','0';
        'LOAD','R8','R4','0';
        'ADDH','R9','R7','1';
        'ADDL','R9','R7','2';
        'ADDH','R9','R8','1';
        'SHIFTR','R9','4','0';
        'STORE','R1','R9','0';
        'CLEAR','R9','0','0';
        'ADDI','R1','1','0';
        'ADDI','R6','1','0';
        'SUBI','R3','1','0';
        'JUMPNZ','6','0','0';%///
        'CLEAR','R6','0','0';
        'ADDI','R5','3','0';
        'ADDI','R5','1','0';
        'ADDI','R5','3','0';
        'ADDI','R5','1','0';
        'SUBI','R2','1','0';
        'JUMPNZ','4','0','0';
        'PAUSE','0','0','0';
  };      

opcodes = {'ADDH','ADDL','ADD','ADDI','CLEAR','SHIFTL','SHIFTR','LOAD','INC128','STORE','SUBI','JUMPNZ','PAUSE'...
            'R1','R2','R3','R4','R5','R6','R7','R8','R9','R10'};

decode = {[0 0 0 0 1],[0 0 0 1 0],[0 0 0 1 1],[0 0 1 0 1],[0 0 1 0 0],[0 0 1 1 1],...
          [0 0 1 1 0],[0 1 0 0 0],[0 1 0 0 1],[0 1 0 1 0],[0 1 0 1 1],[0 1 1 0 0],[1 1 1 1 1]...
          [0 0 0 1],[0 0 1 0],[0 0 1 1],[0 1 0 0],[0 1 0 1],[0 1 1 0],[0 1 1 1],[1 0 0 0],[1 0 0 1],[1 0 1 0]};

dic = containers.Map(opcodes,decode);

len = size(ins,1);
temp = zeros(len,16);
temp16 = zeros(1,len);
temp8 = zeros(2,len);

for i=1:len
    temp(i,1:5) = dic(char(ins(i,1)));
    
    if(strcmp(char(ins(i,1)),'PAUSE'))
        temp(i,6:16) = de2bi(str2num(char(ins(i,2))),11,'left-msb');
    elseif (strcmp(char(ins(i,1)),'JUMPNZ'))
        temp(i,6:16) = de2bi(str2num(char(ins(i,2))),11,'left-msb');
    else
        temp(i,6:9) = dic(char(ins(i,2)));
        if(isKey(dic,char(ins(i,3))))
            temp(i,10:13) = dic(char(ins(i,3)));
            temp(i,14:16) = de2bi(str2num(char(ins(i,4))),3,'left-msb');
        else
            temp(i,10:16) = de2bi(str2num(char(ins(i,3))),7,'left-msb');
        end
    end
    
    temp16(1,i) = bi2de(temp(i,:),'left-msb');
    
    temp8(1,i) = bi2de(temp(i,1:8),'left-msb');
    temp8(2,i) = bi2de(temp(i,9:16),'left-msb');
end


temp16 = temp16(:)
temp8 = temp8(:)



%img = [1 2 3 4;5 6 7 8;9 10 11 12;13 14 15 16];
img = randi(8,8)
img1 = img';


transmit = [temp8; img1(:)]





