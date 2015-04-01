function [ spksLong, dupWMov ] = prepMatMID( spks, mov, cent, ...
    varargin )
parser = inputParser;
parser.addRequired('spks', @isnumeric);
parser.addRequired('mov', @isnumeric);
parser.addRequired('cent', @isnumeric);
parser.addParameter('window', true, @islogical);
parser.addParameter('width', 10, @isnumeric);
parser.addParameter('frames', 1, @isnumeric);
parser.parse(spks, mov, cent, varargin{:});

    function [ windmov ] = getWindowedMov(mov, cent, width)
        lbound = max(1, cent(2) - width);
        rbound = min(size(mov, 2), cent(2) + width);
        dbound = max(1, cent(1) - width);
        ubound = min(size(mov, 1), cent(1) + width);
        
        windmov = mov(dbound:ubound, lbound:rbound, :);
    end

spks = parser.Results.spks;
mov = parser.Results.mov;
cent = parser.Results.cent;
width = parser.Results.width;
windbool = parser.Results.window;
frms = parser.Results.frames;

% save windowedMov in binary format
if windbool
    windowedMov = getWindowedMov(mov, cent, width);
else
    windowedMov = mov;
end
normWindMov = nfMean3Std(windowedMov);
if size(mov, 3) < size(spks, 1)
    buffmat = ones(size(normWindMov, 1), size(normWindMov, 2), ...
        size(spks, 1) - size(normWindMov, 3))*mean2(normWindMov);
    normWindMov = cat(3, normWindMov, buffmat);
end
normFlatMov = flattenMovie(normWindMov, 'frames', frms);
dupWMov = repmat(normFlatMov, [1, size(spks, 2)]);

% concat spikes onto each other and save as spks per line
spksCell = num2cell(spks, 1);
spksLong = vertcat(spksCell{:});

end

