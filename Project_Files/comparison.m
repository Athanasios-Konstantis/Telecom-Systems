

a=2/3;
Sep1_sys1=zeros(20,1);
Sep2_sys1=zeros(20,2);
Sep1_sys2=zeros(20,1);
Sep2_sys2=zeros(20,2);
Sep_sys1=zeros(20,1);
Sep_sys2=zeros(20,2);

SNR=zeros(20,1);
arrN0=zeros(20,1);
theta=deg2rad( 26.565);
for k=1:20
    SNR(k)=k;
end    
    arrN0=10.^(-SNR/10);
for i=1:20
    [Sep1_sys1(i),Sep2_sys1(i)]=SEP_N0(arrN0(i),a);
    Sep_sys1(i)=max(Sep1_sys1(i),Sep2_sys1(i));
    [Sep1_sys2(i),Sep2_sys2(i)]=SEP_N0_rot(arrN0(i),theta);
    Sep_sys2(i)=max(Sep1_sys2(i),Sep2_sys2(i));
end


semilogy(SNR,Sep_sys1,SNR,Sep_sys2);
title("Comparison of max SEP in System 1 and 2");
xlabel('SNR DB'); 
ylabel('SEP');
legend('System 1','System 2','Location','northeast')






