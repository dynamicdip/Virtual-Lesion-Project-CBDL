%% create node file
function brain_plot(path,color_col, size_col, node_file_path, node_file_name, csf_file, output_name,output_path)
% path          : path for input files
% color_col     : Color of each node, a column matrix
% size_col      : Size of each node, a column matrix
% lesionArea    : Lesion node index
% node_file_path: Path of .node file
% node_file_name: .node filename
% csf_file      : Brainnet configuration file
% output_name   : Output image name
% output_path   : Output image path
% This code will generate brain plot using BrainNet viewer

load([path,'areaName.mat']); % Desikan killiany node abberiviation  file
load([path,'node_dsk68.mat']);
L=areaName';
tmp = char(L);
node_dsk68(:,4)=color_col;   %  for node color
node_dsk68(:,5)=size_col;    %  for node size
node1 = strcat(num2str(node_dsk68),tmp);
node1(:,end-9:end-5) = char(' ');
dlmwrite([node_file_path,node_file_name],node1,'delimiter','');
BrainNet_MapCfg('BrainMesh_ICBM152_smoothed.nv',...
    [node_file_path,node_file_name],csf_file, [output_path,output_name]); 
