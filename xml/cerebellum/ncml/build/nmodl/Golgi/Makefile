
NEMO ?= nemo

all: Golgi_Ca2.mod Golgi_CaHVA.mod Golgi_CaLVA.mod Golgi_Ca.mod Golgi_HCN1.mod Golgi_HCN2.mod Golgi_KA.mod Golgi_KCa.mod Golgi_KM.mod Golgi_KV.mod Golgi_Lkg.mod Golgi_Na.mod Golgi_NaP.mod Golgi_NaR.mod Golgi_SK2.mod

Golgi_SK2.mod : Golgi_SK2.nemo
	$(NEMO) --nmodl --nmodl-kinetic $<

%.mod : %.nemo
	$(NEMO) --nmodl --nmodl-method=derivimplicit $< 

