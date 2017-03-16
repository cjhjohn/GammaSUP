%**************************************************************************
%--- Bivariate beta distribution
%--- Author : Jen-Hao Chen(a) and  Wen-Liang Hung(b)
%---          a: Institute for Computational and Modeling Science, National 
%---             Tsing Hua University, Hsin-Chu, Taiwan
%---          b: Center of Teacher Education, National Tsing Hua University
%---             Hsin-Chu, Taiwan 
%**************************************************************************


n    =  9   ;     %--- Number of function


xmin = 0.0 ;  xmax = 1.0 ;
ymin = 0.0 ;  ymax = 1.0 ;
h    = 0.001 ;


cx = xmin : h : xmax ;
cx = cx( 2 : length(cx)-1 );   %---delete 0 and 1

cy = ymin : h : ymax ;
cy = cy( 2 : length(cy)-1 );   %---delete 0 and 1

[xx,yy] = meshgrid(cx,cy);

nx = length(cx);
ny = length(cy);
ng = nx*ny ;                 %--- Number of grid points

fv     = zeros(ng,1) ;    
ofv    = zeros(ng,n) ;    
ofv_2D = zeros(nx,ny,n) ; 


%---Construct function values
pa  = [ 0.4 0.7 0.9   1.2  1    1.6   4  5  8  ];
pb  = [ 1   1.2 1.1   1    1.5  1.6   4  6  8  ];
pc  = [ 1   1   1     2    2.5  3     5.5    5  8  ];



for i = 1 : n
    B = gamma(pa(i))*gamma(pb(i))*gamma(pc(i))/gamma(pa(i)+pb(i)+pc(i));
    ofv_2D(:,:,i) = transpose(    ( xx.^(pa(i)-1) ).*( yy.^(pb(i)-1) ).*( (1-xx).^(pb(i)+pc(i)-1) ).*( (1-yy).^(pa(i)+pc(i)-1) )  ...
                               ./ ( B * ( (1-xx.*yy).^(pa(i)+pb(i)+pc(i)) ) ) );    
end



for i = 1 : n
    surf( xx , yy , ofv_2D(:,:,i) );  shading interp
    xlabel('x');
    xlabel('y');
    filename = strcat( 'Fig_2D_beta_',num2str(i),'_pdf.eps' ) ;
    saveas(gcf,filename,'psc2') ; 
    hold off
end


for i = 1 : n
    for j = 1 : nx
        for k = 1 : ny
            ofv((j-1)*ny+k,i) = ofv_2D(j,k,i);
        end
    end
end
