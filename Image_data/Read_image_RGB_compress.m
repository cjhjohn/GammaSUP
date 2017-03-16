%**************************************************************************
%--- Obtain RGB data
%--- Author : Jen-Hao Chen(a) and  Wen-Liang Hung(b)
%---          a: Institute for Computational and Modeling Science, National 
%---             Tsing Hua University, Hsin-Chu, Taiwan
%---          b: Center of Teacher Education, National Tsing Hua University
%---             Hsin-Chu, Taiwan 
%**************************************************************************

comppress_ratio = 0.5 ;

n = 20 ;

image_num = char( '206' , '207' , '208' , '211' , '243' , ... 
                  '324' , '326' , '348' , '350' , '393' , ... 
                  '608' , '634' , '643' , '650' , '657' , ...
                  '738' , '746' , '764' , '774' , '776' ) ;

for inum = 1 : n

    filename = [ image_num( inum,: ) , '.jpg' ];
    
    IM = imread( filename );
    IM = imresize( IM , comppress_ratio );

    im_size = size( IM );
    filename = [ 'Image_RGB_' , image_num( inum,: ) , '.txt' ];
    fid      = fopen( filename , 'w');
    count = 0 ;
    for i = 1 : im_size(1)
        for j = 1 : im_size(2)
            count = count + 1 ;            
            fprintf( fid, '%f %f %f' , IM(i,j,1) , IM(i,j,2) , IM(i,j,3) );              
            fprintf( fid, '\r\n' );
        end
    end
    fprintf( '\n *** count = %d , image size = %d ' , count , im_size(1)*im_size(2)  )
    fclose(fid);
    
end
