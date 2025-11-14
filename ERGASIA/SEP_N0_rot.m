function [SEP_user1,SEP_user2] = SEP_N0_rot(N_o,theta)
M = 4; %Number of M-PAM points
E=1;
%N_o = 0.5;
c = 0.5;
%Initialize a matrix that contains all the possible constellation points
P = zeros(1,4);
inirot=pi/4;
for r = 1:M
        P(r) = complex(E*cos(theta+inirot*(2*r-1)),E*sin(theta+inirot*(2*r-1)));
end

%Initialize a matrix of all possible M-PAM points
rePam = zeros(1,M);
imPam=zeros(1,M);
dre=zeros(1,3);
dim=zeros(1,3);
rePam(1) = real(P(2));
rePam(2) = real(P(3));
rePam(3) = real(P(1));
rePam(4) = real(P(4));
imPam(1) = imag(P(3));
imPam(2) = imag(P(4));
imPam(3) = imag(P(2));
imPam(4) = imag(P(1));
dre(1)=(rePam(1)+rePam(2))*0.5;
dre(2)=(rePam(2)+rePam(3))*0.5;  %it will surely be zero though we will check on it later
dre(3)=(rePam(3)+rePam(4))*0.5;  %i think that dre(3)=-dre(1)
dim(1)=(imPam(1)+imPam(2))*0.5;
dim(2)=(imPam(2)+imPam(3))*0.5;  %it will surely be zero though we will check on it later
dim(3)=(imPam(3)+imPam(4))*0.5;  %i think that dim(3)=-dim(1)


%Create a random bit string to transmit
SimSize = 10e6;     %SOS: Always has to be a constant times M


index_array=randi([1,4],1,2*SimSize);
%Create the matrix that stores all of the simulated points
Sim_user1 = zeros(1,SimSize);
Sim_user2 = zeros(1, SimSize);
Signal_Sent = zeros(1,SimSize);


%Generate the simulated points with noise
SimIndex = 1;
for r = 1:2:2*SimSize
    index1 = index_array(r);
    index2=index_array(r+1);
    Re = real(P(index1));
    Im = imag(P(index2));
    Signal_Sent(SimIndex) = complex(Re,Im);
    %fprintf("Re: %f , Im: %f",Re,Im);
    ReNoise_user1 = randn()*sqrt(N_o/4);
    ImNoise_user1 = randn()*sqrt(N_o/4);
    ReNoise_user2 = randn()*sqrt(c*N_o/4);
    ImNoise_user2 = randn()*sqrt(c*N_o/4);
    Sim_user1(SimIndex) = complex((Re + ReNoise_user1),(Im + ImNoise_user1));
    Sim_user2(SimIndex) = complex((Re + ReNoise_user2), (Im + ImNoise_user2));
    SimIndex = SimIndex + 1;
end

%Each user reads their respective data
%guess the symvbol


result_user1 = zeros(1,SimIndex);

result_user2 = zeros(1,SimIndex);

for r = 1:(SimIndex-1)
    if(real(Sim_user1(r))<dre(1))
        result_user1(r) = rePam(1);
    elseif(real(Sim_user1(r))<dre(2))
        result_user1(r) = rePam(2);
    elseif(real(Sim_user1(r))<dre(3))
        result_user1(r) = rePam(3);
    else
        result_user1(r) = rePam(4);
    end

    if(imag(Sim_user2(r))<dim(1))
        result_user2(r) = imPam(1);
    elseif(imag(Sim_user2(r))<dim(2))
        result_user2(r) = imPam(2);
    elseif(imag(Sim_user2(r))<dim(3))
        result_user2(r) = imPam(3);
    else
        result_user2(r) = imPam(4);
    end

end


%Calculates subol mistakes in the sim for each user
errors_user1 = 0;
errors_user2 = 0;
for i = 1:(SimIndex-1)
    if(result_user1(i)~=real(Signal_Sent(i)))
        errors_user1 = errors_user1 + 1;
    end
    if(result_user2(i)~=imag(Signal_Sent(i)))
        errors_user2 = errors_user2 + 1;
    end
end

SEP_user1 = errors_user1/SimSize;
SEP_user2 = errors_user2/SimSize;

end