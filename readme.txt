
Following is the project code associated with the virtual lesion manuscript below,  

Structural-and-functional equivalence principle predicts compensatory brain areas driving theThe post-lesion functional recovery mechanismPriyanka Chakraborty, Suman Saha, Gustavo Decob,Arpan Banerjeea, and Dipanjan Roy

[preprint( https://doi.org/10.1101/2023.03.07.531541)]

## Overview

Subject-specific SC matrices were used to generate JC matrices and then SSAs. The SSAs were plotted on the brain surface using 'plot_SSA.m'. Running 'run_FIC_for_RT_dJJ.m' simulates the model and generates RT and dJJ. 'plot_DSA.m' can be run to visualize DSAs on the brain surface, and 'plot_SSA_DSA.m' can be used to visualize SSAs and DSAs with their overlap in the brain surface. For group-level analysis, 'PA_SSA_DSA_batch.m' can be run.

##other files
'areaName.mat': Desikan Killiany node abbreviation file
'BOLD.m': Function file to generate BOLD signals
'brain_plot.m': Function to create node file for DS parcellation using BrainNet Viewer
'readjusted_time_fic.m': Function to calculate readjusted local inhibitory synaptic weights (J) and readjustment time (RT) for each node
'synap_act.m': Function to calculate synthetic functional connectivity (FC)
'weighted_JC.m': Function to calculate JC

#The 'subject_SC' folder contains SC matrices of subjects, and the 'RT_dJJ' folder contains subject-specific simulated files of RT and dJJ.


## Requirments

This code was written in MATLAB and required BrainNet Viewer.

