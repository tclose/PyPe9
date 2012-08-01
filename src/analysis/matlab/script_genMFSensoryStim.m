
%%==========================================================     Gen MF stimulus
fn = fopen('activeMfibres1.dat','r');
num = fscanf(fn,'%d',[1 inf]);
n = size(num(num>0));
stim_freq	 = 20; %Hz
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
MFtrains = genTrainFromFR(frc,'nTrains', 183);

