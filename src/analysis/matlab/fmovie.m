% Spike train statistics

clear all
clc

Enable_GoC=1;
Enable_GC=0;
Enable_MF=0;
sim_init = 0;
sim_end = 500; % ms
count=0;
binsize=10; %ms
nbins=sim_end/binsize;

if Enable_MF==1;
'Loading MF Spike time information'
unix './nrnbin2ascii  -c -o MFspiketime.dat MFspiketime.bin';
MFspiketime = csvread('MFspiketime.dat');
MFcoordinates = load('MFcoordinates.dat');

	for i=1:length(MFspiketime(:,1))

		MFhist(i,:) = hist(MFspiketime(i,:),nbins);
		MFFreq(i) = 1000*length(find(nonzeros(MFspiketime(i,:))'))/sim_end;
		XMFdata(i) = MFcoordinates(i,1);
		YMFdata(i) = MFcoordinates(i,2);

	end	


Coordtemp1 = ceil(XMFdata)+1;
Coordtemp2 = ceil(YMFdata)+1;
m=zeros(max(Coordtemp1),max(Coordtemp2));

fig1=figure(1);
winsize = get(fig1,'Position');
winsize(1:2) = [0 0];
A=moviein(numbins,fig1,winsize);
set(fig1,'NextPlot','replacechildren')


for j = 1:numframes 
	for i = 1: length(XMFdata)
	  
    	m(Coordtemp1(1,i), Coordtemp2(1,i)) = m(Coordtemp1(1,i), Coordtemp2(1,i))+MFhist(i,j);
    	ga = gausswin(10);
		gga = ga*ga';
		gga = gga/sum(sum(gga));
		gaussfilter = imfilter(m, gga,'symmetric');
		gaussfilter = (gaussfilter/max(max(gaussfilter)))/(1/max(MFFreq));
		imagesc(gaussfilter) 
		
		title('MF Frequency (Hz)','FontSize',20,'fontweight','b')
		set(gca, 'Box', 'off','FontSize',20 );
		xlabel('X (\mum)','FontSize',20,'fontweight','b')
		ylabel('Y (\mum)','FontSize',20,'fontweight','b')
		colorbar('FontSize',20,'fontweight','b')
		axis xy
		A(:,j)=getframe(fig1,winsize); 
		
	end
end

movie(fig1,A,30,30,winsize)


end


if Enable_GoC==1;
'Loading GoC Spike time information'
unix './nrnbin2ascii  -c -o GoCspiketime.dat GoCspiketime.bin';
GoCspiketime = csvread('GoCspiketime.dat');
GoCcoordinates = load('GoCcoordinates.dat');

	for i=1:length(GoCspiketime(:,1))
		
		GoChist(i,:) = hist(nonzeros(GoCspiketime(i,:)),0:binsize:sim_end);
		GoCFreq(i) = 1000*length(find(nonzeros(GoCspiketime(i,:))'))/sim_end;
		XGoCdata(i) = GoCcoordinates(i,1);
		YGoCdata(i) = GoCcoordinates(i,2);
		ZGoCdata(i) = GoCcoordinates(i,3);

	end	

MeanGoCFreq = mean(GoCFreq)

GoCCoordtemp1 = ceil(ZGoCdata)+1;
GoCCoordtemp2 = ceil(YGoCdata)+1;
mf=zeros(max(GoCCoordtemp1),max(GoCCoordtemp2));

fig2=figure(2);
winsize = get(fig2,'Position');
winsize(1:2) = [0 0];
A=moviein(nbins,fig2,winsize);
set(fig2,'NextPlot','replacechildren')

for j = 1:nbins
	for i = 1: length(XGoCdata)

    mf(GoCCoordtemp1(1,i), GoCCoordtemp2(1,i)) = mf(GoCCoordtemp1(1,i), GoCCoordtemp2(1,i))+GoChist(i,j);
    gf = gausswin(20);
	ggf = gf*gf';
	ggf = ggf/sum(sum(ggf));
	gaussfilter2 = imfilter(mf, ggf,'symmetric');
	gaussfilter2 = (gaussfilter2/max(max(gaussfilter2)))/(1/max(GoCFreq));
	
	end

	imagesc(gaussfilter2);
	
	title('GoC','FontSize',20,'fontweight','b')
	set(gca, 'Box', 'off','FontSize',20 );
	ylabel('Z (\mum)','FontSize',20,'fontweight','b')
	xlabel('Y (\mum)','FontSize',20,'fontweight','b')
	%colorbar('FontSize',20,'fontweight','b')
	axis xy
    A(:,j)=getframe(fig2,winsize);

end	

movie(fig2,A,1,3,winsize)  % play matlab movie
movie2avi(A, 'GoC.avi','fps',3,'quality',100) % save movie to avi

end

if Enable_GC==1;
'Loading GC Spike time information'
unix './nrnbin2ascii  -c -o GCspiketime.dat GCspiketime.bin';
GCspiketime = csvread('GCspiketime.dat');
GCcoordinates = load('GCcoordinates.dat');

	for i=1:length(GCspiketime(:,1))
		
		GChist(i,:) = hist(nonzeros(GCspiketime(i,:)),0:binsize:sim_end);
		GCFreq(i) = 1000*length(find(nonzeros(GCspiketime(i,:))'))/sim_end;
		XGCdata(i) = GCcoordinates(i,1);
		YGCdata(i) = GCcoordinates(i,2);
		ZGCdata(i) = GCcoordinates(i,3);

	end	

MeanGCFreq = mean(GCFreq)

GCCoordtemp1 = ceil(ZGCdata)+1;
GCCoordtemp2 = ceil(YGCdata)+1;
mf=zeros(max(GCCoordtemp1),max(GCCoordtemp2));

fig3=figure(3);
winsize = get(fig3,'Position');
winsize(1:2) = [0 0];
A=moviein(nbins,fig3,winsize);
set(fig3,'NextPlot','replacechildren')

for j = 1:nbins
	for i = 1: length(XGCdata)

    mf(GCCoordtemp1(1,i), GCCoordtemp2(1,i)) = GChist(i,j);
    gf = gausswin(20);
	ggf = gf*gf';
	ggf = ggf/sum(sum(ggf));
	gaussfilter2 = imfilter(mf, ggf,'symmetric');
	gaussfilter2 = (gaussfilter2/max(max(gaussfilter2)))/(1/max(GCFreq));
	
	end

	imagesc(gaussfilter2);
	
	title('GC','FontSize',20,'fontweight','b')
	set(gca, 'Box', 'off','FontSize',20 );
	ylabel('Z (\mum)','FontSize',20,'fontweight','b')
	xlabel('Y (\mum)','FontSize',20,'fontweight','b')
	%colorbar('FontSize',20,'fontweight','b')
	axis xy
    A(:,j)=getframe(fig3,winsize);

end	

movie(fig3,A,1,3,winsize)  % play matlab movie
movie2avi(A, 'GC.avi','fps',3,'quality',100) % save movie to avi

end