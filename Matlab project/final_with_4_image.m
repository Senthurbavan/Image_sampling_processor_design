
close all;
clear all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('setting up Image');


image_512 = imread('liftingbody.png');

imshow(mat2gray(image_512));

[m,n] = size(image_512);

im_padded = zeros(m+2,n+2);
poc_sampled = zeros(m/2,m/2);
Matlab_sampled = zeros(m/2,m/2);

Matlab_sampled_1 = zeros(m/4,n/4);
Matlab_sampled_2 = zeros(m/4,n/4);
Matlab_sampled_3 = zeros(m/4,n/4);
Matlab_sampled_4 = zeros(m/4,n/4);

for i=1:m
    im_padded(i+1,:) = [image_512(i,1),image_512(i,:),image_512(i,n)];
end
im_padded(1,:) = im_padded(2,:);
im_padded(m+2,:) = im_padded(m+1,:);

image1 = im_padded(1:258,1:258);
tx_im_1 = image1';
image2 = im_padded(1:258,257:514);
tx_im_2 = image2';
image3 = im_padded(257:514,1:258);
tx_im_3 = image3';
image4 = im_padded(257:514,257:514);
tx_im_4 = image4';

%%figure
%subplot(2,2,1), imshow(mat2gray(image1));
%subplot(2,2,2), imshow(mat2gray(image2));
%subplot(2,2,3), imshow(mat2gray(image3));
%subplot(2,2,4), imshow(mat2gray(image4));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Setting up Instructions');


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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('press any key to send Instructions');
pause

s = serial('COM26','BaudRate',115200);
fopen(s);

for i=1:1:length(temp8) 
    fwrite(s,temp8(i),'uint8');
end

fclose(s);
delete(s);
clear s;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('press any key to send Image1');
pause

s = serial('COM26','BaudRate',115200);

tx_im_1 = tx_im_1(:);

fopen(s);

for w=1:1:length(tx_im_1) 
    fwrite(s,tx_im_1(w),'uint8');
end

fclose(s);
delete(s);
clear s;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('waiting for sampled image1');

s = serial('COM26','BaudRate',115200);
s.InputbufferSize=256*256*4;
s.OutputbufferSize=256*256*4;
s.Timeout=20;
s.StopBits=1;
s.Parity = 'none';
fopen(s);
poc_sampled1 =fread(s,16384,'uint8');

fclose(s);
delete(s);
clear s;

poc_sampled1 = vec2mat(poc_sampled1,128);
poc_sampled(1:128,1:128) = poc_sampled1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('press any key to send Image2');
pause

tx_im_2 = tx_im_2(:);

s = serial('COM26','BaudRate',115200);

fopen(s);

for i=1:1:length(tx_im_2) 
    fwrite(s,tx_im_2(i),'uint8');
end

fclose(s);
delete(s);
clear s;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('waiting for sampled image2');

s = serial('COM26','BaudRate',115200);
s.InputbufferSize=256*256*4;
s.OutputbufferSize=256*256*4;
s.Timeout=20;
s.StopBits=1;
s.Parity = 'none';
fopen(s);
poc_sampled2 =fread(s,16384,'uint8');

fclose(s);
delete(s);
clear s;

poc_sampled2 = vec2mat(poc_sampled2,128);
poc_sampled(1:128,129:256) = poc_sampled2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('press any key to send Image3');
pause

tx_im_3 = tx_im_3(:);

s = serial('COM26','BaudRate',115200);

fopen(s);

for i=1:1:length(tx_im_3) 
    fwrite(s,tx_im_3(i),'uint8');
end

fclose(s);
delete(s);
clear s;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('waiting for sampled image3');

s = serial('COM26','BaudRate',115200);
s.InputbufferSize=256*256*4;
s.OutputbufferSize=256*256*4;
s.Timeout=20;
s.StopBits=1;
s.Parity = 'none';
fopen(s);
poc_sampled3 =fread(s,16384,'uint8');

fclose(s);
delete(s)
clear s

poc_sampled3 = vec2mat(poc_sampled3,128);
poc_sampled(129:256,1:128) = poc_sampled3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('press any key to send Image4');
pause

tx_im_4 = tx_im_4(:);

s = serial('COM26','BaudRate',115200);

fopen(s);

for i=1:1:length(tx_im_4) 
    fwrite(s,tx_im_4(i),'uint8');
end

fclose(s);
delete(s)
clear s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('waiting for sampled image4');

s = serial('COM26','BaudRate',115200);
s.InputbufferSize=256*256*4;
s.OutputbufferSize=256*256*4;
s.Timeout=20;
s.StopBits=1;
s.Parity = 'none';
fopen(s);
poc_sampled4 =fread(s,16384,'uint8');

fclose(s);
delete(s)
clear s

poc_sampled4 = vec2mat(poc_sampled4,128);
poc_sampled(129:256,129:256) = poc_sampled4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for i=1:m/4
    for j=1:n/4
        Matlab_sampled_1(i,j) = floor((1/16)*(1*image1(2*i-1,2*j-1)+ 2*image1(2*i-1,2*j)+ 1*image1(2*i-1,2*j+1)+... 
                                              2*image1(2*i,2*j-1)+   4*image1(2*i,2*j)+   2*image1(2*i,2*j+1)+...
                                              1*image1(2*i+1,2*j-1)+ 2*image1(2*i+1,2*j)+ 1*image1(2*i+1,2*j+1)));
    end
end
Matlab_sampled(1:128,1:128) = Matlab_sampled_1;

for i=1:m/4
    for j=1:n/4
        Matlab_sampled_2(i,j) = floor((1/16)*(1*image2(2*i-1,2*j-1)+ 2*image2(2*i-1,2*j)+ 1*image2(2*i-1,2*j+1)+... 
                                              2*image2(2*i,2*j-1)+   4*image2(2*i,2*j)+   2*image2(2*i,2*j+1)+...
                                              1*image2(2*i+1,2*j-1)+ 2*image2(2*i+1,2*j)+ 1*image2(2*i+1,2*j+1)));
    end
end

Matlab_sampled(1:128,129:256) = Matlab_sampled_2;

for i=1:m/4
    for j=1:n/4
        Matlab_sampled_3(i,j) = floor((1/16)*(1*image3(2*i-1,2*j-1)+ 2*image3(2*i-1,2*j)+ 1*image3(2*i-1,2*j+1)+... 
                                              2*image3(2*i,2*j-1)+   4*image3(2*i,2*j)+   2*image3(2*i,2*j+1)+...
                                              1*image3(2*i+1,2*j-1)+ 2*image3(2*i+1,2*j)+ 1*image3(2*i+1,2*j+1)));
    end
end
Matlab_sampled(129:256,1:128) = Matlab_sampled_3;

for i=1:m/4
    for j=1:n/4
        Matlab_sampled_4(i,j) = floor((1/16)*(1*image4(2*i-1,2*j-1)+ 2*image4(2*i-1,2*j)+ 1*image4(2*i-1,2*j+1)+... 
                                              2*image4(2*i,2*j-1)+   4*image4(2*i,2*j)+   2*image4(2*i,2*j+1)+...
                                              1*image4(2*i+1,2*j-1)+ 2*image4(2*i+1,2*j)+ 1*image4(2*i+1,2*j+1)));
    end
end
Matlab_sampled(129:256,129:256) = Matlab_sampled_4;




poc_sampled = mat2gray(poc_sampled);
Matlab_sampled = mat2gray(Matlab_sampled);

figure;
subplot(1,2,1), imshow(Matlab_sampled);
subplot(1,2,2), imshow(poc_sampled);

ssd = sum(sum((Matlab_sampled - poc_sampled).^2))


