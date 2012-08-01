clear all
clc

unix './nrnbin2ascii  -c -o MFtoGC2.dat MFtoGC2.bin';
filename1 = csvread('MFtoGC2.dat');

unix './nrnbin2ascii  -c -o MFtoGoC.dat MFtoGoC.bin';
filename2 = csvread('MFtoGoC.dat');

unix './nrnbin2ascii  -c -o GoCtoGC.dat GoCtoGC.bin';
filename3 = csvread('GoCtoGC.dat');

unix './nrnbin2ascii  -c -o PFtoGoC.dat PFtoGoC.bin';
filename4 = csvread('PFtoGoC.dat');

unix './nrnbin2ascii  -c -o AxontoGoC.dat AxontoGoC.bin';
filename5 = csvread('AxontoGoC.dat');
%
%unix './nrnbin2ascii  -c -o MFGoCtotal.dat MFGoCtotal.bin';
%filename6 = csvread('MFGoCtotal.dat');
%
%unix './nrnbin2ascii  -c -o MFGCtotal.dat MFGCtotal.bin';
%filename7 = csvread('MFGCtotal.dat');
%
%unix './nrnbin2ascii  -c -o PFGoCtotal.dat PFGoCtotal.bin';
%filename8 = csvread('PFGoCtotal.dat');
%
%unix './nrnbin2ascii  -c -o AxonGoCtotal.dat AxonGoCtotal.bin';
%filename9 = csvread('AxonGoCtotal.dat');


%% Save each GC or GoC in a line on the MATLAB array
% MF to GC connections

for i=1:length(filename1(:,1))

GCcell(i)=length(nonzeros(filename1(i,:)));

end

for i=1:length(filename2(:,1))

GoCcell(i)=length(nonzeros(filename2(i,:)));

end

for i=1:length(filename3(:,1))

GoCtoGCcell(i)=length(nonzeros(filename3(i,:)));

end

for i=1:length(filename4(:,1))

PFtoGoCcell(i)=length(nonzeros(filename4(i,:)));

end

for i=1:length(filename5(:,1))

AxontoGoCcell(i)=length(nonzeros(filename5(i,:)));

end

MeanGoCtoGC = mean(GoCtoGCcell)
StdGoCtoGC = std(GoCtoGCcell)
MeanMFtoGC = mean(GCcell)
StdMFtoGC = std(GCcell)
MeanMFtoGoC = mean(GoCcell)
StdMFtoGoC = std(GoCcell)
MeanPFtoGoC = mean(nonzeros(PFtoGoCcell))
StdPFtoGoC = std(nonzeros(PFtoGoCcell))
MeanAxontoGoC = mean(nonzeros(AxontoGoCcell))
StdAxontoGoC = std(nonzeros(AxontoGoCcell))

%Histogram for number of connections

h1=figure(1);

subplot(2,2,[1 3]); hist(GoCtoGCcell,0:1:max(GoCtoGCcell))
legend(strcat('\mu = ',num2str(MeanGoCtoGC),'\sigma = ',num2str(StdGoCtoGC)))
set(gca, 'Box', 'off','FontSize',20 );
ylabel('GC index','FontSize',20)
xlabel('Number of GoCs','FontSize',20)

subplot(2,2,2); hist(GCcell,0:1:max(GCcell))
set(gca, 'Box', 'off','FontSize',20);
legend(strcat('\mu = ',num2str(MeanMFtoGC),'\sigma = ',num2str(StdMFtoGC)))
ylabel('GC index','FontSize',20)
xlabel('Number of MFs','FontSize',20)

subplot(2,2,4); hist(GoCcell,0:1:max(GoCcell))
set(gca, 'Box', 'off','FontSize',20);
legend(strcat('\mu = ',num2str(MeanMFtoGoC),'\sigma = ',num2str(StdMFtoGoC)))
ylabel('GoC index','FontSize',20)
xlabel('Number of MFs','FontSize',20)

h2=figure(2);

hist(nonzeros(PFtoGoCcell),0:1:max(PFtoGoCcell))
legend(strcat('\mu = ',num2str(MeanPFtoGoC),'\sigma = ',num2str(StdPFtoGoC)))
set(gca, 'Box', 'off','FontSize',20 );
ylabel('GoC index','FontSize',20)
xlabel('Number of PFs','FontSize',20)

h3=figure(3);

hist(nonzeros(AxontoGoCcell),0:1:max(AxontoGoCcell))
legend(strcat('\mu = ',num2str(MeanAxontoGoC),'\sigma = ',num2str(StdAxontoGoC)))
set(gca, 'Box', 'off','FontSize',20 );
ylabel('GoC index','FontSize',20)
xlabel('Number of PFs','FontSize',20)

%
%%Histogram for number of GoC connections



%% GC to GoC connections
%
%for i=1:length(indPFtoGoC)-1
%
%PFGoCcell{i,1}=filename4(indPFtoGoC(i)+1:indPFtoGoC(i+1)-1);
%PFGoCcell{i,2}=length(PFGoCcell{i,1});
%TotalconnectionsPFtoGoC(i)=PFGoCcell{i,2};
%end
%
%for i=1:length(indAxontoGoC)-1
%
%AxonGoCcell{i,1}=filename5(indAxontoGoC(i)+1:indAxontoGoC(i+1)-1);
%AxonGoCcell{i,2}=length(AxonGoCcell{i,1});
%TotalconnectionsAxontoGoC(i)=AxonGoCcell{i,2};
%end
%
%
%%%%
%
%% Find repeated indexes on the files
%%
%% MF index
%%for i=0:length(FirstMFid:LastMFid)-1
%%
%%sharedMF(i+1)=length(find(filename1==FirstMFid+i));
%%
%%end
%%GoC index
%%for i=0:length(FirstGoCid:LastGoCid)-1
%%
%%sharedGoCtoGC(i+1)=length(find(filename3==FirstGoCid+i));
%%
%%end
%%GC index PF
%%for i=0:length(FirstGCid:LastGCid)-1
%%
%%sharedPFtoGoC(i+1)=length(find(filename4==FirstGCid+i));
%%
%%end
%%GC index Ascending Axon
%%for i=0:length(FirstGCid:LastGCid)-1
%%
%%sharedAxontoGoC(i+1)=length(find(filename5==FirstGCid+i));
%%
%%end
%
%
%%% Mean and std for each distribution
%
%MeanMFtoGC = mean(TotalconnectionsGC)
%StdMFtoGC = std(TotalconnectionsGC)
%
%%
%MeanMFtoGoC = mean(TotalconnectionsGoC)
%StdMFtoGoC = std(TotalconnectionsGoC)
%
%%
%%MeansharedMF = mean(sharedMF)
%%StdsharedMF = std(sharedMF)
%%
%MeanGoCtoGC = mean(TotalconnectionsGoCtoGC)
%StdGoCtoGC = std(TotalconnectionsGoCtoGC)
%
%%
%%MeansharedGoCtoGC = mean(sharedGoCtoGC)
%%StdsharedGoCtoGC = std(sharedGoCtoGC)
%%
%MeanPFtoGoC = mean(TotalconnectionsPFtoGoC)
%StdPFtoGoC = std(TotalconnectionsPFtoGoC)
%
%%
%MeanAxontoGoC = mean(TotalconnectionsAxontoGoC)
%StdAxontoGoC = std(TotalconnectionsAxontoGoC)
%
%%
%%MeansharedPFtoGoC = mean(sharedPFtoGoC)
%%StdsharedPFtoGoC = std(sharedPFtoGoC)
%%
%%MeansharedAxontoGoC = mean(sharedAxontoGoC)
%%StdsharedAxontoGoC = std(sharedAxontoGoC)
%
%%MeanTotalMFGC = mean(filename7)
%%StdTotalMFGC= std(filename7)
%%
%%%
%%MeanTotalMFGoC = mean(filename6)
%%StdTotalMFGoC= std(filename6)
%%
%%
%%MeanTotalPF = mean(filename8)
%%StdTotalPF= std(filename8)
%%
%%%
%%MeanTotalAxon = mean(filename9)
%%StdTotalAxon= std(filename9)
%
%
%
%% Plot histograms
%%
%% Bar plot for the number of connections for each MF
%%h1=figure(1);
%%bar(MF_id,sharedMF(1:length(sharedMF)-1));
%%set(gca, 'Box', 'off','FontSize',30 );
%%ylabel('Total connections','FontSize',30)
%%xlabel('Mf id','FontSize',30)
%%
%%% Histogram for number of MF connections
%%h2=figure(2);
%%hist(sharedMF)
%%set(gca, 'Box', 'off','FontSize',30 );
%%ylabel('Number of MF','FontSize',30)
%%xlabel('Number of Connections','FontSize',30)
%
%% Histogram for number of GC connections
%
%
%h3=figure(3);
%subplot(2,2,2); hist(TotalconnectionsGC,0:1:max(TotalconnectionsGC))
%set(gca, 'Box', 'off','FontSize',20);
%legend(strcat('\mu = ',num2str(MeanMFtoGC),'\sigma = ',num2str(StdMFtoGC)))
%ylabel('Number of GC','FontSize',20)
%xlabel('Number of Connections','FontSize',20)
%
%%Histogram for number of GoC connections
%%h4=figure(4);
%subplot(2,2,4); hist(TotalconnectionsGoC,0:1:max(TotalconnectionsGoC))
%set(gca, 'Box', 'off','FontSize',20 );
%legend(strcat('\mu = ',num2str(MeanMFtoGoC),'\sigma = ',num2str(StdMFtoGoC)))
%ylabel('Number of GoC','FontSize',20)
%xlabel('Number of Connections','FontSize',20)
%
%%Histogram for number of GoC connections
%%h5=figure(5);
%subplot(2,2,[1 3]); hist(TotalconnectionsGoCtoGC,0:1:max(TotalconnectionsGoCtoGC))
%legend(strcat('\mu = ',num2str(MeanGoCtoGC),'\sigma = ',num2str(StdGoCtoGC)))
%set(gca, 'Box', 'off','FontSize',20 );
%ylabel('Number of GC','FontSize',20)
%xlabel('Number of Connections','FontSize',20)
%
%% Histogram for number of MF connections
%%h6=figure(6);
%%hist(sharedGoCtoGC)
%%set(gca, 'Box', 'off','FontSize',30 );
%%ylabel('Number of GoCs','FontSize',30)
%%xlabel('Number of Connections','FontSize',30)
%
%%
%%Histogram for number of PFGoC connections
%h7=figure(7);
%subplot(1,2,1);hist(TotalconnectionsPFtoGoC,0:1:max(TotalconnectionsPFtoGoC))
%legend(strcat('\mu = ',num2str(MeanPFtoGoC),'\sigma = ',num2str(StdPFtoGoC)))
%set(gca, 'Box', 'off','FontSize',20 );
%ylabel('Number of GoCs','FontSize',20);
%xlabel('Number of ML Connections','FontSize',20);
%
%%Histogram for number of AxontoGoC connections
%%h8=figure(8);
%subplot(1,2,2);hist(TotalconnectionsAxontoGoC,0:1:max(TotalconnectionsAxontoGoC))
%legend(strcat('\mu = ',num2str(MeanAxontoGoC),'\sigma = ',num2str(StdAxontoGoC)))
%set(gca, 'Box', 'off','FontSize',20 );
%%ylabel('Number of GoCs','FontSize',30);
%xlabel('Number of Gl Connections','FontSize',20);
%
%%
%%Histogram for total number of MFGC connections
%%h9=figure(9);
%%subplot(1,2,1); hist(filename7,0:1:max(filename7))
%%legend(strcat('\mu = ',num2str(MeanTotalMFGC),'\sigma = ',num2str(StdTotalMFGC)))
%%set(gca, 'Box', 'off','FontSize',20 );
%%ylabel('Number of MF','FontSize',20);
%%xlabel('Number of GC Connections','FontSize',20);
%%
%%%Histogram for total number of MFGoC connections
%%%h10=figure(10);
%%subplot(1,2,2);hist(filename6,0:1:max(filename6))
%%legend(strcat('\mu = ',num2str(MeanTotalMFGoC),'\sigma = ',num2str(StdTotalMFGoC)))
%%set(gca, 'Box', 'off','FontSize',20 );
%%%ylabel('Number of MF','FontSize',30);
%%xlabel('Number of GoC Connections','FontSize',20);
%%
%%%
%%%Histogram for total number of PFGoC connections
%%h11=figure(11);
%%subplot(1,2,1);hist(filename8,0:1:max(filename8))
%%legend(strcat('\mu = ',num2str(MeanTotalPF),'\sigma = ',num2str(StdTotalPF)))
%%set(gca, 'Box', 'off','FontSize',20 );
%%ylabel('Number of PF','FontSize',20);
%%xlabel('Number of GoC Connections','FontSize',20);
%%
%%%Histogram for total number of AxonGoC connections
%%%h12=figure(12);
%%subplot(1,2,2);hist(filename9,0:1:max(filename9))
%%legend(strcat('\mu = ',num2str(MeanTotalAxon),'\sigma = ',num2str(StdTotalAxon)))
%%set(gca, 'Box', 'off','FontSize',20 );
%%ylabel('Number of Ascending Axons','FontSize',20);
%%xlabel('Number of GoC Connections','FontSize',20);
%
%
%
%
