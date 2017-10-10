function [X_dot] = continuousDynamics(X,U)

    % --- Unpacking variables
    % unpack state X into individual variables
    [F_IA, F_LCA, F_PCA, F_TA, F_CT, F_lig, F_muc, ...
     sigma_IA, sigma_LCA, sigma_PCA, sigma_TA, sigma_CT, ...
     epsilon_r, epsilon_dot_r, epsilon_t, epsilon_dot_t, ...
     xi_a, xi_dot_a, psi_a, psi_dot_a, theta_a, theta_dot_a] = unpackStateVariables(X);

    % unpack input variables
    [a_IA, a_LCA, a_PCA, a_TA, a_CT] = unpackInputs(U);
 
    
%     % unpack constants
%     alpha_IA = C(1,1); alpha_LCA = C(1,2); alpha_PCA = C(1,3); alpha_TA = C(1,4);
%     beta_IA  = C(1,5); beta_LCA  = C(1,6); beta_PCA  = C(1,7); beta_TA  = C(1,8);
%     gamma_IA = C(1,9); gamma_LCA = C(1,10); gamma_PCA = C(1,11); gamma_TA = C(1,12);
%     dx = C(1,13); dy = C(1,14); dr = C(1,15);
%     %tr = C(1,16); tt = C(1,17);
%     w = C(1,18); h = C(1,19); cos_phi = C(1,20);
%     muscleConstants_IA  = C(1,21:36);
%     muscleConstants_LCA = C(1,37:52);
%     muscleConstants_PCA = C(1,53:68);
%     muscleConstants_TA  = C(1,69:84);
%     muscleConstants_CT  = C(1,85:100);
%     muscleConstants_lig = C(1,101:116);
%     muscleConstants_muc = C(1,117:132);
%     Lo = C(1,133); Lc = C(1,134); x_CAJ = C(1,135); y_CAJ = C(1,136); x_02_bar = C(1,137); 
%     Ir = C(1,138); Mt = C(1,139); Ia = C(1,140); Ma = C(1,141);
    
    % --- Step 1: calculate strains
    % Adductory strain
    epsilon_a = (-1/C.Lo) * (C.y_CAJ*(1-cos(theta_a)) - (C.x_CAJ - C.x_02_bar)*sin(theta_a) + psi_a);
    
    % muscle strains
    epsilon_IA  = epsilon_a;
    epsilon_LCA = epsilon_a;
    epsilon_PCA = epsilon_a;
    epsilon_TA  = epsilon_a + epsilon_r + epsilon_t;
    epsilon_CT  = -C.Lo/C.Lc * (epsilon_r * C.w/C.h + epsilon_t/C.cos_phi);
    epsilon_lig = epsilon_a + epsilon_r + epsilon_t;
    epsilon_muc = epsilon_a + epsilon_r + epsilon_t;
    
    % --- Step 2: calculate strain rates
    epsilon_dot_a = (-1/C.Lo) * (C.y_CAJ*sin(theta_a)*theta_dot_a - (C.x_CAJ - C.x_02_bar)*cos(theta_a)*theta_dot_a + psi_dot_a);
    
    % muscle strain rates
    epsilon_dot_IA  = epsilon_dot_a;
    epsilon_dot_LCA = epsilon_dot_a;
    epsilon_dot_PCA = epsilon_dot_a;
    epsilon_dot_TA  = epsilon_dot_a + epsilon_dot_r + epsilon_dot_t;
    epsilon_dot_CT  = -C.Lo/C.Lc * (epsilon_dot_r * C.w/C.h + epsilon_dot_t/C.cos_phi);
    epsilon_dot_lig = epsilon_dot_a + epsilon_dot_r + epsilon_dot_t;
    epsilon_dot_muc = epsilon_dot_a + epsilon_dot_r + epsilon_dot_t;
    
    % --- Step 3: calculate passive stress in muscles
    sigma_passive_IA  = computePassiveStressInMuscle(epsilon_IA,  C.muscleConstants_IA);
    sigma_passive_LCA = computePassiveStressInMuscle(epsilon_LCA, C.muscleConstants_LCA);
    sigma_passive_PCA = computePassiveStressInMuscle(epsilon_PCA, C.muscleConstants_PCA);
    sigma_passive_TA  = computePassiveStressInMuscle(epsilon_TA,  C.muscleConstants_TA);
    sigma_passive_CT  = computePassiveStressInMuscle(epsilon_CT,  C.muscleConstants_CT);
    sigma_passive_lig = computePassiveStressInMuscle(epsilon_lig, C.muscleConstants_lig);
    sigma_passive_muc = computePassiveStressInMuscle(epsilon_muc, C.muscleConstants_muc);
    
    % --- Step 4: calculate non linear elasticity moduli of muscles
    E_IA  = computeElasticityModulus(epsilon_IA,  C.muscleConstants_IA);
    E_LCA = computeElasticityModulus(epsilon_LCA, C.muscleConstants_LCA);
    E_PCA = computeElasticityModulus(epsilon_PCA, C.muscleConstants_PCA);
    E_TA  = computeElasticityModulus(epsilon_TA,  C.muscleConstants_TA);
    E_CT  = computeElasticityModulus(epsilon_CT,  C.muscleConstants_CT);
    E_lig = computeElasticityModulus(epsilon_lig, C.muscleConstants_lig);
    E_muc = computeElasticityModulus(epsilon_muc, C.muscleConstants_muc);
    
    % --- Step 5: calculate time independent part of active stress in muscles
    % strain dependent component
    f_IA  = computeStrainDependentComponentOfActiveStress(epsilon_IA,  C.muscleConstants_IA);
    f_LCA = computeStrainDependentComponentOfActiveStress(epsilon_LCA, C.muscleConstants_LCA);
    f_PCA = computeStrainDependentComponentOfActiveStress(epsilon_PCA, C.muscleConstants_PCA);
    f_TA  = computeStrainDependentComponentOfActiveStress(epsilon_TA,  C.muscleConstants_TA);
    f_CT  = computeStrainDependentComponentOfActiveStress(epsilon_CT,  C.muscleConstants_CT);
    
    % strain rate dependent component
    g_IA  = computeStrainRateDependentComponentOfActiveStress(epsilon_IA,  C.muscleConstants_IA);
    g_LCA = computeStrainRateDependentComponentOfActiveStress(epsilon_LCA, C.muscleConstants_LCA);
    g_PCA = computeStrainRateDependentComponentOfActiveStress(epsilon_PCA, C.muscleConstants_PCA);
    g_TA  = computeStrainRateDependentComponentOfActiveStress(epsilon_TA,  C.muscleConstants_TA);
    g_CT  = computeStrainRateDependentComponentOfActiveStress(epsilon_CT,  C.muscleConstants_CT);
    
    % time independent component of active stress
    sigma_active_timeIndependent_IA  = a_IA  * C.muscleConstants_IA(1,10)  * f_IA  * g_IA;
    sigma_active_timeIndependent_LCA = a_LCA * C.muscleConstants_LCA(1,10) * f_LCA * g_LCA;
    sigma_active_timeIndependent_PCA = a_PCA * C.muscleConstants_PCA(1,10) * f_PCA * g_PCA;
    sigma_active_timeIndependent_TA  = a_TA  * C.muscleConstants_TA(1,10)  * f_TA  * g_TA;
    sigma_active_timeIndependent_CT  = a_CT  * C.muscleConstants_CT(1,10)  * f_CT  * g_CT;
    
    % --- Now update derivatives of state variables
    % --- Step 6: time derivative of active internal stress in muscles
    sigma_dot_IA  = (sigma_active_timeIndependent_IA  - sigma_IA)  / C.muscleConstants_IA(1,14);
    sigma_dot_LCA = (sigma_active_timeIndependent_LCA - sigma_LCA) / C.muscleConstants_LCA(1,14);
    sigma_dot_PCA = (sigma_active_timeIndependent_PCA - sigma_PCA) / C.muscleConstants_PCA(1,14);
    sigma_dot_TA  = (sigma_active_timeIndependent_TA  - sigma_TA)  / C.muscleConstants_TA(1,14);
    sigma_dot_CT  = (sigma_active_timeIndependent_CT  - sigma_CT)  / C.muscleConstants_CT(1,14);
    
    % --- Step 7: time derivative of forces in muscles
    F_dot_IA  = (C.muscleConstants_IA(1,2)  * (sigma_IA  + sigma_passive_IA  + E_IA  * C.muscleConstants_IA(1,15) *epsilon_dot_IA)  - F_IA)  / C.muscleConstants_IA(1,16);
    F_dot_LCA = (C.muscleConstants_LCA(1,2) * (sigma_LCA + sigma_passive_LCA + E_LCA * C.muscleConstants_LCA(1,15)*epsilon_dot_LCA) - F_LCA) / C.muscleConstants_LCA(1,16);
    F_dot_PCA = (C.muscleConstants_PCA(1,2) * (sigma_PCA + sigma_passive_PCA + E_PCA * C.muscleConstants_PCA(1,15)*epsilon_dot_PCA) - F_PCA) / C.muscleConstants_PCA(1,16);
    F_dot_TA  = (C.muscleConstants_TA(1,2)  * (sigma_TA  + sigma_passive_TA  + E_TA  * C.muscleConstants_TA(1,15) *epsilon_dot_TA)  - F_TA)  / C.muscleConstants_TA(1,16);
    F_dot_CT  = (C.muscleConstants_CT(1,2)  * (sigma_CT  + sigma_passive_CT  + E_CT  * C.muscleConstants_CT(1,15) *epsilon_dot_CT)  - F_CT)  / C.muscleConstants_CT(1,16);
    F_dot_lig = (C.muscleConstants_lig(1,2) * (sigma_passive_lig + E_lig * C.muscleConstants_lig(1,15)*epsilon_dot_lig) - F_lig) / C.muscleConstants_lig(1,16);
    F_dot_muc = (C.muscleConstants_muc(1,2) * (sigma_passive_muc + E_muc * C.muscleConstants_muc(1,15)*epsilon_dot_muc) - F_muc) / C.muscleConstants_muc(1,16);
    
    % --- Step 8: time derivative of translational and rotational strain strain rates
    theta = epsilon_r * C.Lo / C.h;
    [kr, kt] = updateCTStiffness(theta, C.Lo, epsilon_t, epsilon_r, C.h);
    
    epsilon_dotdot_r = (C.h/(C.Lo*C.Ir)) * (C.w * F_CT - C.h*(F_TA + F_lig + F_muc) - kr*(C.Lo/C.h)*(epsilon_r + (C.dr/kr)*epsilon_dot_r));
    epsilon_dotdot_t = (1/(C.Mt*C.Lo)) * (F_CT * C.cos_phi - F_TA - F_lig - F_muc - kt*C.Lo*(epsilon_t + (C.dr/kt)*epsilon_dot_t));
    
    % --- Step 9: acceleration of arytenoid
    [kx, ky, Kappa] = updateCAStiffness(xi_a, psi_a, theta_a);
    
    xi_dotdot_a    = (1/C.Ma) * (C.alpha_IA * F_IA + C.alpha_LCA * F_LCA + C.alpha_PCA * F_PCA + C.alpha_TA * F_TA - kx * xi_a - C.dx * xi_dot_a);
    psi_dotdot_a   = (1/C.Ma) * (C.beta_IA  * F_IA + C.beta_LCA  * F_LCA + C.beta_PCA  * F_PCA + C.beta_TA  * F_TA - ky * psi_a - C.dy * psi_dot_a);
    theta_dotdot_a = (1/C.Ia) * (C.gamma_IA * F_IA + C.gamma_LCA * F_LCA + C.gamma_PCA * F_PCA + C.gamma_TA * F_TA - Kappa * xi_a - C.dr * theta_dot_a);
    
    % --- pack outputs
    X_dot = [F_dot_IA, F_dot_LCA, F_dot_PCA, F_dot_TA, F_dot_CT, F_dot_lig, F_dot_muc, ...
             sigma_dot_IA, sigma_dot_LCA, sigma_dot_PCA, sigma_dot_TA, sigma_dot_CT, ...
             epsilon_dot_r, epsilon_dotdot_r, epsilon_dot_t, epsilon_dotdot_t, ...
             xi_dot_a, xi_dotdot_a, psi_dot_a, psi_dotdot_a, theta_dot_a, theta_dotdot_a];
end