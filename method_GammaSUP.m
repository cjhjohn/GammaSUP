%**************************************************************************
%--- Gamma SUP
%--- Author : Jen-Hao Chen(a) and  Wen-Liang Hung(b)
%---          a: Institute for Computational and Modeling Science, National 
%---             Tsing Hua University, Hsin-Chu, Taiwan
%---          b: Center of Teacher Education, National Tsing Hua University
%---             Hsin-Chu, Taiwan 
%**************************************************************************
function [ Object_cluster , Fitness ] = method_GammaSUP( Para_s , Para_tau , ofv , h , Dim , n , ng  )


MaxIter = 500 ;
Epsilon = 1.e-6 ; 
    
% Para_q   = 1 - (Para_s*Para_tau)/(1+Para_s);

wf_old = eye(n) ;          %--- The weight of each function, ex: NEW f4(x,y) = wf(4,1)*f1(x,y) + ... + wf(4,7)*f7(x,y).        
K_new  = zeros(n,n) ;


for t = 0 : MaxIter

    %fprintf('\n Iteration t = %d' , t );

    %***** Upadate pairwise distance **********************************
    d = zeros(n,n) ;    
    for i = 1 : n-1
        for j = i+1 : n
            %---Contruct function value of abs(f(i)-f(j))
            fvi = zeros( ng,1 );
            fvj = zeros( ng,1 );
            for k = 1 : n
                fvi = fvi + wf_old(i,k)*ofv(:,k) ;
                fvj = fvj + wf_old(j,k)*ofv(:,k) ;
            end
            d(i,j) = Integration( h , abs(fvi-fvj) , Dim );   %---fvi and fvj are all new ones.
        end
    end
    for i = 1 : n
        d(i,i) = 0.0 ;
    end     
    for i = 2 : n
        for j = 1 : i-1
            d(i,j) = d(j,i) ;
        end    
    end
    r = 0 ;   %---Averaged pairwise distance 
    for i = 1 : n-1
        for j = i+1 : n
            r = r + d(i,j) ; 
        end
    end
    r = r / nchoosek(n,2) ;   %---NCHOOSEK : Binomial coefficient or all combinations.
    %******************************************************************


    %***** Upadate weight *********************************************
    wf_new = zeros(n,n) ;
    for i = 1 : n

        sum_K = 0 ;
        for j = 1 : n
           tmp_u      = - ((d(i,j)/r)^2) / (Para_tau^2) ;
           K_new(i,j) = (  max( 1+Para_s*tmp_u , 0 )  )^( 1/Para_s );
           sum_K      = sum_K + K_new(i,j);
        end

        for j = 1 : n
            wf_new(i,:) = wf_new(i,:) + ( K_new(i,j) / sum_K ) * wf_old(j,:) ;
        end    

    end
    %******************************************************************

    
    %***** Check convergence ******************************************
    if( sum(sum( abs(wf_new-wf_old))) < Epsilon )
        break;
    else   
        wf_old = wf_new ;
    end
    %******************************************************************
          

end   %---END OF MAIN LOOP  


[ Object_cluster , NumCluster ] = SU_cluster_results( d , n );   %---Return "Object_cluster", the cluster that object belongs to

Fitness = Fitness_func_given_ClusterResult( wf_old , ofv , h , Dim , Object_cluster , NumCluster , 'VRC' );


    
    












