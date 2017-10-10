% define constants
classdef C
   properties (Constant)
      

        % Direction cosines and directional moment arms for muscles of CA joint
        % Data from canines
        alpha_IA    = -0.697;
        alpha_LCA   = -0.198;
        alpha_PCA   = -0.1;     
        alpha_TA    =  0.015;
        beta_IA     = -0.644;
        beta_LCA    =  0.886;
        beta_PCA    = -0.8;     
        beta_TA     =  0.990;
        gamma_IA    = -3.30  / 10^3;
        gamma_LCA   =  3.915 / 10^3;
        gamma_PCA   = -5.49  / 10^3;
        gamma_TA    =  0.8   / 10^3;

%         C1 = [alpha_IA, alpha_LCA, alpha_PCA, alpha_TA, beta_IA, beta_LCA, beta_PCA, beta_TA, gamma_IA, gamma_LCA, gamma_PCA, gamma_TA];

        % damping coefficients of CA joint
        dx = 0;
        dy = 0;
        dr = 0;
%         C2 = [dx, dy, dr];

        % damping coefficents in vocal cords
        tr = 0;
        tt = 0;
%         C3 = [tr, tt];

        % Constants for CT joint mechanics
        w = 11.1/10^3;   % m    human
        h = 16.1/10^3;   % m    human
        cos_phi = 0.76;  % phi = 41 deg human
%         C4 = [w, h, cos_phi];

        % muscle constants
        % order:
        % L, Ac, M, rho, sigma_0, sigma_2, epsilon_1, epsilon_2, B, sigma_m, epsilon_m, b, epsilon_dot_m, ti, tp, ts
        muscleConstants_IA  = [9.3/10^3, 24.5/10^6, 0.121/10^3, 1.04*10^3, 2000, 30000, -0.5, 0, 3.5, 96000, 0.4, 1.25, 4, 0.01, 0.1, 0.09];
        muscleConstants_LCA = [14.4/10^3, 11.9/10^6, 0.314/10^3, 1.04*10^3, 3000, 59000, -0.5, 0.05, 4, 96000, 0.4, 2.37, 4, 0.01, 0.1, 0.09];
        muscleConstants_PCA = [15/10^3, 48.1/10^6, 0.544/10^3, 1.04*10^3, 5000, 55000, -0.5, 0.1, 5.3, 96000, 0, 1.86, 4, 0.01, 0.1, 0.09];
        muscleConstants_TA  = [18.3/10^3, 40.9/10^6, 0.8232/10^3, 1.04*10^3, 1000, 1500, -0.5, -0.05, 6.5, 105000, 0.2, 1.07, 6, 0.01, 0.1, 0.06];
        muscleConstants_CT  = [13.8/10^3, 41.9/10^6, 0.9423/10^3, 1.04*10^3, 2200, 5000, -0.5, -0.06, 7, 87000, 0.2, 2.4, 2.2, 0.02, 0.1, 0.08];
        muscleConstants_lig = [16/10^3, 5/10^6, 0, 0, 1000, 9000, -0.5, -0.35, 4.4, 0, 0, 0, 0, 0, 0.01, 0.08];
        muscleConstants_muc = [16/10^3, 6.1/10^6, 0, 0, 1000, 1400, -0.5, 0, 17, 0, 0, 0, 0, 0, 0.1, 0.08];
%         C5 = [muscleConstants_IA, muscleConstants_LCA, muscleConstants_PCA, muscleConstants_TA, muscleConstants_CT, muscleConstants_lig, muscleConstants_muc];

        % cadaveric lengths
        Lo =  C.muscleConstants_lig(1,1); % vocal fold cadaveric length
        Lc =  C.muscleConstants_CT(1,1); % CT muscle cadaveric length
        
        % positions
        x_CAJ    =   7.1 * 10^-3;
        y_CAJ    =  -7.1 * 10^-3;
        x_02_bar =   4.0 * 10^-3;
        y_02_bar =   0.0 * 10^-3;
        
        % mass and moment of inertia
        Ir = 13;
        Mt = 1.7524 * 10^-3;
        Ia = 0.1;
        Ma = 0.0861 * 10^-3;
%         C6 = [Lo, Lc, x_CAJ, y_CAJ, x_02_bar, Ir, Mt, Ia, Ma];

        % vector of constants

%         C = [C1, C2, C3, C4, C5, C6];

        % more constants
        xi_bar_02  = C.x_02_bar;
        psi_bar_02 = C.y_02_bar;
   end
end