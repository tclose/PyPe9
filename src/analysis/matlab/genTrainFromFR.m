function out = genTrainFromFR(varargin)

% generates spike times given a firing rate estimation or a constant firing rate.
% 
% Required('fr') % firing rate: vector with t*Fs samples representing firing probabilities, or constant
% ParamValue('time',[0 1]) % how long should the trials be
% ParamValue('Fs',1000) % sampling Frequency
% ParamValue('nTrains',1) % number of Fibers to generate
% ParamValue('thinning',false)
% ParamValue('refractory', 0)
% ParamValue('saveToFile', true)
% ParamValue('fname', 'trainFromFR')

%TODO: ensure that there are no firings during refractory period

p = inputParser;
p.addRequired('fr') % firing rate: vector with t*Fs samples representing firing probabilities, or constant
p.addParamValue('time',[0 1]) % how long should the trials be
p.addParamValue('Fs',40000) % sampling Frequency
p.addParamValue('nTrains',1) % number of Fibers to generate
p.addParamValue('thinning',false)
p.addParamValue('refractory', 0)
p.addParamValue('saveToFile', true)
p.addParamValue('plot', true)
p.addParamValue('fname', 'datasp.dat')
p.addParamValue('container', 'cell')
p.addParamValue('timeunit', 'ms')

p.parse(varargin{:})
fr			= p.Results.fr;
time		= p.Results.time;
Fs			= p.Results.Fs;
nTrains		= p.Results.nTrains;
saveToFile	= p.Results.saveToFile;
plotQ		= p.Results.plot;
fname		= p.Results.fname;
timeunit    = p.Results.timeunit; 

switch timeunit
    case 'ms'
        fac = 1000;
    case 's'
        fac = 1;
end
k =1;

dt = 1/Fs;

if length(fr) == 1  % constant firing rate
	L = time(2) - time(1);
	fr_dt = ones(Fs*L,1)*fr/Fs;
else 			    % variable firing rate
	L = length(fr)/Fs;
	fr_dt = fr/Fs;
end

nS = Fs*(L);
rV = rand(nS,1);


spF = @(l)((find(fr_dt>rand(1, Fs*L)) -1 )/Fs*fac + time(1));
spT = arrayfun(spF, [1:nTrains],'uniformoutput', false);
a = size(spT);
a1(k) = a(2);
k = k+1;

if saveToFile
	fid = fopen(fname, 'w');
	cont = spT;
	while ~isempty(cont)
		txt = sprintf('%6.4f\t', cont{1});
		fprintf(fid, txt);fprintf(fid, '\n');
		cont(1) = []; ; % remove this element
	end
	fclose(fid);
end


if plotQ
	rasterCount(spT);
end

for i=1:length(spT)
    a(i) = length(spT{i});
end

Fa = fopen('l.dat','w');
for i =1:length(a)
    fprintf(Fa,'%d\n',a(i));
end
fclose(Fa)
out = spT;


