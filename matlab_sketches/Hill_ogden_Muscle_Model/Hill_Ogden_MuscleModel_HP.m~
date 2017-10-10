function Hill_Ogden_MuscleModel
%%  Three Network Ogden model with Hill contractile element active stress
%       www.ncvs.org
%   original code for Ogden 3-network model by
%   Anil Palaparthi 2010-02-25
%   adaptation to include active muscle model components by
%   Simeon Smith 2012-10-11
%
%   The model characterizes the transient responses of soft tissues
%   such as cyclic stress relaxation and creep behavior with the inclusion
%   of an active contractile stress
%   
%   Inputs:
%   parameters of the Three network model, parameters for a Hill model
%   contractile element, prescribed time and strain
%
%   Outputs:
%   Model stresses representing the active and passive responses
%   of laryngeal muscle
%
%%  General Constants
    close all;
    clear all;
    clc;
    tau_ = 1/1000;          % sampling rate
    freq_ = 1;              % frequency of input strain
    
%%  Fit Workcycle to Ogden Model and Define Active Response Constants
    rng = [1];
%   parameters of network A
    guess0_(1,:) = [17.6746].*rng;          % a
    guess0_(2,:) = [4.743].*rng;            % mu_A
%   parameters of network B
    guess0_(3,:) = [0.022].*rng;            % Z_B 
    guess0_(4,:) = [-0.80902].*rng;         % c_B 
    guess0_(5,:) = [1.2527].*rng;           % m_B 
    guess0_(6,:) = [78.3221].*rng;          % mu_B 
%   parameters of network C    
    guess0_(7,:) = [.005].*rng;             % Z_C
    guess0_(8,:) = [-0.005].*rng;           % c_C
    guess0_(9,:) = [1.1].*rng;              % m_C
    guess0_(10,:) = [0.74].*rng;            % mu_C
%   time constants for active response
    guess0_(11,:) = [0.08].*rng;            % t_1
    guess0_(12,:) = [0.02].*rng;            % t_2
    
% Z_cv=0.0025; m_cv=1.8; c_cv=-1; alpha_cv=15.0; m_B_cv=130.0;
% Z_lg=0.004; m_lg=1.3; c_lg=-1; alpha_lg=20.0; m_B_lg=50.0;
% 
% lamda_0=1.0001; lamda1_0=1; lamda2_0=1;
% C_1=2; C_2=2; C_3=-2; C_4=0; f_cv=1; f_lg=0;

    
%%  Inputs
    time_ = 0:tau_:3; 
    
    % Activation as a function of time
    a_l = 1.0;              % activation level
    lt = length(time_);
    act = zeros(1,lt);
    act(0.1/tau_:2.0/tau_) = a_l;
    
    
    
    
    eps_amp_ = 20;
    eps_= eps_amp_/100*(1-(.5+.5*cos(2*pi*time_*freq_)));
    
%%  Calculate Needed Stuff
    lamda_A=1+eps_+0.0001;                  % lamda = 1+eps
    dlamda_A=0.*lamda_A;
    dlamda_A(2:end)=diff(lamda_A)/tau_;     % first point is ignored
    dlamda_A(1)=dlamda_A(2);
    
%%  Calculate Active Contractile Element Stress
    % Parameters
    lamda_opt = 1.5;        % stretch at which maximum stress occurs
    sf = 0.35;              % Gaussian shape factor
    m = 0.01;               % slope parameter
    sp = 0.2;               % Hill shape parameter
    sig_m = 134.0;          % maximum active stress (kPa)
    deps_m = 2.25;          % maximum strain rate (lengths/s)
    
    

    
    % Force-length relationship
    f_TL = zeros(1,lt);
    for j = 1:lt
        f_TL(j) = exp(-1*((lamda_A(j)-lamda_opt)/sf)^2) + m*lamda_A(j);
    end
    
    % Force-velocity relationship
    deps_ = 0*eps_;
    deps_(2:end) = diff(eps_)/tau_;
    deps_(1) = deps_(2);
    v_norm = (1/deps_m)*deps_;
    
    f_TV = zeros(1,lt);
    for k = 1:lt
        if v_norm(k) <= 0
            b = -sp;
            c = 1+sp;
            f_TV(k) = 1-(c/(v_norm(k)+b))*v_norm(k);
        else
            b = 0.5*sp;
            c = (1+0.5*sp)*(1.4-1);
            f_TV(k) = 1+(c/(v_norm(k)+b))*v_norm(k);
        end
    end

    % Contractile element stress
    sigCE = sig_m*act.*f_TL.*f_TV;
    
%%  Passive Stress Calculation and Total Stress Response
    
%   Function to obtain stress data for the given stretch
    [sigT(1,:) sigI(1,:) sigY(1,:)] = model_Hill_Ogden3Net_Function([guess0_(:,1)'],tau_,lamda_A,dlamda_A,sigCE);

    %Obtain passive stress from total
    sigP = sigT-sigY;
    
    %Convert stress in kPa to gram-force
%     cf = 1000*(.0025*.0035)*(1/.0098);
%     fCE = cf*sigCE;
%     fY = cf*sigY;
%     fI = cf*sigI;
%     fP = cf*sigP;
%     fT = cf*sigT;
    
%   Store the stress and strain data in a file
    y = [time_;eps_;sigT;sigP;sigY]; 
    fid = fopen('Hill_Ogden_stress-strain_kPa.txt','wt');
    fprintf(fid,'%12.8f %12.8f %12.8f %12.8f %12.8f\n',y);
    fclose(fid);
    
    %y2 = [time_;eps_;fT;fP;fY]; 
    %fid2 = fopen('2ndOrder_stress-strain_f-g.txt','wt');
    %fprintf(fid2,'%12.8f %12.8f %12.8f %12.8f %12.8f\n',y2);
    %fclose(fid2);

%%  Plots

%   plot the stretch across time
    figure(),plot(time_,lamda_A)
    xlabel('time');ylabel('Stretch')

%   stress vs strain
    figure(),plot(eps_,sigT,'b-')
    title('stress vs strain')
    xlabel('strain (\epsilon)')
    ylabel('stress (\sigma)')
    
%   total stress vs time
    figure(), plot(time_,sigT,'k-')
    hold on
    plot(time_,sigP,'r--')
    plot(time_,sigY,'b--')
    plot(time_,(sigY+sigP),'m--')
    
    %plot(time_,sigI,'g--')
    xlabel('time (sec)');
    ylabel('stress(kPa)');
    legend('Total Stress','Passive Stress','sigY')


%%  Solve for lamda_B, lamda_C, sigI, and sigY and obtain total stress sigT
function [sigT sigI sigY] = model_Hill_Ogden3Net_Function(par,tau,lamda_A,dlamda_A,sig_CE)
%   Function to solve for lamda_B, lamda_C, sigI, and sigY and obtain total stress data
%   for a three network ogden model with Hill active stress
%
%   par - seed parameters
%   tau - sampling rate
%   lamda_A - stretch of network A
%   dlamda_A - derivative of stretch of network A
%
%   returns total stress in network A, network B, network C, and active
%   network
%%%%%%%%%%%%%%%
%
%   Anil Palaparthi 2010-02-25
%   adaptations by Simeon Smith 2012-10-11
%

%%  Store the parameters of Ogden model and active time response in temporary variables
%   parameters of network A
    a = par(1,1);
    mu_A = par(1,2);
%   parameters of network B
    Z_B = par(1,3);
    c_B = par(1,4);
    m_B = par(1,5);
    mu_B = par(1,6);
%   parameters of network C
    Z_C = par(1,7);
    c_C = par(1,8);
    m_C = par(1,9);
    mu_C = par(1,10);
%   active response time constants
    t_i = par(1,11);
    t_y = par(1,12);
    
%%  Initializations
    ns = length(lamda_A);
%   Network B
    lamda_B = 1;                            % Stretch of Network B
%   derivative of stretch of Network B
    dlamda_B = [dlamda_A(1)*(lamda_B/lamda_A(1))]-...
           (2/3)*lamda_B*Z_B*sign(lamda_B-1+1e-15)*...
           [[sqrt((1/3)*[(lamda_A(1)/lamda_B)^2+(2*lamda_B/lamda_A(1))])-1+1e-4]^c_B]*...
           [abs((2*mu_B/a)*[(lamda_B^a)-(lamda_B^(-0.5*a))])]^m_B;
                                                
%   Network C
    lamda_C = 1.1;
%   derivative of stretch of Network C
    dlamda_C = [dlamda_A(1)*(lamda_C/lamda_A(1))]-...
           (2/3)*lamda_C*Z_C*sign(lamda_C-1+1e-15)*...
           [[sqrt((1/3)*[(lamda_A(1)/lamda_C)^2+(2*lamda_C/lamda_A(1))])-1+1e-4]^c_C]*...
           [abs((2*mu_C/a)*[(lamda_C^a)-(lamda_C^(-0.5*a))])]^m_C;

%   Active stress response (1st system)
    sig_i = 0;
%   derivative of active stress (1st system)
    dsig_i = (1/t_i)*(sig_CE(1)-sig_i);
    
%   2nd system for active stress response
    sig_y = 0;
    dsig_y = (1/t_y)*(sig_i-sig_y);
       
%% 
%
%   Initializations for RK4for.m DO NOT CHANGE ANYTHING %%
%
%   Network B
    phi_B  = lamda_B;                       % RK routine internal variable
    yo_B   = phi_B;                         % RK routine internal variable
    time_B = 0;                             % time set to zero
%   Network C
    phi_C  = lamda_C;                       % RK routine internal variable
    yo_C   = phi_C;                         % RK routine internal varialbe
    time_C = 0;                             % time set to zero
%   1st active system
    phi_K  = sig_i;                         % RK routine internal variable
    yo_K   = phi_K;                         % RK routine internal varialbe
    time_K = 0;                             % time set to zero
%   2nd active system
    phi_Y = sig_y;
    yo_Y = phi_Y;
    time_Y = 0;
    
    N = 1;                                  % number of equs solved by RK4
    tmp = 1;                                % temporary counting array
    c1 = tmp+1;                             % indecies for regaining above
    c3 = tmp+1+2*N; c4 = tmp+1+3*N;         % _variables from RK4 output 

%   Total stress
    sigT = zeros(1,ns);                     %Initialize total stress
    sigT(1) = (2*mu_A/a)*[lamda_A(1)^(a-1) - lamda_A(1)^(-0.5*a-1)]+...
        (2*mu_B/a)*[lamda_B^(a-1) - lamda_B^(-0.5*a-1)]+...
        (2*mu_C/a)*[lamda_C^(a-1) - lamda_C^(-0.5*a-1)]+sig_y;
    
    sigI = zeros(1,ns);                     %Initialize active stress
    sigI(1) = sig_i;
    
    sigY = zeros(1,ns);
    sigY(1) = sig_y;
    
    for n = 2:ns
        
        Istat = 1;
        m = 0;
        
%       Network B
        while(Istat~=0),
            m = m+1;
            [temp]=RKfor(N,lamda_B, dlamda_B, time_B, tau, phi_B, yo_B, m);
            %% send [(N,F,dF,time,tau,phi,yo,m)
            % ...N = number of variables to solve, 
            % ...F = variable to solve
            % ...dF= its derivative
            % ...time= current time in iteration
            % ...tau = time step,
            % ...internal parameter for recall
            % ...internal parameter for recall].
            % ...Returns updated... [status F dF phi yo time]
            %% regain variables 
            
            Istat   = temp(1);              % condition of loop
            lamda_B = temp(c1);             % update the RKA variables
            phi_B   = temp(c3);             % internal variable for recall
            yo_B    = temp(c4);             % internal variable for recall
            time_B  = temp(end);            % time update
       
            % derivative of lamda_B: equation 11 from (Zhang et al., 2006)
            dlamda_B(1) = [dlamda_A(n)*(lamda_B(1)/lamda_A(n-1))]-...
                [(2/3)*lamda_B(1)*Z_B*sign(lamda_B(1)-1+1e-15)*...
                [[sqrt((1/3)*[(lamda_A(n-1)/lamda_B(1))^2+(2*lamda_B(1)/lamda_A(n-1))])-1+1e-4]^c_B]*...
                [abs((2*mu_B/a)*[(lamda_B(1)^a)-(lamda_B(1)^(-0.5*a))])]^m_B];
 
        end
        
        Istat = 1;
        m = 0;
        
%       Network C
        while(Istat~=0),
            m = m+1;
            [temp]=RKfor(N,lamda_C, dlamda_C, time_C, tau, phi_C, yo_C, m);
            %% send [(N,F,dF,time,tau,phi,yo,m)
            % ...N = number of variables to solve, 
            % ...F = variable to solve
            % ...dF= its derivative
            % ...time= current time in iteration
            % ...tau = time step,
            % ...internal parameter for recall
            % ...internal parameter for recall].
            % ...Returns updated... [status F dF phi yo time]
            %% regain variables 
            
            Istat   = temp(1);              % condition of loop
            lamda_C = temp(c1);                % update the RKA variables
            phi_C   = temp(c3);             % internal variable for recall
            yo_C    = temp(c4);             % internal variable for recall
            time_C  = temp(end);            % time update
       
            % derivative of lamda_B: equation 11 from (Zhang et al., 2006)
            dlamda_C(1) = [dlamda_A(n)*(lamda_C(1)/lamda_A(n-1))]-...
                [(2/3)*lamda_C(1)*Z_C*sign(lamda_C(1)-1+1e-15)*...
                [[sqrt((1/3)*[(lamda_A(n-1)/lamda_C(1))^2+(2*lamda_C(1)/lamda_A(n-1))])-1+1e-4]^c_C]*...
                [abs((2*mu_C/a)*[(lamda_C(1)^a)-(lamda_C(1)^(-0.5*a))])]^m_C];
 
        end

        Istat = 1;
        m = 0;
        
%       1st active system
        while(Istat~=0),
            m = m+1;
            [temp]=RKfor(N,sig_i, dsig_i, time_K, tau, phi_K, yo_K, m);
            %% send [(N,F,dF,time,tau,phi,yo,m)
            % ...N = number of variables to solve, 
            % ...F = variable to solve
            % ...dF= its derivative
            % ...time= current time in iteration
            % ...tau = time step,
            % ...internal parameter for recall
            % ...internal parameter for recall].
            % ...Returns updated... [status F dF phi yo time]
            %% regain variables 
            
            Istat   = temp(1);              % condition of loop
            sig_i = temp(c1);               % update the RKA variables
            phi_K   = temp(c3);             % internal variable for recall
            yo_K    = temp(c4);             % internal variable for recall
            time_K  = temp(end);            % time update
       
            % derivative of sig_i: equation 2.65 from "Myoelastic..." book
            dsig_i(1) = (1/t_i)*(sig_CE(n)-sig_i(1));
 
        end
        
        Istat = 1;
        m = 0;
        
%       2nd active system
        while(Istat~=0),
            m = m+1;
            [temp]=RKfor(N,sig_y, dsig_y, time_Y, tau, phi_Y, yo_Y, m);
            %% send [(N,F,dF,time,tau,phi,yo,m)
            % ...N = number of variables to solve, 
            % ...F = variable to solve
            % ...dF= its derivative
            % ...time= current time in iteration
            % ...tau = time step,
            % ...internal parameter for recall
            % ...internal parameter for recall].
            % ...Returns updated... [status F dF phi yo time]
            %% regain variables 
            
            Istat   = temp(1);              % condition of loop
            sig_y = temp(c1);               % update the RKA variables
            phi_Y   = temp(c3);             % internal variable for recall
            yo_Y    = temp(c4);             % internal variable for recall
            time_Y  = temp(end);            % time update
       
            % derivative of sig_y: equation 2.65 from "Myoelastic..." book
            dsig_y(1) = (1/t_y)*(sig_i-sig_y(1));
 
        end
        
%   Total stress
    sigT(n) = (2*mu_A/a)*[lamda_A(n)^(a-1) - lamda_A(n)^(-0.5*a-1)]+...
        (2*mu_B/a)*[lamda_B^(a-1) - lamda_B^(-0.5*a-1)]+...
        (2*mu_C/a)*[lamda_C^(a-1) - lamda_C^(-0.5*a-1)]+sig_y;
    
    sigI(n) = sig_i;
    
    sigY(n) = sig_y;
    
    end
    
return


function out = RKfor( N,Y,F,X,H,PHI,Y0,m) 
%   RKfor
%
%	Runge-Kutte 4th order routine based on a fortran version
%		used by Ingo Titze.  From an old Fortran Numerical methods book
%
%	Eric Hunter did the conversion
%
    J=1:N;
    switch m
    case 1,
        istat=1;
    case 2,
        istat=1;
        Y0(J)=Y(J);
        PHI(J)=F(J);
        Y(J)=Y0(J)+0.5*H*F(J);
        X=X+0.5*H;
    case 3,
        istat=1;
        PHI(J)=PHI(J)+2.*F(J);
        Y(J)=Y0(J)+0.5*H*F(J);
    case 4,
        istat=1;
        PHI(J)=PHI(J)+2.*F(J);
        Y(J)=Y0(J)+H*F(J);
        X=X+0.5*H;
    otherwise,
        istat=0;
        Y(J)=Y0(J)+(PHI(J)+F(J))*H/6;           
    end
    out=[istat,Y,F,PHI,Y0,X];
return
%----------------------------------------------------------

