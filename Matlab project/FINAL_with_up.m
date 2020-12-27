close all;
clear all;

%ins_ty_1 = {'OPCODE','R1','R2','Scalar'};
%ins_ty_2 = {'OPCODE','R1','immediate'};
%ins_ty_3 = {'JUMPNZ','X'};

ins = {'ADDI','R1','17','0';
        'SHIFTL','R1','11','0';
        'INC128','R2','0','0';
        'CLEAR','R3','0','0';
        'INC128','R3','0','0';
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
        'INC128','R4','0','0';
        'LOAD','R7','R4','0';
        'ADDI','R4','1','0';
        'LOAD','R8','R4','0';
        'ADDH','R9','R7','2';
        'ADDL','R9','R7','4';
        'ADDH','R9','R8','2';
        'INC128','R4','0','0';
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
        'INC128','R5','0','0';
        'ADDI','R5','1','0';
        'INC128','R5','0','0';
        'ADDI','R5','1','0';
        'SUBI','R2','1','0';
        'JUMPNZ','4','0','0';
        'PAUSE','0','0','0'};

opcodes = {'ADDH','ADDL','ADD','ADDI','CLEAR','SHIFTL','SHIFTR','LOAD','INC128','STORE','SUBI','JUMPNZ','PAUSE'...
            'R1','R2','R3','R4','R5','R6','R7','R8','R9','R10'};

decode = {[0 0 0 0 1],[0 0 0 1 0],[0 0 0 1 1],[0 0 1 0 1],[0 0 1 0 0],[0 0 1 1 1],...
          [0 0 1 1 0],[0 1 0 0 0],[0 1 0 0 1],[0 1 0 1 0],[0 1 0 1 1],[0 1 1 0 0],[1 1 1 1 1]...
          [0 0 0 1],[0 0 1 0],[0 0 1 1],[0 1 0 0],[0 1 0 1],[0 1 1 0],[0 1 1 1],[1 0 0 0],[1 0 0 1],[1 0 1 0]};

dic = containers.Map(opcodes,decode);

len = size(ins,1);
temp = zeros(len,16);
%temp16 = zeros(1,len);
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
    
    %temp16(1,i) = bi2de(temp(i,:),'left-msb');
    
    temp8(1,i) = bi2de(temp(i,1:8),'left-msb');
    temp8(2,i) = bi2de(temp(i,9:16),'left-msb');
end


%temp16 = temp16(:);
temp8 = temp8(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img256_1 = imread('cameraman.tif');
[m,n] = size(img256_1); 
 
im_paded_1 = zeros(m+2,n+2);
img_sampled_1 = zeros(m/2,n/2);

for i=1:m
    im_paded_1(i+1,:) = [img256_1(i,1),img256_1(i,:),img256_1(i,n)];
end
im_paded_1(1,:) = im_paded_1(2,:);
im_paded_1(m+2,:) = im_paded_1(m+1,:);

img1 = im_paded_1';
transmit_1 = img1(:);

disp('press any key to send instructions');
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s = serial('COM26','BaudRate',115200);
fopen(s);

for i=1:1:length(temp8) 
    fwrite(s,temp8(i),'uint8');
end

fclose(s);
delete(s)
clear s

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('press any key to send image1');
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s = serial('COM26','BaudRate',115200);

fopen(s);

for f=1:1:length(transmit_1) 
    fwrite(s,transmit_1(f),'uint8');
end

fclose(s);
delete(s)
clear s

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('waiting for sampled image1');

s = serial('COM26','BaudRate',115200);
s.InputbufferSize=256*256*4;
s.OutputbufferSize=256*256*4;
s.Timeout=20;
s.StopBits=1;
s.Parity = 'none';
fopen(s);
out_1 =fread(s,16384,'uint8');

fclose(s);
delete(s)
clear s


for i=1:m/2
    for j=1:n/2
        img_sampled_1(i,j) = floor((1/16)*(1*im_paded_1(2*i-1,2*j-1)+ 2*im_paded_1(2*i-1,2*j)+ 1*im_paded_1(2*i-1,2*j+1)+... gaussian filter
                                         2*im_paded_1(2*i,2*j-1)+ 4*im_paded_1(2*i,2*j)+ 2*im_paded_1(2*i,2*j+1)+...
                                         1*im_paded_1(2*i+1,2*j-1)+ 2*im_paded_1(2*i+1,2*j)+ 1*im_paded_1(2*i+1,2*j+1)));
    end
end

img_sampled_1 = mat2gray(img_sampled_1);

pro_img = out_1;

processor_img = vec2mat(out_1,128);
processor_img = mat2gray(processor_img);

subplot(1,2,1),imshow(img_sampled_1);
subplot(1,2,2),imshow(processor_img);

ssd = sum(sum((img_sampled_1 - processor_img).^2))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


img256_2 = imread('testpat1.png');
[m,n] = size(img256_2); 
 
im_paded_2 = zeros(m+2,n+2);
img_sampled_2 = zeros(m/2,n/2);

for i=1:m
    im_paded_2(i+1,:) = [img256_2(i,1),img256_2(i,:),img256_2(i,n)];
end
im_paded_2(1,:) = im_paded_2(2,:);
im_paded_2(m+2,:) = im_paded_2(m+1,:);

img2 = im_paded_2';
transmit_2 = img2(:);

disp('press any key to send image2');
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s = serial('COM26','BaudRate',115200);

fopen(s);

for w=1:1:length(transmit_2) 
    fwrite(s,transmit_2(w),'uint8');
end

fclose(s);
delete(s)
clear s

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('waiting for sampled image2');

s = serial('COM26','BaudRate',115200);
s.InputbufferSize=256*256*4;
s.OutputbufferSize=256*256*4;
s.Timeout=20;
s.StopBits=1;
s.Parity = 'none';
fopen(s);
out_2 =fread(s,16384,'uint8');

fclose(s);
delete(s)
clear s


for i=1:m/2
    for j=1:n/2
        img_sampled_2(i,j) = floor((1/16)*(1*im_paded_2(2*i-1,2*j-1)+ 2*im_paded_2(2*i-1,2*j)+ 1*im_paded_2(2*i-1,2*j+1)+... gaussian filter
                                         2*im_paded_2(2*i,2*j-1)+ 4*im_paded_2(2*i,2*j)+ 2*im_paded_2(2*i,2*j+1)+...
                                         1*im_paded_2(2*i+1,2*j-1)+ 2*im_paded_2(2*i+1,2*j)+ 1*im_paded_2(2*i+1,2*j+1)));
    end
end

img_sampled_2 = mat2gray(img_sampled_2);

pro_img_2 = out_2;

processor_img_2 = vec2mat(out_2,128);
processor_img_2 = mat2gray(processor_img_2);

figure;
subplot(1,2,1),imshow(img_sampled_2);
subplot(1,2,2),imshow(processor_img_2);

ssd = sum(sum((img_sampled_2 - processor_img_2).^2))

