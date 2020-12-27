
clear all;
% Image to text conversion
% Read the image from the file

%img1D = [0, 8320, 18560,22659, 20616,-2048,0, 0, 0, 0];
%img1D = [0, 8320, 18560,10980, 20648, -2048, 0, 0, 0, 0];
%img1D = [0, 8320, 18560,10980, 20648,16904,14978,12803,6696,20648,10375,20640,-2048, 0, 0, 0, 0];
%img1D = [0, 8320, 18560,10980, 20648,16904,14978,12803,6696,6696,7072,2607,5034, 20640, 10375, 20664, -2048];
%img1D = [0,8320,8448,10370,14472,2318,20752,-2048];
%img1D = [0,-2048,-2048];
%img1D = [0,8320,18560,20616,-2048];
%img1D = [0,8320,18560,22661,22658,24583,22661,20616,-2048];
%img1D = [0,8320,18560,22661,8448,24583,10369,20616,-2048];


%img1D = [0,18560,10778,17312,10753,17440,3257,5306,3265,10753,17312,10753,17440,3258,5308,3266,10753,17312,10753,17440,3257,5306,3265,13444,20680,-2048,...
           %258,772,1286,1800,2314,2828,3342,3856];
           
 img1D = [0,2,4,4,6,23,87,34,66,90,44];
           
           
% Decimal to Hex value conversion
imgID=img1D';

% New txt file creation
fid = fopen('ouputHexp.coe', 'wt');
% Hex value write to the txt file
fprintf(fid,'memory_initialization_radix=10;\n');
fprintf(fid,'memory_initialization_vector=\n');
fprintf(fid, '%d\n', img1D);
% Close the txt file
fclose(fid);


%close all;
%clear all
