function [SEP_user1,SEP_user2] = SEP_N0_MLD(N_o,randommode)
M = 4; %Number of M-PAM points
a=0.25;
dx = sqrt((3*a)/(M*M-1)); %distance of first point
dy = sqrt((3*(1-a))/(M*M-1));
Es1 = a;
Es2 = 1-a;
%N_o = 0.5;
c = 0.5;
%Initialize a matrix that contains all the possible constellation points
P = zeros(4,4);

for r = 1:M
    for q = 1:M
        P(q,r) = complex((2*r-M-1)*dx,(2*q-M-1)*dy);
    end
end

%Initialize a matrix of all possible M-PAM points
v = zeros(1,M);
for r = 1:M
    v(r) = int8(2*r-M-1);
end

%Create a random bit string to transmit
SimSize = 10e4;     %SOS: Always has to be a constant times M


index_array1=randi([1,4],1,SimSize);
index_array2=randi([1,4],1,SimSize);
%Create the matrix that stores all of the simulated points
Sim_user1 = zeros(1,SimSize);
Sim_user2 = zeros(1, SimSize);
Signal_Sent = zeros(1,SimSize);
rng(randommode);

%Generate the simulated points with noise
SimIndex = 1;
for r = 1:SimSize
    index1 = index_array1(r);
    index2 = index_array2(r);
    Re = real(P(index1,index2));
    Im = imag(P(index1,index2));
    Signal_Sent(SimIndex) = complex(Re,Im);
    %fprintf("Re: %f , Im: %f",Re,Im);
    ReNoise_user1 = normrnd(0,N_o/4);
    ImNoise_user1 = normrnd(0,N_o/4);
    ReNoise_user2 = normrnd(0,c*N_o/4);
    ImNoise_user2 = normrnd(0,c*N_o/4);
    Sim_user1(SimIndex) = complex((Re + ReNoise_user1),(Im + ImNoise_user1));
    Sim_user2(SimIndex) = complex((Re + ReNoise_user2), (Im + ImNoise_user2));
    SimIndex = SimIndex + 1;
end

%Each user reads their respective data
%calculate the minimum distance of each point and guess the result

mindistance_user1 = zeros(1,SimIndex);
result_user1 = zeros(1,SimIndex);

mindistance_user2 = zeros(1,SimIndex);
result_user2 = zeros(1,SimIndex);

for r = 1:(SimIndex-1)
    mindistance_user1(r) = abs(real(Sim_user1(r)) - v(1)*dx);
    result_user1(r) = v(1)*dx;

    mindistance_user2(r) = abs(imag(Sim_user2(r)) - v(1)*dy);
    result_user2(r) = v(1)*dy;

    for i = 1:M

        if(mindistance_user1(r) > abs(real(Sim_user1(r)) - v(i)*dx))
            mindistance_user1(r) = abs(real(Sim_user1(r)) - v(i)*dx);
            result_user1(r) = v(i)*dx;
        end

        if(mindistance_user2(r) > abs(imag(Sim_user2(r)) - v(i)*dy))
            mindistance_user2(r) = abs(imag(Sim_user2(r)) - v(i)*dy);
            result_user2(r) = v(i)*dy;
        end

    end
end
rng(randommode);
%Calculates subol mistakes in the sim for each user
errors_user1 = 0;
errors_user2 = 0;
for i = 1:(SimIndex-1)
    if(abs(result_user1(i) - real(Signal_Sent(i))) > 0.05)
        errors_user1 = errors_user1 + 1;
    end
    if(abs(result_user2(i) - imag(Signal_Sent(i))) > 0.05 )
        errors_user2 = errors_user2 + 1;
    end
end

SEP_user1 = errors_user1/SimSize;
SEP_user2 = errors_user2/SimSize;

end