
CaHVA1       = load ("CaHVA.dat");
CaHVA2       = load ("original/CaHVA.dat");

CaLVA1       = load ("CaLVA.dat");
CaLVA2       = load ("original/CaLVA.dat");

HCN11       = load ("HCN1.dat");
HCN12       = load ("original/HCN1.dat");

HCN21       = load ("HCN2.dat");
HCN22       = load ("original/HCN2.dat");

KA1       = load ("KA.dat");
KA2       = load ("original/KA.dat");

KCa1      = load ("KCa.dat");
KCa2      = load ("original/KCa.dat");

KM1      = load ("KM.dat");
KM2      = load ("original/KM.dat");

KV1      = load ("KV.dat");
KV2      = load ("original/KV.dat");

SK21      = load ("SK2.dat");
SK22      = load ("original/SK2.dat");

Na1      = load ("Na.dat");
Na2      = load ("original/Na.dat");

NaP1      = load ("NaP.dat");
NaP2      = load ("original/NaP.dat");

NaR1      = load ("NaR.dat");
NaR2      = load ("original/NaR.dat");


subplot(4,4,1);
plot(CaHVA1(:,1),CaHVA1(:,2),CaHVA2(:,1),CaHVA2(:,2));
title ("CaHVA current");

subplot(4,4,2);
plot(CaLVA1(:,1),CaLVA1(:,2),CaLVA2(:,1),CaLVA2(:,2));
title ("CaLVA current");

subplot(4,4,3);
plot(HCN11(:,1),HCN11(:,2),HCN12(:,1),HCN12(:,2));
title ("HCN1 current");

subplot(4,4,4);
plot(HCN21(:,1),HCN21(:,2),HCN22(:,1),HCN22(:,2));
title ("HCN2 current");

subplot(4,4,5);
plot(KA1(:,1),KA1(:,2),KA2(:,1),KA2(:,2));
title ("KA current");

subplot(4,4,6);
plot(KCa1(:,1),KCa1(:,2),KCa2(:,1),KCa2(:,2));
title ("KCa current");

subplot(4,4,7);
plot(KM1(:,1),KM1(:,2),KM2(:,1),KM2(:,2));
title ("KM current");

subplot(4,4,8);
plot(KV1(:,1),KV1(:,2),KV2(:,1),KV2(:,2));
title ("KV current");

subplot(4,4,9);
plot(SK21(:,1),SK21(:,2),SK22(:,1),SK22(:,2));
title ("SK2 current");

subplot(4,4,10);
plot(Na1(:,1),Na1(:,2),Na2(:,1),Na2(:,2));
title ("Na current");

subplot(4,4,11);
plot(NaR1(:,1),NaR1(:,2),NaR2(:,1),NaR2(:,2));
title ("NaR current");

subplot(4,4,12);
plot(NaP1(:,1),NaP1(:,2),NaP2(:,1),NaP2(:,2));
title ("NaP current");
