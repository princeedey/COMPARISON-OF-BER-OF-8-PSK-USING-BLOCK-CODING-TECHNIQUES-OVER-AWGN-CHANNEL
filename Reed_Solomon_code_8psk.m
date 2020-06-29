clc
clear all
close all
M = 8; % Modulation order
bps = log2(M); % Bits per symbol
N = 7; % RS codeword length
K = 5; % RS message length
% PSK Modulation
pskModulator = comm.PSKModulator('ModulationOrder',M,'BitInput',true);
pskDemodulator = comm.PSKDemodulator('ModulationOrder',M,'BitOutput',true);
awgnChannel = comm.AWGNChannel('BitsPerSymbol',bps);
errorRate = comm.ErrorRate;
% RS Encoder and Decoder Functions
rsEncoder = comm.RSEncoder('BitInput',true,'CodewordLength',N,'MessageLength',K);
rsDecoder = comm.RSDecoder('BitInput',true,'CodewordLength',N,'MessageLength',K);
ebnoVec = (3:0.5:8)';
errorStats = zeros(length(ebnoVec),3);
for i = 1:length(ebnoVec)
awgnChannel.EbNo = ebnoVec(i);
reset(errorRate)
while errorStats(i,2) < 100 && errorStats(i,3) < 1e7
data = randi([0 1],1500,1); % Generate binary data
encData = rsEncoder(data); % RS encode
modData = pskModulator(encData); % Modulate
rxSig = awgnChannel(modData); % Pass signal through AWGN
rxData = pskDemodulator(rxSig); % Demodulate
13
decData = rsDecoder(rxData); % RS decode
errorStats(i,:) = errorRate(data,decData); % Collect error statistics
end
end
% Plotting of curves to observe BER
berCurveFit = berfit(ebnoVec,errorStats(:,1));
berNoCoding = berawgn(ebnoVec,'psk',8,'nondiff');
semilogy(ebnoVec,errorStats(:,1),'b*', ...
ebnoVec,berCurveFit,'c-',ebnoVec,berNoCoding,'r')
title('Reed Solomon Coding for 8 PSK')
ylabel('BER')
xlabel('Eb/No (dB)')
legend('Data','Curve Fit','No Coding')
grid