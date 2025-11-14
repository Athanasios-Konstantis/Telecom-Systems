function [SEP_user1,SEP_user2] = SEP_N(N_o)
fprit("%f",N_o);
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

I1 = [1,0,0,0;0,1,0,0;0,0,0,1;0,0,1,0];        %Makes the code not scalable because of the 
I2 = [1,0,0,0;0,1,0,0;0,0,0,1;0,0,1,0];        %hard coded table size and value     

P = I1 * P * I2;  %Helps with the indexing later!
%Initialize a matrix of all possible M-PAM points
v = zeros(1,M);
for r = 1:M
    v(r) = int8(2*r-M-1);
end

%Create a random bit string to transmit
SimSize = 100*M;     %SOS: Always has to be a constant times M
Bits = zeros(1,SimSize);

for i = 1:SimSize
    if(rand()> 0.5)
        Bits(i) = 1;
    end
end
%Create the matrix that stores all of the simulated points
Sim_user1 = zeros(1,SimSize/M + 1);
Sim_user2 = zeros(1, SimSize/M + 1);
Signal_Sent = zeros(1,SimSize/M + 1);
rng('default');

%Generate the simulated points with noise
SimIndex = 1;
for r = 1:M:SimSize
    x = [Bits(r) Bits(r+1) Bits(r+2) Bits(r+3)];
    index1 = bin2dec(num2str(x(1:2)))+1;
    index2 = bin2dec(num2str(x(3:4)))+1;
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

for r = 1:SimIndex
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
rng('default');
%Calculates subol mistakes in the sim for each user
errors_user1 = 0;
errors_user2 = 0;
for i = 1:SimIndex
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