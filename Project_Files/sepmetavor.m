a=0.25;
c=0.5;
Sep1=zeros(20,1);
Sep2=zeros(20,2);
SNR=zeros(20,1);
arrN0=zeros(20,1);
Sep1Th=zeros(20,1);
Sep2Th=zeros(20,1);
for k=1:20
    SNR(k)=k;
end    
    arrN0=10.^(-SNR/10);
for i=1:20
    [Sep1(i),Sep2(i)]=SEP_N0(arrN0(i),a);
    Sep1Th(i)=1.5*qfunc(sqrt(0.8*a/arrN0(i)));
    Sep2Th(i)=1.5*qfunc(sqrt(0.8*(1-a)/(c*arrN0(i))));

end

semilogy(SNR,Sep1,SNR,Sep1Th);
title("UE1");
xlabel('SNR DB'); 
ylabel('SEP');
legend('Simulation','Theoritical','Location','northeast')

hold on
figure;
semilogy(SNR,Sep2,SNR,Sep2Th);
title("UE2");
xlabel('SNR DB'); 
ylabel('SEP');
legend('Simulation','Theoritical','Location','northeast')

figure;
semilogy(SNR,Sep1);
title("UE1 a=0.25");
xlabel('SNR DB'); 
ylabel('SEP');
hold on
figure;
semilogy(SNR,Sep2);
title("UE2 a=0.25");
xlabel('SNR DB'); 
ylabel('SEP');