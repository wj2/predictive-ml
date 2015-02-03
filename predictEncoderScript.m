
% can index this for array jobs
videos = {frames_bushes, frames_fish, frames_leaves, frames_opticflow, ...
	  frames_water};

%% params
% stimnum = 4; % comment out if specify with array job

tbegin = now;
frames = 3;
rows = 10;
cols = 10;
nstim = 100000;
video = videos{stimnum};
hiddenUnits = 100;
batchsize = 1;
numepochs = 100;
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
    'seenSamplesFactor', seenSamplesFactor, 'numRuns',1);

tend = now;
timeElapsed = tend - tbegin;
if saveOut
   save(saveName, 'out', 'timeElapsed'); 
end
