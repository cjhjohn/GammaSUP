%**************************************************************************
%--- Main program
%--- Author : Jen-Hao Chen(a) and  Wen-Liang Hung(b)
%---          a: Institute for Computational and Modeling Science, National 
%---             Tsing Hua University, Hsin-Chu, Taiwan
%---          b: Center of Teacher Education, National Tsing Hua University
%---             Hsin-Chu, Taiwan 
%**************************************************************************


clc
clear all
format long


    
Dim       = '1D';
casename  = '1D_skew_normal' ;  %---Select case here
switch casename    
    case( '1D_skew_normal' )        
        Construct_fv_1D_skew_normal_pdf  
    case( '1D_skew_normal_noise' )        
        Construct_fv_1D_skew_normal_pdf_with_normal_noise   
    case( '1D_skew_normal_outlier' )        
        Construct_fv_1D_skew_normal_pdf_with_normal_outlier 
    case( '2D_beta' )        
        Construct_fv_2D_beta_pdf    
    case( '3D_corel_image' )        
        Construct_fv_3D_corel_image         
end        



%===Run for various tau====================================================
NumTau  = 19;
TauStep = 0.05;
tau     = zeros(NumTau,1);
Fitness = zeros(NumTau,1);
for k = 1 : NumTau 
    tau(k) = TauStep*k;
    [ Object_cluster , Fitness(k) ] = method_GammaSUP( 0.025 , tau(k) , ofv , h , Dim , n , ng  );
    fprintf( ' \n tau = %2.2f ,   Fitness = %f  \n ' , tau(k) , Fitness(k) );
    for i = 1 : n
        fprintf( ' %d ' , Object_cluster(i) );
    end
    fprintf('\n');
end
hold off

ph=plot( tau , Fitness , '-*' );
set(ph, 'LineWidth',1); 
I = xlabel('$\tau$','fontsize',16);  
set( I , 'Interpreter' , 'Latex' );
ylabel('VRC','fontsize',14);
switch casename    
    case( '1D_skew_normal' )        
        filename = strcat( 'Fig_skew_tau.eps' ) ;
    case( '1D_skew_normal_noise' )        
        filename = strcat( 'Fig_skew_noise_tau.eps' ) ;    
    case( '1D_skew_normal_outlier' )        
        filename = strcat( 'Fig_skew_outlier_tau.eps' ) ;
    case( '2D_beta' )        
        filename = strcat( 'Fig_2D_beta_tau.eps' ) ;    
    case( '3D_corel_image' )
        filename = strcat( 'Fig_corel_tau.eps' ) ;
end        
saveas(gcf,filename,'psc2') ; 
%==========================================================================







