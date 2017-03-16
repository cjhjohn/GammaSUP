%**************************************************************************
%--- Author : Jen-Hao Chen(a) and  Wen-Liang Hung(b)
%---          a: Institute for Computational and Modeling Science, National 
%---             Tsing Hua University, Hsin-Chu, Taiwan
%---          b: Center of Teacher Education, National Tsing Hua University
%---             Hsin-Chu, Taiwan 
%**************************************************************************
function sol = Compute_distance( f1 , f2 , h , Dim , NormP )

if( strcmp(Dim,'1D') ), mesh = h ;         end
if( strcmp(Dim,'2D') ), mesh = h * h ;     end
if( strcmp(Dim,'3D') ), mesh = h * h * h ; end


switch NormP
    case{ 'L1' }
        sol = mesh * sum( abs( f1 - f2 ) );   %---L1
    case{ 'L2' }    
        sol = sqrt( mesh * sum( ( f1 - f2 ).^2 ) ) ;   %---L2
end
