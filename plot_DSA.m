clear;close all;
% Plot DSAs for a lesion center
% SC and RT, dJJ are used as input vectors
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
rt_path='/home/pc/Documents/lesion_Codes/code_send_sir/';                      % RT and J filepath\
node_file_path=path;                                    % path for node file.
output_path=path;                                       % path for output .jpg file
csf_file=       [path,'csf_basic1.mat'];                % configuration file
node_file_name= ['DSA_',dataname,'_L',num2str(lesionArea),'.node'];
output_name=    ['DSA_',dataname,'_L',num2str(lesionArea),'.jpg'];

if exist ([rt_path,'L',num2str(lesionArea),'_',dataname(1:11),'.mat'])~=2
    disp('Run the code run_FIC_for_RT_dJJ.m and generate the output file or copy subject specific file from RT_dJJ folder');  
else

    load([rt_path,'L',num2str(lesionArea),'_',dataname(1:11),'.mat']);          % load RT and J file
    djj=Jnew-J;
    normdjj=abs(djj)/max(abs(djj));
    normdjj(lesionArea)=10;

    normRT=RT2/max(RT2);
    normRT(lesionArea)=10;

    [rts,prt]=sort(normRT,'descend');
    [djjs,pdjj]=sort(abs(normdjj),'descend');

    %% calculation of node overlap between RT and dJJ
    x1=sort(pdjj(2:node_to_consider));                  % 1st node is lesion node so starting from 2nd node
    y1=sort(prt(2:node_to_consider));
    r1=intersect(x1,y1);
    rtdj=zeros(nAreas,1);
    for i=1:length(r1)
        rtdj(r1(i))=2;
    end

    rtdj(lesionArea)=3;
    color_col=      rtdj;                                % color column for Brain Net viewer
    size_col=       ones(nAreas,1);                      % size column for Brain Net viewer

    brain_plot(path,color_col, size_col, ...
        node_file_path, node_file_name, csf_file, output_name,output_path);    % Brain plot of DSAs
end
