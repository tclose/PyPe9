% Spike train statistics

clear all
clc

Enable_GoC=1;
Enable_GC=1;
Enable_MF=1;
sim_init = 0;
sim_end = 200; % s
imagestep=10;
count=0;


if Enable_MF==1;
'Loading MF Spike time information'
unix './nrnbin2ascii  -c -o MFspiketime.dat MFspiketime.bin';
MFspiketime = csvread('MFspiketime.dat');
MFcoordinates = load('MFcoordinates.dat');

	for i=1:length(MFspiketime(:,1))

		MFFreq(i) = 1000*length(find(nonzeros(MFspiketime(i,:))'))/sim_end;
		XMFdata(i) = MFcoordinates(i,1);
		YMFdata(i) = MFcoordinates(i,2);

	end	

MeanMFFreq = mean(MFFreq)

Coordtemp1 = ceil(XMFdata)+1;
Coordtemp2 = ceil(YMFdata)+1;
m=zeros(max(Coordtemp1),max(Coordtemp2));

for i = 1: length(XMFdata)   
    m(Coordtemp1(1,i), Coordtemp2(1,i)) = m(Coordtemp1(1,i), Coordtemp2(1,i))+MFFreq(i); 
end

ga = gausswin(10);
gga = ga*ga';
gga = gga/sum(sum(gga));
gaussfilter = imfilter(m, gga,'symmetric');
%gaussfilter = (gaussfilter/max(max(gaussfilter)))/(1/max(MFFreq));
gaussfilter=gaussfilter/max(max(gaussfilter));


figure(1); imagesc(gaussfilter)
title('MF Frequency (Hz)','FontSize',20,'fontweight','b')
set(gca, 'Box', 'off','FontSize',20 );
xlabel('X (\mum)','FontSize',20,'fontweight','b')
ylabel('Y (\mum)','FontSize',20,'fontweight','b')
colorbar('FontSize',20,'fontweight','b')
axis xy


end


if Enable_GoC==1;
'Loading GoC Spike time information'
unix './nrnbin2ascii  -c -o GoCspiketime.dat GoCspiketime.bin';
GoCspiketime = csvread('GoCspiketime.dat');
GoCcoordinates = load('GoCcoordinates.dat');

	for i=1:length(GoCspiketime(:,1))

		GoCFreq(i) = 1000*length(find(nonzeros(GoCspiketime(i,:))'))/sim_end;
		XGoCdata(i) = GoCcoordinates(i,1);
		YGoCdata(i) = GoCcoordinates(i,2);
		ZGoCdata(i) = GoCcoordinates(i,3);

	end	

MeanGoCFreq = mean(GoCFreq)

GoCCoordtemp1 = ceil(ZGoCdata)+1;
GoCCoordtemp2 = ceil(YGoCdata)+1;
mf=zeros(max(GoCCoordtemp1),max(GoCCoordtemp2));

for i = 1: length(XGoCdata)   
    mf(GoCCoordtemp1(1,i), GoCCoordtemp2(1,i)) = mf(GoCCoordtemp1(1,i), GoCCoordtemp2(1,i))+GoCFreq(i); 
end

gf = gausswin(20);
ggf = gf*gf';
ggf = ggf/sum(sum(ggf));
gaussfilter2 = imfilter(mf, ggf,'symmetric');
gaussfilter2=gaussfilter2/max(max(gaussfilter2));
%gaussfilter2 = (gaussfilter2/max(max(gaussfilter2)))/(1/max(GoCFreq));

figure(2); imagesc(gaussfilter2)
title('GoC Frequency (Hz)','FontSize',20,'fontweight','b')
set(gca, 'Box', 'off','FontSize',20 );
xlabel('Z (\mum)','FontSize',20,'fontweight','b')
ylabel('Y (\mum)','FontSize',20,'fontweight','b')
colorbar('FontSize',20,'fontweight','b')
axis xy

end

if Enable_GC==1;
'Loading GC Spike time information'
unix './nrnbin2ascii  -c -o GCspiketime.dat GCspiketime.bin';
unix './nrnbin2ascii  -c -o MFtoGC.dat MFtoGC.bin';

GCspiketime = csvread('GCspiketime.dat');
GCcoordinates = load('GCcoordinates.dat');
MFtoGC = csvread('MFtoGC.dat');


	for i=1:length(GCspiketime(:,1))
	
	    GCFreq(i) = 1000*length(find(nonzeros(GCspiketime(i,:))'))/sim_end;
		TotalconnectionsGC(i)=length(nonzeros(MFtoGC(i,:))');
		XGCdata(i,1) = GCcoordinates(i,1);
		YGCdata(i,1) = GCcoordinates(i,2);
		ZGCdata(i,1) = GCcoordinates(i,3);
        XGCdata(i,2) = GCFreq(i);
		YGCdata(i,2) = GCFreq(i);
		ZGCdata(i,2) = GCFreq(i);
	
	end



MeanGCFreq = mean(GCFreq)

figure(4); scatter(TotalconnectionsGC, GCFreq,'LineWidth',2,'MarkerEdgeColor','black')
set(gca, 'Box', 'off','FontSize',20 );
xlabel('MF connections','FontSize',20);
ylabel('GC frequency (Hz)','FontSize',20);

temp = ceil(ZGCdata(:,1))+1;
temp2 = ceil(YGCdata(:,1))+1;
a=zeros(max(temp),max(temp2));

for i = 1: length(XGCdata(:,1))
    a(temp(i), temp2(i)) = a(temp(i), temp2(i))+XGCdata(i,2); 
end

g = gausswin(10);
gg = g*g';
gg = gg/sum(sum(gg));

gaussfilter3 = imfilter(a, gg,'symmetric');
gaussfilter3=gaussfilter3/max(max(gaussfilter3));
%gaussfilter3 = (gaussfilter3/max(max(gaussfilter3)))/(1/max(GCFreq));

figure(3); imagesc(gaussfilter3)
title('GC Frequency','FontSize',20,'fontweight','b')
set(gca, 'Box', 'off','FontSize',20 );
xlabel('Y (\mum)','FontSize',20,'fontweight','b')
ylabel('Z (\mum)','FontSize',20,'fontweight','b')
colorbar('FontSize',20,'fontweight','b')
axis xy

end

