clc;
clear all;
s = serial('COM27','BaudRate',115200);

%data  = [40,123,18,7,3,66,58,64,22,94,36,99];
data1  = [40,65,18,91,3,166];
data2  = [58,93,21,132,36,63];

fopen(s);

for i=1:1:length(data2) 
    fwrite(s,data2(i),'uint8');
end

pause

fclose(s) 
delete(s)
clear s

s = serial('COM27','BaudRate',115200); 
s.InputbufferSize=256*256*4;
s.OutputbufferSize=256*256*4;
s.Timeout=10;
s.StopBits=1;
s.Parity = 'none';
fopen(s);
out =fread(s,12,'uint8');


fclose(s)
delete(s)
clear s