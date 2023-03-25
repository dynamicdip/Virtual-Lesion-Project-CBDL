clear;close all;
% Plot SSAs for a lesion center
% SC is used as input vectors
%%
lesionArea=17;                                          % lesion area index
path='/home/pc/Documents/lesion_Codes/code_send_sir/';  % path for indput files
spath=[path,'subject_SC/'];                             % subject directory path
dataname='AA_20120815_SC';                              % subject file  name
load([spath,dataname,'.mat']);                          % load subject's SC
SC     = SC_cap_agg_bwflav1_norm ;
nAreas = size(SC,1);                                                        % number of brain areas
pcnt=25/100;                                                                % parcentage of nodes to consider
node_to_consider=floor(pcnt*nAreas)+1;                                      % number of nodes to consider for furter analysis

%%
wjc=weighted_JC(SC);                                    % jaccard coefficient matrix
[wjc1,pj]=sort(wjc(lesionArea,:),'descend');            % sort JC for lesion node
p=pj(2:node_to_consider);                               % 1st node is lesion node so considering from 2nd node

%% create brainNet viewer node and output file for SSA

node_file_path=path;                                    % path for node file.
output_path=path;                                       % path for output .jpg file
node_file_name= ['SSA_',dataname,'_L',num2str(lesionArea),'.node'];
output_name=    ['SSA_',dataname,'_L',num2str(lesionArea),'.jpg'];
csf_file=       [path,'csf_basic1.mat'];                % configuration file

if exist('BrainNet') ~=2
    disp('Add BrainNet viewer folder in your MATLAB path');
end

jc=zeros(nAreas,1);
jc(lesionArea)=3;
for i=1:length(p)
    jc(p(i),:)=2;
end

color_col=jc;
size_col=ones(nAreas,1);

brain_plot(path,color_col, size_col,node_file_path, node_file_name, csf_file, ...
    output_name,output_path);                       % Brain plot of SSAs
