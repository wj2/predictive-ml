%% loading
load('../videos/natural_movies_20s_clips_nogamma_frames.mat');
load('../retinal-data/NatMov_RF115.mat');
load('../retinal-data/multmovie_binned.mat');
addpath(genpath('../matlab_mid'));
addpath('normfuncs');

movs = {frames_bushes, frames_water, frames_leaves, frames_fish, ...
    frames_opticflow};

%% creating
neuron = 1;
vids = [2, 3, 4, 5];
savefile = '../mid-preps/neuron1-leaves2/n1-lvs2.mid';
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
res = find_mid(flmov, spks, @(x) x, savefile, 2, false);

