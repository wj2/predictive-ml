%% pretraining meanstd norm, stim 2
load('../mlout/06-Feb-2015_18:09:57_HU300_nstim100000_3x10x10_btchsz1_nepo100_stimnum2.mat');
out_nopre_meanstd = out;
visualizePrediction(out_nopre_meanstd, 10, 10, 2);

%% pretraining meanstd norm, stim 3
load('../mlout/06-Feb-2015_18:09:57_HU300_nstim100000_3x10x10_btchsz1_nepo100_stimnum3.mat');
out_pre_meanbound = out;
visualizePrediction(out_pre_meanbound, 10, 10, 2);

%% pretraining meanstd norm, stim 5
load('../mlout/06-Feb-2015_18:09:57_HU300_nstim100000_3x10x10_btchsz1_nepo100_stimnum5.mat');
out_presparse = out;
visualizePrediction(out_presparse, 10, 10, 2);
