%% load data
load('../videos/natural_movies_20s_clips_nogamma_frames.mat');
load('../retinal-data/multmovie_binned.mat');
load('../retinal-data/NatMov_RF115.mat');

movs = {frames_bushes, frames_water, frames_leaves, frames_fish, ...
    frames_opticflow};

%% add depends
addpath(genpath('DeepLearnToolbox'));
addpath(genpath('normfuncs'));

%% learning parameters
lpars.batchsize = 1;
lpars.numepochs = 50;
lpars.seenSamplesFactor = .1;
lpars.pretrain = true;
lpars.prebatch = 5;
lpars.prepochs = 20;
lpars.alpha = .01;
lpars.l2decay = .0001;
lpars.actFunc = 'sigm';
lpars.sparsePenalty = true;

hiddenUnits = 100;
numframes = 4;

%% organize stimuli
neuron = 1;
vids = [2, 3, 4, 5];

cents = getRFCenters(RF);
spks = [];
flmov = [];
for i = vids
    spksdat = binned(:, :, neuron, i);
    mov = movs{i};
    mov = permute(mov, [2, 3, 1]);
    spksdat = permute(spksdat, [2, 1]);

    [s, m] = prepMatMID(spksdat, mov, cents(neuron, :)*10);
    spks = [spks; s];
    flmov = [flmov, m];
end
stim = flmov';
resp = spks;

%% do learning
timedate = strrep(datestr(now), ' ', '_');
saveName = strcat(timedate, '-genModel.mat');
results = learnSpikeResponse(stim, resp, numframes, hiddenUnits, ...
    'trainparams', lpars);

save(saveName, 'results', 'lpars'); 