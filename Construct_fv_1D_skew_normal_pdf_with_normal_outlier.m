%**************************************************************************
%--- Skew normal distributions with outlier
%--- Author : Jen-Hao Chen(a) and  Wen-Liang Hung(b)
%---          a: Institute for Computational and Modeling Science, National 
%---             Tsing Hua University, Hsin-Chu, Taiwan
%---          b: Center of Teacher Education, National Tsing Hua University
%---             Hsin-Chu, Taiwan 
%**************************************************************************


n    =  9 + 1   ;     %--- 9 skew normal with 1 normal outlier


xmin = -10.0 ;
xmax =  10.0 ;
h    =  0.01 ;


cx = [ xmin : h : xmax ] ;
nx = ( xmax - xmin ) / h + 1 ;

extcx = [ xmin-100 : h : xmax+100 ] ;

ng = nx ;              %--- Number of grid points

fv  = zeros(nx,1) ;    %--- CURRENT function values 
ofv = zeros(nx,n) ;    %--- ORIGINAL function values 



%---Construct function values
SkewLambda  = [  0    , 0   , 0    ,  5  ,  5     ,  5    ,  -5    ,  -5    , -5   ];   %---skewness  (any number)
SkewXi      = [ -0.25 , 0   , 0.25 ,  1  ,  1.25  ,  1.5  ,  -1.5  ,  -1.25 , -1   ];   %---location  (any number) 
SkewSigma   = [  0.5  , 0.5 , 0.5  ,  1  ,  1     ,  1    ,   1    ,   1    ,  1   ];   %---scale  (any positive number)
NormalMu    = 7;
NormalSigma = 0.5;


for i = 1 : 9
    SkewPhi = exp( -0.5*(extcx.^2) ) / sqrt(2*pi);   
    for j = 1 : nx
        ct    = ( cx(j) - SkewXi(i) ) / SkewSigma(i);
        intid = ceil( ( SkewLambda(i)*(cx(j)-SkewXi(i))/SkewSigma(i) - (xmin-100) ) / h ); 
        ofv( j , i ) = ( 2./SkewSigma(i) )*( exp(-0.5*(ct^2))/sqrt(2*pi) )*( sum( SkewPhi(1:intid) )*h )  ;
    end
end


ofv( : , 10 ) = exp( - ((cx-NormalMu).^2) / (2*NormalSigma^2) ) / ( NormalSigma*sqrt(2*pi) );



figure(1)
for i = 1 : 3
    h = plot( cx , ofv(:,i) , 'r' ); set(h, 'LineWidth',1);
    hold on
end
for i = 4 : 6
    h = plot( cx , ofv(:,i) , 'g' ); set(h, 'LineWidth',1);
    hold on
end
for i = 7 : 9
    h = plot( cx , ofv(:,i) , 'b' ); set(h, 'LineWidth',1);    
    hold on
end
for i = 7 : 9
    h = plot( cx , ofv(:,i) , 'b' ); set(h, 'LineWidth',1);    
    hold on
end
for i = 10 : 10
    h = plot( cx , ofv(:,i) , 'k' ); set(h, 'LineWidth',1);    
    hold on
end
axis( [ -5 , 10 , 0 , 0.85 ] );
filename = strcat( 'Fig_skew_outlier_pdf.eps' ) ;
saveas(gcf,filename,'psc2') ; 






