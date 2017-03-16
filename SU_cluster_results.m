%**************************************************************************
%--- Classify the functions
%--- Ref    : DW vvan der Merwe and AP Engelbrecht,
%---          Data Clustering using Particle Swarm Optimization 
%--- Author : Jen-Hao Chen(a) and  Wen-Liang Hung(b)
%---          a: Institute for Computational and Modeling Science, National 
%---             Tsing Hua University, Hsin-Chu, Taiwan
%---          b: Center of Teacher Education, National Tsing Hua University
%---             Hsin-Chu, Taiwan 
%**************************************************************************
function  [ Object_cluster , NumCluster ] = SU_cluster_results( d , n )

class   = zeros(n,n) ;
for ii = 1 : n
    class(ii,1) = ii ;
end    

r = sum(sum(d))/(n*n);%---averaged distance

for ii = 1 : n
    for jj = ii+1 : n
        
        if(  d(ii,jj)/r  < 1.0e-4 )
%            ~~~~~~~~~~                  
            rr = ii ;
            is_save = 'N';
            
            %--- Check whether has been saved, and record its row index ---
            for kk = 1:n
                for zz = 1:n
                    if( class(kk,zz)==ii )
                        rr = kk;
                        is_save = 'Y';
                        break;
                    end
                end
                if( is_save == 'Y'), break; end;
            end            
            
            for cc = 1 : n
                if( class(rr,cc)==jj ), break; end
                if( class(rr,cc)==0 )
                    class(rr,cc) = jj ;
                    class(jj,:)  = 0  ;                 
                    break;
                end    
            end                
        end
             
    end    
end
%--------------------------------------------------------------------------


%--- Shows the convergence results (Number) -------------------------------
NumCluster = 0;
for ii = 1 : n
    if( class(ii,1)==0 ), continue; end;
    NumCluster = NumCluster + 1 ;
    class_set = '{';
    for jj = 1 : n
        if( class(ii,jj)==0 ), break; end;
        class_set = strcat( class_set , int2str(class(ii,jj)) );
        if( jj < n )
            if( class(ii,jj+1)~=0 )
                class_set = strcat( class_set , ',');
            end    
        end    
    end
    class_set = strcat( class_set , '}');
    %fprintf( '\n *. Class %d : %s ' , NumCluster , class_set ) ;    
end
%--------------------------------------------------------------------------


%--- Asign the objects to the corresponding cluster -----------------------
Object_cluster = zeros(n,1);
NumCluster = 0;
for ii = 1 : n
    if( class(ii,1)==0 ), continue; end;
    NumCluster = NumCluster + 1 ;
    for jj = 1 : n
        if( class(ii,jj)==0 ), break; end;
        Object_cluster( class(ii,jj) ) = NumCluster;
    end
end    
%--------------------------------------------------------------------------




%--- Shows the convergence results (Location)------------------------------
% num_class = 0;
% for ii = 1 : n
%     if( class(ii,1)==0 ), continue; end;
%     num_class = num_class + 1 ;
%     class_set = '{';
%     for jj = 1 : n
%         if( class(ii,jj)==0 ), break; end;
%         class_set = strcat( class_set , Canada_location(class(ii,jj),:) );
%         if( jj < n )
%             if( class(ii,jj+1)~=0 )
%                 class_set = strcat( class_set , ',' );
%             end    
%         end    
%     end
%     class_set = strcat( class_set , '}');
%     fprintf( '\n *. Class %d : %s ' , num_class , class_set ) ;    
% end
%--------------------------------------------------------------------------



