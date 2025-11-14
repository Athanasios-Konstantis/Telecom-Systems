Sep1=zeros(1000,1);
Sep2=zeros(1000,1);
h=zeros(2,1);
i=1;
arrN0=0:0.001:1;
SNR=-10*log10(arrN0);
for k=1:5
for N0=0:0.001:1
    [h(1),h(2)]=SEP_N(N0,k);
    if k==1
    Sep1(i)=h(1);
    Sep2(i)=h(2);
    else
    Sep1(i)=(Sep1(i)+h(1))/2;
    Sep2(i)=(Sep2(i)+h(2))/2;
    end    
    i=i+1;
end
i=1;
end

semilogy(SNR,Sep1);
xlabel('SNR DB'); 
ylabel('SEP1');
