function  J = Shpere2(x)    %ess = Sphere2(x)
% Sphere2 Named function is the separate .m file of type: function handle
% to define the Objective function in it. 
% I think this named function is the place that the ga.m evaluates the
% objective function. 
    global NFE; % global here means defining a variable to be global among all functions in 
    % this special folder - global defines the variable in its own
    % workspace which is different than the base / regular workspace.
    if isempty(NFE) % output is logical value: 1 means True and 0 means False 
        NFE=0;
    end

    NFE=NFE+1; % Update step, we are updating 'NFE' by 1  
   
%% Define Dynamics' parameters  
m = 10e-3%1; 
k= 1e3%1e4;
ccr = 2 * sqrt(m*k)
zeta = 0.01;
c = zeta*ccr

directory = 'C:\Users\ababaei\OneDrive - ASML\Alireza\My MATLAB Codes\Optimization\NL_MSD_Opti_Ref_Tracking';
load(fullfile(directory, 'yfinal.mat'), 'yfinal') % loading the file 'yfinal.mat' and assigning this to the variable named: 'yfinal' 
% yfinal is the profile trajectory of position 
% kp = 1000;
% ki = 50;
% kd = 10;
kp = x(1, 1); % design varaible 1 
ki = x(1, 2); % design variable 2 
kd = x(1, 3); % design varaible 3 
% when using Simulink, unrecognized function bug shows up! assignin assigns
% variables to the specific workspace (in this case: 'base') where simulink
% looks for variables, - 
% this issue of saving the variables came up as we use 'global' keyword 
assignin('base', 'kp', kp); % simulink is looking for the variable called 'kp' in the base workspace 
assignin('base', 'ki', ki); 
assignin('base', 'kd', kd); 

sim('NL_MSD_RefTrajTrac_Opti_tuningpid_v01.slx')

% first objective to address is: to minimize the ess (steady-state error) 
% ess = abs(1 - ans.simout.Data(end)) % This formula for ess holds valid only for step input
% ess = ((sum(ans.simout.Data - yfinal)).^2)/length(yfinal) % RMSE
% error11 = ans.simout.Data - yfinal; 
% RMSE11 = sqrt(mean(error.^2)) 
Meaness = mean(yfinal) - mean(ans.simout.Data)
% error11 = abs(1 - ans.simout.Data(end)) 
% second objective function is the maximum peak overshoot to be minimized
% as well 
% Mp = (max(ans.simout.Data) - 1)*100
J = Meaness; % define the objective function 
%J = Meaness;  
% J = 0.5*ess + 1*Mp

end
%% 
% when running a matlab function like: Sphere.m, it operates in its own function workspace. 
% However simulink only has access to the base workspace
%%
% ref = ones(1, 10000); 
% pos = 0;
% vel = 0; 
% preve = 0;
% ing = 0; 
% dt = 0.001;
% 
% for i = 1 : 10000
%     e = ref(i) - pos;
%     ing = ing + e*dt;
%     der = (e - preve) / dt;
%     preve = e; 
%     ctrlsig = kp*e + ki*ing + kd*der;
% 
%     acc = (1/m) * (ctrlsig - c*vel - k*pos);
%     vel = acc*dt + vel; 
%     pos = pos + vel*dt; 
% 
%     C(i) = ctrlsig; 
%     Acc(i) = acc;
%     Vel(i) = vel;
%     Pos(i) = pos; 
%     E(i) = e; 
% 
%     fprintf("error = %f; control signal = %f; Position/Response = %f\n", e, ctrlsig, pos) % % is format specifier, /n is escape sequence 
% 
% end
% fprintf("/n")
% fprintf("error = %f /n; control signal = %f /n; Position/Response = %f \n", E, C, Pos) % % is format specifier, /n is escape sequence 
%ess = pos(end)
%% Have no idea why but it cannot reach to a certiain number so let's switch to
% simulate using 
% Simulink 
% ess = pos - ref(end)
% figure(1)
% sgtitle('PID no built-in', 'FontSize', 22)
% subplot(3, 1, 1)
% plot((1:10000)*dt, Pos)
% title('Position')
% grid on 
% subplot(3, 1, 2)
% plot((1:10000)*dt, C)
% title('Controller Effort')
% grid on 
% subplot(3, 1, 3)
% plot((1:10000)*dt, E)
% title('Error')
% grid on 

% end
% L =x(1,1);    % Design Variable number 1 
% b = x(1,2);  % Design Variable number 2
% hs =x(1,3);  % Design Variable number 3
% hp = 0.4e-3;
% 
% Ep = 66e9;
% 
% rop = 7800;
% d31 = -190e-12;
% e33s = 15.93e-9;
% 
% Areap = 2*(b*hp);
% Areas = b*hs;
% Areat = Areas + Areap;
% 
% ros1 = 8166;
% ros2 = 8166;
% ros3 = 8166;
% ros4 = 8166;
% %roA stands for ro * Areat
% roAt1 = ros1*Areas + rop*Areap;
% roAt2 = ros2*Areas + rop*Areap;
% roAt3 = ros3*Areas + rop*Areap;
% roAt4 = ros4*Areas + rop*Areap;
% roAt1 = ros1 * b * hs + rop*Areap;
% 
% Is = (b*hs^3)/12;
% Ip = ((b*hp)/3)*(hp^2 + (3/4)*hs^2 + (3/2)*hs*hp);
% 
% Es1 = 2.078996784819360e+11;
% Es2 = 2.078690000996000e+11;
% Es3 = 2.078372708409760e+11;
% Es4 = 2.078044907060640e+11;
% Stiffs1 = Es1 * Is;
% Stiffs2 = Es2 * Is;
% Stiffs3 = Es3 * Is;
% Stiffs4 = Es4 * Is;
% Stiffp = 2 * Ep * Ip;
% 
% Stifft1 = Stiffs1 + Stiffp;
% EIt1 = Stifft1;
% Stifft2 = Stiffs2 + Stiffp;
% EIt2 = Stifft2;
% Stifft3 = Stiffs3 + Stiffp;
% EIt3 = Stifft3;
% Stifft4 = Stiffs4 + Stiffp;
% EIt4 = Stifft4;
% 
% Qp = ((b*hp)/2) * (hp + hs);
% 
% beammass1 = roAt1 * L;
% beammass2 = roAt2 * L;
% beammass3 = roAt3 * L;
% beammass4 = roAt4 * L;
% rm =0; 
% %rm = input('massratio (rm) = ');
% %rm = [0.01, 0.05, 0.1, 0.5, 1, 5,10, 50, 100]
% ballmass1 = rm .* beammass1;
% ballmass2 = rm .* beammass2;
% ballmass3 = rm .* beammass3;
% ballmass4 = rm .* beammass4;
% 
% rs = 0;
% ks1 = rs .* EIt1;
% ks2 = rs .* EIt2;
% ks3 = rs .* EIt3;
% ks4 = rs .* EIt4;
% % all ghams are found for two layers of piezo
% ghama2 = (Ep*Qp*d31)/hp;
% %Rl = input('Rl = ');
% Rl = 1e6;
% ghama1 = ghama2 * Rl;
% % Cp stands for capacitance 
% Cp = (b*L*e33s)/hp;
% ghama3 = (2*ghama2)/Cp;
% Tauc = (((b*L*e33s)/hp)*Rl)/2;
% 
% Bn = 0.999999890066968;
% 
% Dn = 1.0e4 * 0.041569485060628;
% An = 120;
% %upnw1 = [];
% upnw1 = 0.544928099680952 ;
% zeta = 0.010;
% fphi = 13.919127475558639;
% %fphi = [];
% upnMw1 = fphi;
% %fphiprime1 = [];
% fphiprime1 = 1e3* 0.191597555763059;
% Mthn1 = [0, 0, 0];
% 
% %ghama4 = ghama3 .* fphiprime1;
% ghama4 = ((2*(Ep*Qp*d31)/hp)/((b*L*e33s)/hp)) * 1e3* 0.191597555763059;
% 
% wr = 1e3 * 0.402998629184815; %(deltaT = 0)
% 
% % f in Herts (Htz)
% 
% %chin = ghama2 .* fphiprime1;
% chin = ((Ep*Qp*d31)/hp) * 1e3* 0.191597555763059;
% 
% a = 0;
% b = 9000;
% %fe = linspace(0,1500,750)
% %we = linspace(a,b,10000)
% we = wr;
% %we = 2 * pi * fe;
% fe = we/(2*pi);
% c = 0;
% miu = 0;
% kteta = 0;
% k1 = 0;
% 
% % deltaT = 0
% 
%         s41 = (1+1i*(((b*L*e33s)/hp)*Rl)/2*we)/(((b*L*e33s)/hp)*Rl)/2;
%         s31 = 1i* (((Ep*Qp*d31)/hp) * 1e3* 0.191597555763059 ) * (((2*(Ep*Qp*d31)/hp)/((b*L*e33s)/hp)) * 1e3* 0.191597555763059) *we;
%         s21 = Bn*(wr^2  - we^2 + 1i*(2*zeta*wr*we));
%         s11 = -1i*((ros1 * b * hs + rop*Areap)*upnw1)* (((2*(Ep*Qp*d31)/hp)/((b*L*e33s)/hp)) * 1e3* 0.191597555763059) *we;
%         v21 = s31/s21+s41/3;
%         v11 = s11/s21;
%         v1 = abs(v11/v21); %%%% This is the finla equation. 
%         %d1 = log10(sum(v1))
%         %d11 = sum(v1);
%     z=v1;
% end