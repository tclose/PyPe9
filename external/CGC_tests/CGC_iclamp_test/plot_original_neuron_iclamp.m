
graphics_toolkit("gnuplot");

CaHVA0       = load ("original/CaHVA.dat");
CaHVA1       = load ("nemo_nmodl_generated/CaHVA.dat");

KA0       = load ("original/KA.dat");
KA1       = load ("nemo_nmodl_generated/KA.dat");

KCa0       = load ("original/KCa.dat");
KCa1       = load ("nemo_nmodl_generated/KCa.dat");

Kir0      = load ("original/Kir.dat");
Kir1      = load ("nemo_nmodl_generated/Kir.dat");

KM0      = load ("original/KM.dat");
KM1      = load ("nemo_nmodl_generated/KM.dat");

KV0      = load ("original/KV.dat");
KV1      = load ("nemo_nmodl_generated/KV.dat");

Na0      = load ("original/Na.dat");
Na1      = load ("nemo_nmodl_generated/Na.dat");


subplot(3,3,1);
plot(CaHVA0(:,1),CaHVA0(:,2),CaHVA1(:,1),CaHVA1(:,2),'linewidth',2);
title ("CaHVA current");

subplot(3,3,2);
plot(KCa0(:,1),KCa0(:,2),KCa1(:,1),KCa1(:,2),'linewidth',2);
title ("KCa current");

subplot(3,3,3);
plot(KA0(:,1),KA0(:,2),KA1(:,1),KA1(:,2),'linewidth',2);
title ("KA current");

subplot(3,3,4);
plot(Kir0(:,1),Kir0(:,2),Kir1(:,1),Kir1(:,2),'linewidth',2);
title ("Kir current");

subplot(3,3,5);
plot(KM0(:,1),KM0(:,2),KM1(:,1),KM1(:,2),'linewidth',2);
title ("KM current");

subplot(3,3,6);
plot(KV0(:,1),KV0(:,2),KV1(:,1),KV1(:,2),'linewidth',2);
title ("KV current");

subplot(3,3,7);
plot(Na0(:,1),Na0(:,2),Na1(:,1),Na1(:,2),'linewidth',2);
title ("Na current");

print  ("NEURON_Original_Iclamp.eps", "-depsc");

