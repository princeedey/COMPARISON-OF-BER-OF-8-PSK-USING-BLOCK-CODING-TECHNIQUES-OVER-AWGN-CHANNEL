M = 8; % Modulation order
snr = 3:0.5:8; %snr range which is used while plotting
numFrames = 10; %No. of Frames
%PSK Modulation and Demodulaion
pskMod = comm.PSKModulator(M,'BitInput',true);
pskDemod = comm.PSKDemodulator(M,'BitOutput',true,...
'DecisionMethod','Approximate log-likelihood ratio');
pskuDemod = comm.PSKDemodulator(M,'BitOutput',true,...
'DecisionMethod','Hard decision');
%LDPC Encoder and Decoder Functions
ldpcEncoder = comm.LDPCEncoder;
ldpcDecoder = comm.LDPCDecoder;
errRate = zeros(1,length(snr));
uncErrRate = zeros(1,length(snr));
for ii = 1:length(snr)
ttlErr = 0;
ttlErrUnc = 0;
pskDemod.Variance = 1/10^(snr(ii)/10); % Set variance using current SNR
for counter = 1:numFrames
data = logical(randi([0 1],32400,1)); % Transmit and receiver uncoded signal
data
mod_uncSig = pskMod(data);
rx_uncSig = awgn(mod_uncSig,snr(ii),'measured');
14
demod_uncSig = pskuDemod(rx_uncSig);
numErrUnc = biterr(data,demod_uncSig);
ttlErrUnc = ttlErrUnc + numErrUnc; % Transmit and receive LDPC coded signal
data
encData = ldpcEncoder(data); %Data Encoding
modSig = pskMod(encData); %modulation of encoded data
rxSig = awgn(modSig,snr(ii),'measured');% Reception
demodSig = pskDemod(rxSig); %demoduation of the received data
rxBits = ldpcDecoder(demodSig); %decoding of the receivd demodulated data
numErr = biterr(data,rxBits);
ttlErr = ttlErr + numErr;
end
ttlBits = numFrames*length(rxBits);
uncErrRate(ii) = ttlErrUnc/ttlBits;%Uncoded data
errRate(ii) = ttlErr/ttlBits;%Coded Data
end
%plotting of the coded and uncoded data
semilogy(snr,uncErrRate,'c-',snr,errRate,'r')
%plot(snr,numErr,snr,uncErrRate,snr,errRate)
title('LDPC Coding for 8-PSK')
legend('Data','Uncoded', 'LDPC coded')
xlabel('Eb/No (dB)')
ylabel('BER')
grid on