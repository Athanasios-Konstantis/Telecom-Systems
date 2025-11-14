function Best_a()
ub=1;
lb=0;
Sep1=zeros(20,1);
Sep2=zeros(20,2);
SNR=zeros(20,1);
arrN0=zeros(20,1);
a_arr=zeros(20,1);

for k=1:20
    SNR(k)=k;
end    
    arrN0=10.^(-SNR/10);
for i=1:20
    objfun = @(a)septmetafun(arrN0(i),a);
    [a_arr(i)] = fminbnd(objfun,lb,ub);
    %minsep=SEP_N0(arrN0(i),a);
    clearvars objfun 
    %Sep1(i)=minsep(1);
    %Sep2(i)=minsep(2);
end
plot(SNR,a_arr);
xlabel('SNR DB'); 
ylabel('Best a');

end