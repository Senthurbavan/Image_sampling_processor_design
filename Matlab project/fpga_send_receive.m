clc;
clear all;
S=serial('COM27','BaudRate',115200);
%image=uint8(rgb2gray(imread('kalaam.jpeg')));
image=randi(255,3,256);
%ins=[24, 85, 32, 53, 8, 0, 40, 3, 56, 17, 64, 2, 72, 51, 40, 3, 64, 2, 48, 0, 32, 83, 80, 85, 40, 5, 64, 2, 88, 85, 40, 5, 56, 17, 64, 1, 64, 2, 24, 85, 24, 85, 40, 5, 56, 17, 64, 1, 64, 2, 96, 0, 104, 0, 128, 1];
%ins=[72,5,40,5,56,17,64,1,104,0,128,1];
%ins=[104,86,128,1];
%m=[bi2de([0 0 1 0 0 0 0 0],'left-msb'),bi2de([1 0 0 0 0 0 0 0],'left-msb'),bi2de([0 1 0 0 1 0 0 0],'left-msb'),bi2de([1 0 0 0 0 0 0 0],'left-msb'),bi2de([0 1 0 1 0 0 0 0],'left-msb'),bi2de([1 0 0 0 1 0 0 0],'left-msb'),bi2de([1 1 1 1 1 0 0 0],'left-msb'),bi2de([0 0 0 0 0 0 0 0],'left-msb')];
%th=[bi2de([0 0 1 0 0 0 0 0],'left-msb'),bi2de([0 0 1 1 0 0 0 0],'left-msb'),bi2de([0 1 0 1 1 0 0 0],'left-msb'),bi2de([0 0 1 1 0 0 1 1],'left-msb'),bi2de([0 0 1 0 0 0 0 0],'left-msb'),bi2de([0 1 1 0 0 0 1 1],'left-msb'),bi2de([0 1 1 0 1 0 0 0],'left-msb'),bi2de([0 1 0 1 0 1 0 1],'left-msb'),bi2de([0 1 0 0 0 0 0 0],'left-msb'),bi2de([0 1 0 1 0 0 0 0],'left-msb'),128,1];
m=[104,51,128,1,128,1,128,1,128,1,128,1,128,1,128,1,128,1];

fopen(S);

for i=1:18;
    fwrite(S,m(i),'uint8');
end



pause
%for j=1:3;
 %   for i=1:256;
  %  fwrite(S,image(j,i),'uint8');
   % end
%end


%end

fclose(S)
delete(S)
clear S

pause;


S=serial('COM30','BaudRate',115200);
S.InputbufferSize=256*256*4;
S.OutputbufferSize=256*256*4;
%S.Timeout=10;
%S.StopBits=1;
%S.Parity = 'none';
fopen(S);
out =fread(S,25,'uint8');


fclose(S)
delete(S)
clear S

%imout=zeros(128,128);



%b=a-imout;