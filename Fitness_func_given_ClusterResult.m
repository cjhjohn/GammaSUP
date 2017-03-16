%**************************************************************************
%--- Compute the fitness of data clustering
%--- Ref    : DW vvan der Merwe and AP Engelbrecht,
%---          Data Clustering using Particle Swarm Optimization 
%--- Author : Jen-Hao Chen(a) and  Wen-Liang Hung(b)
%---          a: Institute for Computational and Modeling Science, National 
%---             Tsing Hua University, Hsin-Chu, Taiwan
%---          b: Center of Teacher Education, National Tsing Hua University
%---             Hsin-Chu, Taiwan 
%**************************************************************************
function fitness = Fitness_func_given_ClusterResult( wf_old , ofv , h , Dim , Object_cluster , NumCluster , Criterion )

SizeData  = size( ofv ); 
NumGrid   = SizeData(1);   %---Number of grid
NumFunc   = SizeData(2);   %---Number of function


centroid           = zeros( NumGrid , NumCluster ); %---produce the cluster centroid
ClusterNumData     = zeros( NumCluster , 1 );       %---The number of data in each cluster
ClusterDisDataCent = zeros( NumCluster,1 );         %---The sum of the distance bewteen data and its own cnetroid


for i = 1 : NumCluster   
    ClusterNumData(i) = 0;
    coordinate = zeros( NumGrid , 1 );
    for j = 1 : NumFunc  
        if( Object_cluster(j) == i )
            coordinate = coordinate + ofv(:,j) ;
            ClusterNumData( i ) = ClusterNumData( i ) + 1 ;
        end    
    end
    centroid( : , i ) = coordinate / ClusterNumData( i );
end


for i = 1 : NumFunc
    Idx = Object_cluster( i ) ;         
    SE  = ( Compute_distance( ofv(:,i) , centroid(:,Idx) , h , Dim , 'L2' ) ) ^ 2  ; 
    ClusterDisDataCent( Idx ) = ClusterDisDataCent( Idx ) + SE ;
end


%===Sum of squared error (SSE)=============================================
SSE = sum( ClusterDisDataCent ) ;   
%==========================================================================


%===Variance ratio criterion (VRC)=========================================
mean  = sum( transpose(ofv) )' / NumFunc;   

Inter = 0;
for i = 1 : NumCluster
    if( ClusterNumData(i)~=0 )
        Inter = Inter + ClusterNumData( i ) *  ( Compute_distance( centroid(:,i) , mean , h , Dim , 'L2' ) ) ^ 2 ;             
    end    
end

VRC = ( Inter / SSE ) * ( NumFunc - NumCluster ) / ( NumCluster-1 );  
%==========================================================================


if( strcmp( Criterion , 'SSE' ) ), fitness = SSE ; end   
if( strcmp( Criterion , 'VRC' ) ), fitness = VRC ; end   



