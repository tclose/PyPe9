%%=====================================================================     load


MF_act = csvread('datasp.dat');
GC_act = csvread('Gspiketime.dat');

G_coord = load('GCcoordinates.dat');
MF_coord = load('MFCr.dat');

numGC = length(G_coord);
numMF = 390;

simTime = 500;

%%=======================================================================     FR


Gactive = find(sum(GC_act,2));
GCisi = diff(GC_act(Gactive,:),1,2);
GCisi(find(GCisi<0)) = 0; 

noGCspkes = @(l)(find(GCisi(l,:)==0,1,'first'));
GCspkcount = arrayfun(noGCspkes, [1:length(GCisi)]);

GCfr = 1000./(sum(GCisi,2)./GCspkcount');

figure(33);
hist(GCfr,200); title('GC firing rate histogram')


GCFRhist = hist(1000./(sum(GCisi,2)./GCspkcount'),200)
ActiveGCMeanFR = mean(1000./(sum(GCisi,2)./GCspkcount'));
TotalGCMeanFR = sum(1000./(sum(GCisi,2)./GCspkcount'))/numGC;


%%===================================================================     Raster
% TODO: add histogram for spike counts at the x and y axis

GCactive = find(sum(GC_act,2));
rasterlineGC = @(c)(line(GC_act(c,:), c, 'marker', '.', 'color', 'k'))
% rasterlineGC = @(c)(line(GCspiketime(c,:), c, 'marker', '.', 'color', 'k'))
arrayfun(rasterlineGC, GCactive);
figure(2);

hist(GC_act(find(GC_act)),simTime)

a(1) = axes; set(a(1), 'position', [0.1300    0.7195    0.77    0.2]);set(a(1),'xtick', [],'yaxisLocation', 'right')
hist(GC_act(find(GC_act)),simTime)
ylabel('spike count')

a(2) = axes; set(a(2), 'position', [0.1300    0.1100    0.77    0.6]);
arrayfun(rasterlineGC, GCactive);
%linkaxes('y',a)
ylabel('GC index')
xlabel('time')



MFactive = find(sum(MF_act,2));
rasterlineMF = @(c)(line(MF_act(c,:), c, 'marker', '.', 'color', 'k', 'markersize', 1));
arrayfun(rasterlineMF, MFactive);
hist(MF_act(find(MF_act)),simTime)


%%===================================================================      GC activity

scatter3(G_coord(Gactive,1), G_coord(Gactive,2) , G_coord(Gactive,3),  GCfr, GCfr);

%%==========================================================     Gen MF stimulus

stim_freq	 = 100; %Hz
stim_dur 	 = .110; %s
sil_dur  	 = .020; %s
stim_repeat  =   7;
bg_dur    	 = .041; %ms
Fs  	  	 =  40000; %Hz

fr_bg   = ones(1, sil_dur*Fs);
fr_st   = sin(linspace(0,stim_freq*2*pi*stim_dur,stim_dur*Fs))*500;
fr_sil  = zeros(1, sil_dur*Fs);

frStim = [fr_st fr_sil];
stim   = repmat(frStim, [1 7]);

fr = [ fr_sil stim fr_bg stim fr_sil];


fr(find(fr<0))=0;                              

alphaf = @(alpha, tau)(alpha^2*tau*exp(-alpha*tau));           
alphav = 35; alphaf1 = @(tau)(alphaf(alphav,tau));                    
K = arrayfun(alphaf1, [0:.025:5]);
K = K/sum(K)-.005;

frc = conv(fr, K, 'same');
frc(find(frc<0))=0; 
frc = frc/max(frc)*1000;

figure(10)
subplot(2,1,1), plot(frc), subplot(2,1,2), plot(K)
MFtrains = genTrainFromFR(frc,'nTrains', 1);

