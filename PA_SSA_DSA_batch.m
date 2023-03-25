%
% Group-level analysis on SSAs and DSAs

clear;close all;
path=           '/home/pc/Documents/lesion_Codes/code_send_sir/'; % path
node_file_path= '/home/pc/Documents/lesion_Codes/code_send_sir/';  % path for node file. to be saved using BrainNet viewer
output_path=    '/home/pc/Documents/lesion_Codes/code_send_sir/'; % path for output .jpg file.  to be saved using BrainNet viewer
csf_file=       [path,'csf_count.mat'];
lesionArea=17;                                                    % lesion index

spath=[path,'subject_SC/'];                                       % subject directory path
cd(spath)
list=dir('*.mat');                                                % subject-wise SC

co=0; dw =[];

for p=1:length(list)
    dataname=list(p).name;
    load(dataname);                                              % load subject's SC
    SC=SC_cap_agg_bwflav1_norm;
    wjc=weighted_JC(SC);                                         % calculate JC matrix
    nAreas = size(SC,1);                                         % number of brain areas
    pcnt=25/100;                                                 % parcentage of nodes to consider
    node_to_consider=floor(pcnt*nAreas)+1;                       % number of nodes to consider for furter analysis
    [wjc1,pj]=sort(wjc(lesionArea,:),'descend');
    pjj=pj(2:node_to_consider);
    dw=[dw,pjj];                                                 % combining all SSAs over subjects for a lesion node
end
%% PA for SSAs 
for area=1:nAreas
    co(area)=sum(dw==area);      % total count of each area appreared as SSA over subject
end
co=co/length(list);              % PA value for SSA

node_file_name=['count_SSA_',dataname,'_L',num2str(lesionArea),'.node'];        % nodefile's name 
output_name=['count_SSA_',dataname,'_L',num2str(lesionArea),'.jpg'];            % output figure's name
cd(path)
brain_plot(path,co, co,node_file_path, node_file_name, csf_file,...
    output_name,output_path);     % node wise PA value plot on Brain Surface          

%%  PA for DSAs 
cr=0;dr=[];
rt_path='/home/pc/Documents/lesion_Codes/code_send_sir/RT_djj';                      % RT and J filepath
cd (rt_path)

list=dir('*.mat');
for j=1:length(list)
    load(list(j).name);
    djj=Jnew-J;normdjj=abs(djj)/max(abs(djj));normdjj(lesionArea)=10;
    normRT=RT2/max(RT2);normRT(lesionArea)=10;
    [rts,prt]=sort(normRT,'descend');
    [djjs,pdjj]=sort(abs(normdjj),'descend');
    x1=sort(pdjj(2:node_to_consider));
    y1=sort(prt(2:node_to_consider));
    r1=intersect(x1,y1)';
    dr=[dr,r1];
end

% count DSAs over all subjects
for area=1:nAreas
    cr(area)=sum(dr==area); % total count of each area appreared as DSA over subject
end
cr=cr/length(list);         % PA value for SSA

cd(path)
node_file_name=['count_DSA_',dataname,'_L',num2str(lesionArea),'.node'];    % nodefile's name 
output_name=['count_DSA_',dataname,'_L',num2str(lesionArea),'.jpg'];        % output figure's name

brain_plot(path,cr, cr,node_file_path, node_file_name, csf_file,...
    output_name,output_path);
