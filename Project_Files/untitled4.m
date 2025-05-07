SNR=zeros(100,1);
Sep2=zeros(100,2);
i=1;
arrN0=0:0.01:1;
for N0=0:0.01:1
   SNR(i)=-20*log10(N0);
   i=i+1;
end


plot(arrN0,SNR);