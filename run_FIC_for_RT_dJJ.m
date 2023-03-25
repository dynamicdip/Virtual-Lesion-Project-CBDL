% Genaretes RT and dJJ for a lesion node
clear all;clc; close all;
dataname='AA_20120815_SC';              % subject file  name
spath='/home/pc/Documents/lesion_17thmay/code_send_sir/subject_SC/'; % path for SC of a subject
load([spath,dataname,'.mat']);
SC     = SC_cap_agg_bwflav1_norm ;
nAreas = size(SC,1);                    % number of brain areas
SC(1:nAreas+1:nAreas*nAreas) = 0 ;      % Diagonal entries equals to zero

% parameters
wEI=0.1*ones(nAreas,1);                 % initial weights
FIC_simTime=10*1000;                    % FIC run time
G=0.55;                                 % global copling constant
simTime=8*60*1000;                      % simulation time total time to generate synaptic activity
noiseAmp=0.001;                         % noise amplitude

% FIC simulation without lesion
[J,RT]= readjusted_time_fic(SC,FIC_simTime,[],wEI,noiseAmp,G);

% Synthetic FC simulation without lesion and with J
[mfc]=  synap_act(SC,J,[],G,simTime,noiseAmp);
%% Simulations with virtual lesion
lesionAreas        = 17 ;   %lesion node index

% Synthetic FC simulation with virtual lesion at a node
[L_fc]= synap_act(SC,J,lesionAreas,G,simTime,noiseAmp); % altered FC generated

% FIC simulation with virtual lesion
[Jnew,RT2] = readjusted_time_fic(SC,FIC_simTime,lesionAreas,J,noiseAmp,G);

% Synthetic FC simulation with virtual lesion at a node
[Lmfc]= synap_act(SC,Jnew,lesionAreas,G,simTime,noiseAmp); % reorganized  FC generated

% saving the dynamical parameters for a lesion area and subject
save(['L',num2str(lesionAreas),'_', dataname(1:11),'.mat'],...
    'J','Jnew','RT2','mfc','Lmfc','L_fc');

