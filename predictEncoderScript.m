%% loading
videos_fname = 'natural_movies_20s_clips_nogamma_frames.mat';
load(strcat('/home/wjj/prediction-project/videos/', videos_fname));
addpath(genpath('/home/wjj/prediction-project/dlt'));
addpath(genpath('/home/wjj/prediction-project/pe'));
save_folder = '/home/wjj/prediction-project/outputs/';
cd(save_folder);

% can index this for array jobs
videos = {frames_bushes, frames_fish, frames_leaves, frames_opticflow, ...
	  frames_water};
%% params
tbegin = now;
frames = 3;
rows = 15;
cols = 15;
nstim = 100;
video = frames_opticflow;
hiddenUnits = 200;
batchsize = 1;
numepochs = 50;
seenSamplesFactor = .1;
saveOut = true;
timedate = strrep(datestr(tbegin), ' ', '_');
saveName = strcat(timedate, '_HU',num2str(hiddenUnits), '_nstim',...
    num2str(nstim), '_',num2str(frames),'x',num2str(rows),'x', ...
    num2str(cols), '_btchsz', num2str(batchsize), '_nepo',...
    num2str(numepochs), '.mat');

%% setup
stims = createMLStim(video, rows, cols, frames, nstim);

%% do the thing
out = predictiveEncoder(stims, .1, 'hiddenUnits',hiddenUnits,...
    'batchsize', batchsize, 'numepochs', numepochs,...
    'seenSamplesFactor', seenSamplesFactor);

tend = now;
timeElapsed = tend - tbegin;
if saveOut
   save(saveName, 'out', 'timeElapsed'); 
end
