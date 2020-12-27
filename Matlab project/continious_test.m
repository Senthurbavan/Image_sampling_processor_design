close all
clear all


data1  = [40,55,18,78,3,64];
data2  = [58,110,21,110,36,110];

%data1 = temp8;
%data2  = transmit;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s = serial('COM27','BaudRate',115200);
fopen(s);

for i=1:1:length(data1) 
    fwrite(s,data1(i),'uint8');
end
fclose(s) 
delete(s)
clear s

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = serial('COM27','BaudRate',115200);
fopen(s);

for i=1:1:length(data2) 
    fwrite(s,data2(i),'uint8');
end
fclose(s) 
delete(s)
clear s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = serial('COM27','BaudRate',115200); 
s.InputbufferSize=256*256*4;
s.OutputbufferSize=256*256*4;
s.Timeout=20;
s.StopBits=1;
s.Parity = 'none';
fopen(s);
out =fread(s,12,'uint8');

fclose(s)


delete(s)
clear s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



















