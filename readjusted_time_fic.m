function [wEI,RT]=readjusted_time_fic(SC,FIC_simTime, lesionAreas, wEI_IC,noiseAmp, G)
% Originally created by Gustavo Deco (Deco et al, 2014) 
%%
% Calculates readjusted local inhibitory synaptic weights and readjustment
% time for each node
% This code simulates DMF model with feedback inhibition algorithm
% (Deco et al, 2014) with or without virtual lesion at SC
% Input
% SC            : SC matrix of a subject
% FIC_simTime   : FIC simulation time
% lesionAreas   : Index of the areas which are lesioned in the SC
% wEI_IC        : Local inhibitory synaptic coupling initialization values
% noiseAmp      : Noise amplitude
% G             : Global copling constant
% Output
% wEI           : Readjusted local inhibitory synaptic coupling
% RT            : Readjustment time
% current       : FIC current

%% Example:
% Load Structural Connectivity
% SC = Structural Connectivity matrix; 
% [wEI,RT]=return_time_fic(SC,10*1000, [17],0.1*ones(68,1),0.001, 0.55);
% Will calculate wEI and RT for lesion at node index 17

%%
SC(lesionAreas,:) = 0 ; % virtual lesion, All row wise strctural connectivity set to zero for a lesion node
SC(:,lesionAreas) = 0 ; % All column wise strctural connectivity set to zero for a lesion node
nAreas  = length(SC) ; % number of brain areas
nonLesionAreas      = setdiff(1:nAreas,lesionAreas) ; % brain areas which are not lesioned

dt      = 1 ;   % Step size of simulation
nIters  = FIC_simTime/dt ;
taon    = 100 ; % time constant for NMDA synapses
taog    = 10 ;  % time constant for GABA synapses
gamma   = 0.641 ;
JN      = 0.15 ; % synaptic coupling for NMDA synapses
I0      = 0.382 ;  % external input current
wextE   = 1.0 ; % scaling factor for I0 for excitatory populations
wextI   = 0.7 ; % scaling factor for I0 for excitatory populations
wEE     = 1.4 ; % wEE or w+ synpatics weight for intra area excitatory-excitatory
Iext    = 0 ;    % external current due to stimulus


curr1   = zeros(FIC_simTime,nAreas) ;
r_E     = zeros(FIC_simTime,nAreas) ;
tr      = ceil(FIC_simTime*0.3) ;   % 3secs transient
flag    = 0 ;
co      = 0 ;
delta   = 0.001*ones(nAreas,1) ;
sol_max_fr  = zeros(1,nAreas);
current   = zeros(1,nAreas);
wEI=wEI_IC;
%-----------Balanced feedback Inhibiton control commented
sn = 0.01*ones(nAreas,1) ; % excitatory(NMDA) synaptic gating variable
sg = 0.01*ones(nAreas,1) ; % inhibitory(GABA) synaptic gating variable
% fprintf('Running return_time_fic(...)\n FIC started---> Lesion @ %s. \n',num2str(lesionAreas))
while(flag < length(nonLesionAreas))
    fprintf('.')
    sn(lesionAreas) = 0 ;
    sg(lesionAreas) = 0 ;
    j  = 0 ;
    nn = 0 ;
    for i = 1:nIters
        xn = I0*wextE + wEE*JN*sn + G*JN*SC*sn - wEI.*sg + Iext ;   % input current to excitatory(NMDA) population
        xn(lesionAreas) = 0;
        xg = I0*wextI + JN*sn - sg ;     % input current to inhibitory(GABA) population without FFI
        xg(lesionAreas) = 0;
        rn = phie(xn);  % excitatory(NMDA) population firing rate
        rn(lesionAreas) = 0;
        rg = phii(xg);   % inhibitory(GABA) population firing rate
        rg(lesionAreas) = 0;
        sn = sn + dt*(-sn/taon+(gamma/1000.0)*(1-sn).*rn) + sqrt(dt)*noiseAmp*randn(nAreas,1);
        sn(sn>1) = 1;  sn(sn<0) = 0; sn(lesionAreas) = 0;
        sg = sg + dt*(-sg/taog+rg/1000.0)                 + sqrt(dt)*noiseAmp*randn(nAreas,1);
        sg(sg>1) = 1;  sg(sg<0) = 0; sg(lesionAreas) = 0;
        j = j + 1;
        if(j == 1/dt)
            nn = nn + 1;            j = 0;
            curr1(nn,:) = xn' - 125.0/310.0;
            r_E(nn,:) =rn';
        end
    end
    re    = r_E(tr:end,:) ;
    co    = co + 1 ;
    currm = mean( curr1(tr:end,:), 1 ) ;
    flag  = 0 ;
    for i = 1:length(nonLesionAreas)
        n = nonLesionAreas(i) ;
        if abs( currm(n) + 0.026 ) > 0.005
            if currm(n) < -0.026
                wEI(n)   = wEI(n) - delta(n) ;
                delta(n) = delta(n) - 0.0005 ;
                if delta(n) < 0.0005
                    delta(n) = 0.0005 ;
                end
            else
                wEI(n)  = wEI(n) + delta(n) ;
            end
        else
            sol_max_fr(co,:)  = max(re(:,:)) ;
            current(co,:) = currm ;
            flag       = flag + 1 ;
        end
    end
end
fprintf('\n FIC completed. ')
%% Estimation of Re-adjustment time (RT)
RT=zeros(nAreas,1);
ind=find(current,1); % fisrt non-zero index
current(1:ind-1,:)=[];
sol=abs(current+0.026)<=0.005; % Logical matrix with nodes satisfied EI balance condition
for i=1:nAreas
    nm=[];
    for j=2:size(sol,1)
        if sol(j-1,i)==0 && sol(j,i)==1
            nm=[nm;j];
        end
    end
    if ~isempty(nm)
        RT(i)=nm(end); %RT= total count of simulation time
    else
        RT(i)=1; % RT=1,  not participated in re-eshtablishment of EI balance
    end
end
fprintf(' J and RT estimated. \n')