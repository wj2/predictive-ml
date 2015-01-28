%% loading
load '../videos/natural_movies_20s_clips_nogamma_frames.mat';
addpath(genpath('/Users/wjj/Dropbox/research/uc/palmer/learners/'));

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
seenSamplesFactor = .25;
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
    'seenSamplesFactor', seenSamplesFactor, 'numRuns',1);

tend = now;
timeElapsed = tend - tbegin;
if saveOut
   save(saveName, 'out', 'timeElapsed'); 
end