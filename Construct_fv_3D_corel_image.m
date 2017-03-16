%**************************************************************************
%--- Clustering 20 images from COREL image database
%--- 
%--- The steps to run this case :
%--- Step.1 Under "Corel 20 images" folder, run Read_image_RGB_compress.m 
%--- Step.2 Under "Corel 20 images" folder, run Construct_function_3D_image_kernel.m
%--- Step.3 Copy the files "Func_Val_Image_XXX.txt" from "Corel 20 images" folder
%---        to current folder. 
%---
%--- Author : Jen-Hao Chen(a) and  Wen-Liang Hung(b)
%---          a: Institute for Computational and Modeling Science, National 
%---             Tsing Hua University, Hsin-Chu, Taiwan
%---          b: Center of Teacher Education, National Tsing Hua University
%---             Hsin-Chu, Taiwan 
%**************************************************************************


n   = 20;            %--- Number of function
Dim = '3D';          %--- Dimension


%-----Test CorelDB 1000 20 images -----------------------------------------
image_num = char( '206' , '207' , '208' , '211' , '243' , ... 
                  '324' , '326' , '348' , '350' , '393' , ... 
                  '608' , '634' , '643' , '650' , '657' , ...
                  '738' , '746' , '764' , '774' , '776' ) ;
%--------------------------------------------------------------------------
h    =   0.02 ; 
xmin =  -0.5 ;
xmax =   1.5 ;
ymin =  -0.5 ;
ymax =   1.5 ;
zmin =  -0.5 ;
zmax =   1.5 ;
cx = xmin : h : xmax ;
cy = cx ;
cz = cx ;
nx = ( xmax - xmin ) / h + 1 ;
ny = nx ;
nz = nx ;              
%==========================================================================  

ng  = nx*ny*nz ;   %---Num of grid
ofv = zeros( ng , n ) ;
fv  = zeros( ng , 1 ) ;    %--- CURRENT function values 


for i = 1 : n
    filename = [ '.\Image_data\Func_Val_Image_' , image_num(i,:) , '.txt' ];  
    [fid,message] = fopen( filename ,'r' ) ;
    G = fscanf( fid , '%g' , [ 1 , ng ] ) ;
    ofv( : , i ) = G' ;
    fclose(fid) ;
end    


for i = 1 : n
    fprintf('\n i = %d , integral = %g ' , i , sum(ofv( : , i ))*h*h*h );    
end    







