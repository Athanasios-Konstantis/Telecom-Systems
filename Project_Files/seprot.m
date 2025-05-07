Sep1=zeros(20,1);
Sep2=zeros(20,2);
SNR=zeros(20,1);
arrN0=zeros(20,1);
theta=deg2rad( 26.565);
for k=1:20
    SNR(k)=k;
end    
    arrN0=10.^(-SNR/10);
for i=1:20
    [Sep1(i),Sep2(i)]=SEP_N0_rot(arrN0(i),theta);

end

semilogy(SNR,Sep1,SNR,Sep2);
xlabel('SNR DB'); 
ylabel('SEP');
hold on
legend('UE1','UE2','Location','northeast')


figure;

semilogy(SNR,Sep1);
title("UE1 theta=26.565 degrees");
xlabel('SNR DB'); 
ylabel('SEP 1');


hold on;
figure;

semilogy(SNR,Sep2);
title("UE2 theta=26.565 degrees");
xlabel('SNR DB'); 
ylabel('SEP 2');
 
hold on
figure

semilogy(SNR,Sep1,SNR,Sep2);
xlabel('SNR DB'); 
ylabel('SEP');

