function Best_theta()
ub=pi/4;
lb=0;
Sep1=zeros(20,1);
Sep2=zeros(20,2);
SNR=zeros(20,1);
arrN0=zeros(20,1);
theta_arr=zeros(20,1);

for k=1:20
    SNR(k)=k;
end    
    arrN0=10.^(-SNR/10);
for i=1:20
    objfun = @(theta)seprotfun(arrN0(i),theta);
    [theta_arr(i)] = (180/pi)*fminbnd(objfun,lb,ub);
    clearvars objfun 
end
plot(SNR,theta_arr);
xlabel('SNR DB'); 
ylabel('Best theta');

end