function [ spkname, movname ] = prepMID( spks, mov, cent, basename, ...
    varargin )
parser = inputParser;
parser.addRequired('spks', @isnumeric);
parser.addRequired('mov', @isnumeric);
parser.addRequired('cent', @isnumeric);
parser.addRequired('basename', @ischar);
parser.addParameter('width', 10, @isnumeric);
parser.addParameter('frames', 1, @isnumeric);
parser.parse(spks, mov, cent, basename, varargin{:});

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
basename = parser.Results.basename;
width = parser.Results.width;

% save windowedMov in binary format
windowedMov = getWindowedMov(mov, cent, width);
normWindMov = nfMean3Std(windowedMov);
if size(mov, 3) < size(spks, 1)
    buffmat = ones(size(normWindMov, 1), size(normWindMov, 2), ...
        size(spks, 1) - size(normWindMov, 3))*mean2(normWindMov);
    normWindMov = cat(3, normWindMov, buffmat);
end
normWindMov = permute(normWindMov, [2, 1, 3]);
dupWMov = repmat(normWindMov, [1, 1, size(spks, 2)]);
disp(size(dupWMov));
movname = strcat(basename, '_mov.raw');
fidmov = fopen(movname, 'w');
fwrite(fidmov, dupWMov, 'uint8');
fclose(fidmov);

% concat spikes onto each other and save as spks per line
spksCell = num2cell(spks, 1);
spksLong = vertcat(spksCell{:});
disp(size(spksLong));
spkname = strcat(basename, '_spks.isk');
fidspks = fopen(spkname, 'w');
fprintf(fidspks, '%i\n', spksLong);
fclose(fidspks);

end

