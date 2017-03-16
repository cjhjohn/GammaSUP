%**************************************************************************
%--- Construct 3D kernel functions for images
%--- Ref    : Clustering probability distributions,
%---          Journal of Applied Statistics, Volume 37, Issue 11, 2010
%--- Author : Jen-Hao Chen(a) and  Wen-Liang Hung(b)
%---          a: Institute for Computational and Modeling Science, National 
%---             Tsing Hua University, Hsin-Chu, Taiwan
%---          b: Center of Teacher Education, National Tsing Hua University
%---             Hsin-Chu, Taiwan 
%**************************************************************************


clear all
format long
clc


syms x y z


n   = 20;         %--- Number of function
m   = 24576; %98304    %--- Number of pixel of each function
Dim = 3;          %--- Dimension 


image_num = char( '206' , '207' , '208' , '211' , '243' , ... 
                  '324' , '326' , '348' , '350' , '393' , ... 
                  '608' , '634' , '643' , '650' , '657' , ...
                  '738' , '746' , '764' , '774' , '776' ) ;


G_x = zeros(n,m);
G_y = zeros(n,m);
G_z = zeros(n,m);


for i = 1 : n
    filename = [ 'Image_RGB_' , image_num(i,:) , '.txt' ]
    [fid,message] = fopen( filename ,'r' ) ;
    G = fscanf( fid , '%g' , [ 3 , m ] ) ;
    G_x(i,:) = G(1,:) ; G_y(i,:) = G(2,:) ; G_z(i,:) = G(3,:) ;
    fclose(fid) ;
    
    fprintf( '\n %g ~ %g , %g  ~ %g , %g ~ %g' , min(G_x(i,:)) , max(G_x(i,:)) ,  min(G_y(i,:)) , max(G_y(i,:)) , min(G_z(i,:)) , max(G_z(i,:))   ) ;    
end    


%----RGB Compress ---------------------------------------------------------
G_x = G_x / 255.0 ;
G_y = G_y / 255.0 ;
G_z = G_z / 255.0 ;
%--------------------------------------------------------------------------


aver_x = zeros(n,1);
aver_y = zeros(n,1);
aver_z = zeros(n,1);
for i = 1 : n
    aver_x(i) = sum( G_x(i,:) ) / m ;
    aver_y(i) = sum( G_y(i,:) ) / m ;
    aver_z(i) = sum( G_z(i,:) ) / m ;
end  


MtxS = zeros(3,3,n);
for i = 1 : n
    sumxx = 0 ; sumxy = 0 ; sumxz = 0 ; sumyy = 0 ; sumyz = 0 ; sumzz = 0 ;    
    for j = 1 : m
        sumxx = sumxx + ( G_x(i,j)-aver_x(i) )^2 ;
        sumxy = sumxy + ( G_x(i,j)-aver_x(i) )*( G_y(i,j)-aver_y(i) ) ;
        sumxz = sumxz + ( G_x(i,j)-aver_x(i) )*( G_z(i,j)-aver_z(i) ) ;
        sumyy = sumyy + ( G_y(i,j)-aver_y(i) )^2 ;
        sumyz = sumyz + ( G_y(i,j)-aver_y(i) )*( G_z(i,j)-aver_z(i) ) ;
        sumzz = sumzz + ( G_z(i,j)-aver_z(i) )^2 ;
    end
    MtxS(1,1,i) = sumxx / m ;
    MtxS(1,2,i) = sumxy / m ; MtxS(2,1,i) = MtxS(1,2,i) ;
    MtxS(1,3,i) = sumxz / m ; MtxS(3,1,i) = MtxS(1,3,i) ;
    MtxS(2,2,i) = sumyy / m ;
    MtxS(2,3,i) = sumyz / m ; MtxS(3,2,i) = MtxS(2,3,i) ;
    MtxS(3,3,i) = sumzz / m ;   
end



InvS = zeros(3,3,n);
for i = 1 : n
    fprintf('\n i = %d , det(S) = %g' ,  i , det(MtxS(1:3,1:3,i)) );
    InvS(1:3,1:3,i) = inv( MtxS(1:3,1:3,i) ) ;
end



%--- Construct coefficent matrix ------------------------------------------
Coeff_image = zeros( m , 10 , n) ;
for i = 1 : n
    
    fprintf( '\n *. Start %d th function :' , i ) ;
    filename = [ 'Coeff_Mtx_Image_' , image_num(i,:) , '.txt' ] ;
    [fid,message] = fopen( filename ,'wt' );
    
    for j = 1 : m

        Coeff_image( j , 1 , i ) = InvS( 1,1,i ) ;     %---Coefficient of x^2
        Coeff_image( j , 2 , i ) = InvS( 2,2,i ) ;     %---Coefficient of y^2
        Coeff_image( j , 3 , i ) = InvS( 3,3,i ) ;     %---Coefficient of z^2
        Coeff_image( j , 4 , i ) = InvS( 2,1,i ) + InvS( 1,2,i ) ;     %---Coefficient of xy
        Coeff_image( j , 5 , i ) = InvS( 3,1,i ) + InvS( 1,3,i ) ;     %---Coefficient of xz      
        Coeff_image( j , 6 , i ) = InvS( 3,2,i ) + InvS( 2,3,i ) ;     %---Coefficient of yz       
        Coeff_image( j , 7 , i ) = - G_z(i,j)*( InvS( 3,1,i ) + InvS( 1,3,i ) ) ...     %---Coefficient of x  
                                   - G_y(i,j)*( InvS( 2,1,i ) + InvS( 1,2,i ) ) ...
                                   - G_x(i,j)*( InvS( 1,1,i ) + InvS( 1,1,i ) ) ;       
        Coeff_image( j , 8 , i ) = - G_z(i,j)*( InvS( 3,2,i ) + InvS( 2,3,i ) ) ...     %---Coefficient of y  
                                   - G_y(i,j)*( InvS( 2,2,i ) + InvS( 2,2,i ) ) ...
                                   - G_x(i,j)*( InvS( 1,2,i ) + InvS( 2,1,i ) ) ;  
        Coeff_image( j , 9 , i ) = - G_z(i,j)*( InvS( 3,3,i ) + InvS( 3,3,i ) ) ...     %---Coefficient of z       
                                   - G_y(i,j)*( InvS( 2,3,i ) + InvS( 3,2,i ) ) ...
                                   - G_x(i,j)*( InvS( 1,3,i ) + InvS( 3,1,i ) ) ; 
        Coeff_image( j ,10 , i ) = G_z(i,j)*( G_z(i,j)*InvS( 3,3,i ) + G_y(i,j)*InvS( 3,2,i ) + G_x(i,j)*InvS( 3,1,i ) ) + ...   %---Coefficient of constant
                                   G_y(i,j)*( G_z(i,j)*InvS( 2,3,i ) + G_y(i,j)*InvS( 2,2,i ) + G_x(i,j)*InvS( 2,1,i ) ) + ...
                                   G_x(i,j)*( G_z(i,j)*InvS( 1,3,i ) + G_y(i,j)*InvS( 1,2,i ) + G_x(i,j)*InvS( 1,1,i ) ) ;
    end
    
    
    %---Column major storage
    for k = 1 : 10
        for j = 1 : m
            fprintf( fid , '%20.10f' , Coeff_image( j, k, i ) );
            fprintf( fid , '\n' );
        end
    end
    fclose(fid) ;
    fprintf( '\n *. End %d th function :' , i ) ; 
        
end
%--------------------------------------------------------------------------


h    =   0.02 ; 
xmin =  -0.5 ;
xmax =   1.5 ;
ymin =  -0.5 ;
ymax =   1.5 ;
zmin =  -0.5 ;
zmax =   1.5 ;

cx = [ xmin : h : xmax ] ;
cy = cx ;
cz = cx ;
nx = ( xmax - xmin ) / h + 1 ;
ny = nx ;
nz = nx ;

%---window width h ---
tmp = (4./(2*Dim+1))^(1./(Dim+4)) ;
wwh = tmp * ( ( m )^( -1./(Dim+4) ) ) ;

ofv = zeros( nx * ny * nz , n ) ;


for inum = 1 : n
    
    tmpval1 = (-0.5)*(wwh^(-2));
    tmpval2 = ( ((det(MtxS(1:3,1:3,inum)))^(-0.5))/(m * (wwh^Dim) ) ) * ( (2*pi)^(-Dim/2) );
    tmpvec3 = zeros( nx , ny , nz );
    
    for k = 1 : nz
        tic;
        parfor j = 1 : ny    
            for i = 1 : nx
                tmpvec1 = [ cx(i)^2 ; cy(j)^2 ; cz(k)^2 ; cx(i)*cy(j) ; cx(i)*cz(k) ; cy(j)*cz(k) ; cx(i) ; cy(j) ; cz(k) ; 1.0 ] ;
                tmpvec2 = exp( tmpval1 * Coeff_image( 1:m , 1:10 , inum ) * tmpvec1 ) ;
                tmpvec3( i , j , k ) = tmpval2 * sum( tmpvec2 ) ;
            end    
        end
        comp_time = toc ;    
        fprintf( '\n Num of image : %4g,   k : %6g,   sum(k) : %g,   Elapsed time : %12.8f ' , inum , k , sum(sum(tmpvec3(:,:,k))) , comp_time ) ;
    end
    
    
    filename = [ 'Func_Val_Image_' , image_num(inum,:) , '.txt' ] ;
    [fid,message] = fopen( filename ,'wt' );
    for k = 1 : nz
        for j = 1 : ny    
            for i = 1 : nx
                curr_id = (k-1)*nx*ny+(j-1)*nx+i ;
                ofv( curr_id , inum ) = tmpvec3( i , j , k ) ;
                fprintf( fid , '%g' , tmpvec3( i , j , k ) );
                fprintf( fid , '\n' );
            end
        end
    end
    fclose(fid);        
    
    fprintf( '\n Integration of pdf %4g : %12.8f ' , inum , sum( ofv(:,inum) )*h^3 ) ;
        
end












