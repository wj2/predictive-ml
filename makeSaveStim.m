function [ vids ] = makeSaveStim( video, name, rows, cols, frames, n, ...
    varargin )
%makeSaveStim : create stimuli and save them for use in learning
%   
parser = inputParser;
parser.addRequired('video', @isnumeric);
parser.addRequired('name', @ischar);
parser.addRequired('rows', @isnumeric);
parser.addRequired('cols', @isnumeric);
parser.addRequired('frames', @isnumeric);
parser.addRequired('n', @isnumeric);
parser.addParameter('opticFlow', true, @islogical);
parser.addParameter('ofFrames', 1, @isnumeric);
parser.addParameter('normalization', @nfMean3Std, ...
    @(x) isa(x, 'function_handle'));
parser.parse(video, name, rows, cols, frames, n, varargin{:});
video = parser.Results.video;
name = parser.Results.name;
rows = parser.Results.rows;
cols = parser.Results.cols;
frames = parser.Results.frames;
n = parser.Results.n;
opticFlow = parser.Results.opticFlow;
ofFrames = parser.Results.ofFrames;
normalization = parser.Results.normalization;

clips = createMLStim(video, rows, cols, frames, n, normalization);
vids.clips = clips;
if opticFlow
    clipsOF = getOpticFlow(clips, ofFrames);
    vids.clipsOF = clipsOF;
end
save(name, 'vids'); 
end

