%**************************************************************************
%--- Plot the results of the case "Skew normal distributions"
%--- Author : Jen-Hao Chen(a) and  Wen-Liang Hung(b)
%---          a: Institute for Computational and Modeling Science, National 
%---             Tsing Hua University, Hsin-Chu, Taiwan
%---          b: Center of Teacher Education, National Tsing Hua University
%---             Hsin-Chu, Taiwan 
%**************************************************************************

n    =  9   ;     %--- Number of function


xmin = -10.0 ;
xmax =  10.0 ;
h    =  0.01 ;


cx =  xmin : h : xmax ;
nx = ( xmax - xmin ) / h + 1 ;

extcx = xmin-100 : h : xmax+100 ;

ng = nx ;                 %--- Number of grid points



figure(1)

for ii = 1 : n
    
    if( Object_cluster(ii)==1 ), ph = plot( cx, ofv(:,ii) , 'r' ) ; set(ph, 'LineWidth',1); end 
    if( Object_cluster(ii)==2 ), ph = plot( cx, ofv(:,ii) , 'g' ) ; set(ph, 'LineWidth',1); end
    if( Object_cluster(ii)==3 ), ph = plot( cx, ofv(:,ii) , 'b' ) ; set(ph, 'LineWidth',1); end
    axis( [ -5.5 , 5.5 , 0 , 0.85 ] )
    hold on

end 
filename = strcat( 'Fig_skew_pdf.eps' ) ;
saveas(gcf,filename,'psc2') ; 
hold off


figure(2)
for ii = 1 : n
    
    fv = zeros(nx,1);
    for kk = 1 : n
        fv = fv + wf_old(ii,kk)*ofv(:,kk);
    end    
    
    if( Object_cluster(ii)==1 ), ph = plot( cx, fv , 'r' ) ; set(ph, 'LineWidth',1); end 
    if( Object_cluster(ii)==2 ), ph = plot( cx, fv , 'g' ) ; set(ph, 'LineWidth',1); end
    if( Object_cluster(ii)==3 ), ph = plot( cx, fv , 'b' ) ; set(ph, 'LineWidth',1); end
    axis( [ -5.5 , 5.5 , 0 , 0.85 ] );
        
    hold on

end 
filename = strcat( 'Fig_skew_final.eps' ) ;
saveas(gcf,filename,'psc2') ; 
hold off


