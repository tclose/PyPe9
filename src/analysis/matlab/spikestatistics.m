% Spike train statistics

clear all
clc

Enable_GoC=1;
Enable_GC=1;
Enable_MF=1;
sim_init = 0;
sim_end = 500%200; % s
numMF = 400;
numGoC = 304;
factor = 400;
numGC =  factor*numGoC;
count=1;
edges = [0:1:sim_end]; %Define the edges of the histogram
GoCpsth = zeros(length(edges),1)'; %Initialize the PSTH with zeros
GCpsth = zeros(length(edges),1)'; %Initialize the PSTH with zeros
MFpsth = zeros(length(edges),1)'; %Initialize the PSTH with zeros


%%%%%%%%%%%%%%%%%%%%%
%% GoC Raster plot %%
%%%%%%%%%%%%%%%%%%%%%

if Enable_GoC==1;
ct=1;
'Loading GoC Spike time information'
%unix './nrnbin2ascii  -c -o GoCspiketime.dat GoCspiketime.bin';
unix '/Users/M/Cogsci/Experiments/GranularDecorrelation/GLdata/nrnbin2ascii  -c -o GoCspiketime.dat GoCspiketime.bin';
GoCspiketime = csvread('GoCspiketime.dat');

figure(1);
title('MFfreqBundle = 60 ')
hold on
subplot(2,1,1)
for i=1:length(GoCspiketime(:,1))
spikecell=0;
	for j=1:length(GoCspiketime(i,:))
		if GoCspiketime(i,j)>0
		line([GoCspiketime(i,j) GoCspiketime(i,j)],[-1+i,0+i],'Color','k','LineWidth',2);
		SpikePool(count)= GoCspiketime(i,j);
			if j<=length(GoCspiketime(i,:))-1&&GoCspiketime(i,j+1)~=0
				ISI(i,ct)=GoCspiketime(i,j+1)-GoCspiketime(i,j);
				ct=ct+1;
			end
		count=count+1;
		spikecell=spikecell+1;
		end
	end
	Mean_ISI(i)=mean(ISI(i,:));
	ct=1;
	GOCSpikeCell(i)=spikecell;
	GoCpsth = GoCpsth + histc(nonzeros(GoCspiketime(i,:))',edges);	
	GOCFreq(i) = 1000*length(find(nonzeros(GoCspiketime(i,:))'))/sim_end;

end


ylabel('GoC #','FontSize',30)
xlabel('Time (ms)','FontSize',30)
set(gca, 'Box', 'off','FontSize',30 );
axis([0 sim_end 0 numGoC])

MeanFreq = mean(GOCFreq);
OrderPool = sort(SpikePool);

for i=1:length(OrderPool)-1

	tau_v(i) = OrderPool(i+1) - OrderPool(i);
	tau_v_sqr(i) = (OrderPool(i+1) - OrderPool(i))*(OrderPool(i+1) - OrderPool(i));

end

CV_P = sqrt(mean(tau_v_sqr)-mean(tau_v)*mean(tau_v))/mean(tau_v)
NormCV = (CV_P-1)/sqrt(numGoC)

legend(strcat('\mu = ',num2str(mean(MeanFreq)),' Hz ',' CVp = ',num2str(NormCV)))
%legend(strcat('\mu = ',num2str(1000./mean(Mean_ISI)),' Hz ',' CVp = ',num2str(NormCV)))

%%%%%%%%%%%%%%%%%%%%%
%% GoC PSTH        %%
%%%%%%%%%%%%%%%%%%%%%

subplot(2,1,2);bar(edges,GoCpsth,'k')
ylabel('GoC #spikes','FontSize',30)
xlabel('Time (ms)','FontSize',30)
set(gca, 'Box', 'off','FontSize',20 );
axis([0 sim_end 0 max(GoCpsth)]);

print -f1 -depsc 'GoC_raster.eps';

%%%%%%%%%%%%%%%%%%%%%
%% GoC Spikes/cell %%
%%%%%%%%%%%%%%%%%%%%%

%figure(4);
%scatter(1:numGoC,Freq,'k','filled')
%ylabel('#spikes','FontSize',30)
%xlabel('GoC index','FontSize',30)
%set(gca, 'Box', 'off','FontSize',30 );
%axis([0 numGoC 0 max(Freq)]);
%
%print -f4 -depsc 'GoC_spike_distribution.eps';
%
end


%%%%%%%%%%%%%%%%%%%%%
%% GC Raster plot %%
%%%%%%%%%%%%%%%%%%%%%

if Enable_GC==1;
ct=1;
'Loading GC Spike time information'
unix './nrnbin2ascii  -c -o Gspiketime.dat Gspiketime.bin';
GCspiketime = csvread('Gspiketime.dat');

figure(2);
title('MFfreqBundle = 10 ')
%hold on
subplot(2,1,1)
for i=1:length(GCspiketime(:,1))
spikecell=0;
	for j=1:length(GCspiketime(i,:))
        disp(GCspiketime(i,j))
		if GCspiketime(i,j)>=0
           % disp('ssss')
		line([GCspiketime(i,j) GCspiketime(i,j)],[-1+i,0+i],'Color','k','LineWidth',2)
		SpikePool(count)= GCspiketime(i,j);
			if j<=length(GCspiketime(i,:))-1&&length(find(nonzeros(GCspiketime(i,j)>1)))&&GCspiketime(i,j+1)~=0
				ISI(i,ct)=GCspiketime(i,j+1)-GCspiketime(i,j);
				ct=ct+1;
			else ISI(i,ct)=0; 
			end
		count=count+1;
		spikecell=spikecell+1;
		end
	end
	ct=1;
	Mean_ISI(i)=mean(ISI(i,:));
	GCSpikeCell(i)=spikecell;
	GCpsth = GCpsth + histc(nonzeros(GCspiketime(i,:))',edges);	
	Freq(i) = 1000*length(find(nonzeros(GCspiketime(i,:))'))/sim_end;
end

ylabel('GC #','FontSize',30)
xlabel('Time (ms)','FontSize',30)
set(gca, 'Box', 'off','FontSize',30 );
axis([0 sim_end 0 numGC])

MeanFreq = mean(Freq);
OrderPool = sort(SpikePool);

for i=1:length(OrderPool)-1

	tau_v(i) = OrderPool(i+1) - OrderPool(i);
	tau_v_sqr(i) = (OrderPool(i+1) - OrderPool(i))*(OrderPool(i+1) - OrderPool(i));

end

CV_P = sqrt(mean(tau_v_sqr)-mean(tau_v)*mean(tau_v))/mean(tau_v)
NormCV = (CV_P-1)/sqrt(numGC)

legend(strcat('\mu = ',num2str(mean(MeanFreq)),' Hz ',' CVp = ',num2str(NormCV)))
%legend(strcat('\mu = ',num2str(1000./mean(Mean_ISI)),' Hz ',' CVp = ',num2str(NormCV)))

%%%%%%%%%%%%%%%%%%%%%
%% GC PSTH         %%
%%%%%%%%%%%%%%%%%%%%%

subplot(2,1,2);bar(edges,GCpsth,'k')
ylabel('GC #spikes','FontSize',30)
xlabel('Time (ms)','FontSize',30)
set(gca, 'Box', 'off','FontSize',30 );
%axis([0 sim_end 0 max(GCpsth)]);

print -f2 -depsc 'GC_raster.eps';
%%%%%%%%%%%%%%%%%%%%%
%% GC Spikes/cell %%
%%%%%%%%%%%%%%%%%%%%%

figure(5);
scatter(1:10209,Freq,'k','filled')
ylabel('#spikes','FontSize',30)
xlabel('GC index','FontSize',30)
set(gca, 'Box', 'off','FontSize',30 );
%axis([0 10209 0 max(Freq)]);

print -f5 -depsc 'GC_spike_distribution.eps';
end


%%%%%%%%%%%%%%%%%%%%%
%% MF Raster plot %%
%%%%%%%%%%%%%%%%%%%%%

if Enable_MF==1;
'Loading MF Spike time information'
%unix '/Users/shyam/Desktop/Cerebellum/Granular_layer_parallel  -c -o MFspiketime.dat MFspiketime.bin';
unix '/Users/M/Cogsci/Experiments/GranularDecorrelation/GLdata/nrnbin2ascii  -c -o MFspiketime.dat MFspiketime.bin';
MFspiketime = csvread('MFspiketime.dat');

figure(3);
title('MFfreqBundle = 10 ')
hold on
subplot(2,1,1)
for i=1:length(MFspiketime(:,1))
spikecell=0;
	for j=1:length(MFspiketime(i,:))
		if MFspiketime(i,j)>0
		line([MFspiketime(i,j) MFspiketime(i,j)],[-1+i,0+i],'Color','k','LineWidth',2);
		SpikePool(count)= MFspiketime(i,j);
		count=count+1;
		spikecell=spikecell+1;
		end
	end
	MFSpikeCell(i)=spikecell;
	MFpsth = MFpsth + histc(nonzeros(MFspiketime(i,:))',edges);	
	MFFreq(i) = 1000*length(find(nonzeros(MFspiketime(i,:))'))/sim_end;
end

ylabel('MF #','FontSize',30)
xlabel('Time (ms)','FontSize',30)
set(gca, 'Box', 'off','FontSize',30 );
axis([0 sim_end 0 numMF]);

MeanFreq = mean(MFFreq);
OrderPool = sort(SpikePool);

for i=1:length(OrderPool)-1

	tau_v(i) = OrderPool(i+1) - OrderPool(i);
	tau_v_sqr(i) = (OrderPool(i+1) - OrderPool(i))*(OrderPool(i+1) - OrderPool(i));

end

CV_P = sqrt(mean(tau_v_sqr)-mean(tau_v)*mean(tau_v))/mean(tau_v)
NormCV = (CV_P-1)/sqrt(numMF)

legend(strcat('\mu = ',num2str(mean(MeanFreq)),' Hz ',' CVp = ',num2str(NormCV)))

%%%%%%%%%%%%%%%%%%%%%
%% MF  PSTH        %%
%%%%%%%%%%%%%%%%%%%%%

subplot(2,1,2);bar(edges,MFpsth,'k')
ylabel('MF #spikes','FontSize',30)
xlabel('Time (ms)','FontSize',30)
set(gca, 'Box', 'off','FontSize',30 );
%axis([0 sim_end 0 max(MFpsth)]);
%print -f3 -depsc 'MF_raster.eps';

%%%%%%%%%%%%%%%%%%%%%
%% MF Spikes/cell %%
%%%%%%%%%%%%%%%%%%%%%

figure(6);
scatter(1:numMF,MFFreq,'k','filled')
ylabel('#spikes','FontSize',30)
xlabel('MF index','FontSize',30)
set(gca, 'Box', 'off','FontSize',30 );
%axis([0 numMF 0 max(Freq)])

print -f6 -depsc 'MF_spike_distribution.eps')

end

