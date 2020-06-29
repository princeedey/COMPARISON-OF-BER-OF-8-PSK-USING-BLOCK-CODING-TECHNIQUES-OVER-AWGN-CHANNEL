clc
clear all
close all
%Setting the message signal for modulation
M = 8; % Modulation order
11
bps = log2(M); % Bits per symbol
N = 7; % BCH codeword length
K = 4; % BCH message length
%Since it's 8-PSK, we are going to use the PSK Modulator and De-modulator
%from the toolbox along with the AWGN channel
pskModulator = comm.PSKModulator('ModulationOrder',M,'BitInput',true);
pskDemodulator = comm.PSKDemodulator('ModulationOrder',M,'BitOutput',true);
awgnChannel = comm.AWGNChannel('BitsPerSymbol',bps);
%We are dedicating a variable for error rate calculation and calling the BCH
%encoder and decoder for encoding and decoding the message signal
errorRate = comm.ErrorRate;
BCHencoder = comm.BCHEncoder; %creates a BCH encoder System object that performs BCH
encoding.
BCHdecoder = comm.BCHDecoder; %creates a BCH decoder System object that performs BCH
decoding.
%Declaring a variable with snr/ebno of a particular range and initializing
%errorStats variable with a zero vector
ebnoVec = (3:0.5:8)';
errorStats = zeros(length(ebnoVec),3);
%Modulation and Demodulation along with BER calculation
for i = 1:length(ebnoVec) %Looping through the range of snr
awgnChannel.EbNo = ebnoVec(i); %Initializing AWGN channel with the
value of i
reset(errorRate) %Resetting the value of error Rate for
precise calculation
while errorStats(i,2) < 100 && errorStats(i,3) < 1e7 %Condition check
data = randi([0 1],1500,1); %Generate binary data
encData = step(BCHencoder,data); %Returns estimated message
based on encoder and data
modData = pskModulator(encData); %Modulate using PSK
modulator
rxSig = awgnChannel(modData); %Pass signal through AWGN
rxData = pskDemodulator(rxSig); %Demodulate using PSK
demodulator
decData = step(BCHdecoder,rxData); %Returns the estimated
message after decoding based on decoder and data
errorStats(i,:) = errorRate(data,decData); %Collect error statistics
end
end
berCurveFit = berfit(ebnoVec,errorStats(:,1)) %Best fit curve is obtained
berNoCoding = berawgn(ebnoVec,'psk',8,'nondiff')
semilogy(ebnoVec,errorStats(:,1),'b*', ...
ebnoVec,berCurveFit,'c-',ebnoVec,berNoCoding,'r') %Semilog graph is drawn
title('BCH Coding for 8 PSK')
ylabel('BER') %Relevant titles for x and y axis
are given
xlabel('Eb/No (dB)')
legend('Data','Curve Fit','No Coding')
grid