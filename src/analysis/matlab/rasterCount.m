function out = rasterCount(act,varargin)

% given spike times where every row (matrix) or cell is a neuron, plots the raster and the histogram count.
% the conversion from cell 2 mat is a scary hack =D

if nargin>1
	figure(varargin{1}), clf;
else
	fh = figure;
end

% TODO: Clean this hack!
if iscell(act)
	fid = fopen('temp', 'w');
	cont = act;
	while ~isempty(cont)
		txt = sprintf('%6.4f,', cont{1});
		fprintf(fid, txt);fprintf(fid, '\n');
		cont(1) = []; ; % remove this element
	end
	fclose(fid);
	act = csvread('temp');
	!rm temp
end
	
	
	
	simTime = ceil(max(max(act)))*1000;


	%%===================================================================     Raster
	% TODO: add histogram for spike counts at the x and y axis

	GCactive = find(sum(act,2));
	if iscell(act)
		rasterline = @(c)(line(act{c}, c, 'marker', '.', 'color', 'k', 'markersize', 1));
	else
		rasterline = @(c)(line(act(c,:), c, 'marker', '.', 'color', 'k', 'markersize', 1));
	end

	figure

	a(1) = axes; set(a(1), 'position', [0.1300    0.7195    0.77    0.2]);
	[h x] = hist(act(find(act)),simTime);
	bar(a(1), x, h,'edgecolor', 'none', 'facecolor', 'k')
	set(a(1),'xticklabel', [],'yaxisLocation', 'right', 'color', 'none')
	ylabel('spike count')

	a(2) = axes; set(a(2), 'position', [0.1300    0.1100    0.77    0.6]);
	arrayfun(rasterline, GCactive);
	linkaxes(a, 'x')
	ylabel('cell index')
	xlabel('time')

out.histogram = h;
out.fighandle = fh;