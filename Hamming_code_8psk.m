clear all;
close all;
clc;
%Len = input('Please input the number of bits you want to transmit/analyse =');
%Vo = input('Please input positive antipodal Voltage you want to transmit =');
Len = 200000;
Vo = 5;
%Generation of Random , zero mean signal composed of ones and zeros
Sig = round(rand(1,Len));
%Generator Matrix
genmat = [1 0 0 0 1 1 0;0 1 0 0 0 1 1;0 0 1 0 1 0 1;0 0 0 1 1 1 1];
% Generation of Parity check matrix
parmat = gen2par(genmat);
%Generation of Syndrome looup
t = syndtable(parmat);
%Generation of a Codes
a2 = 0; a3 = 1; a4 = []; Sig2 = []; a6 = 1; sig = [];
for a2 = 4:4:length(Sig)
a4 = mod(Sig(a3:a2)*genmat,2);
a3 = a3+4;
Sig2(a6:a6+6) = a4;
a6 = a6+7;
end
%Antipodal Voltage for normal signal
anpovo1= Vo * Sig-1;
%Antipodal Voltage for Encoded signal
anpovo2= Vo * Sig2-1;
%Different SNRs
snr = 0:1:20;
%E/N for ideal system
Eb_No=10.^(snr/10);
%%
%Loop for normal signal
for l = 1:length(snr);
rx_sig = awgn(anpovo1,snr(l),'measured');
%Signal deceision
for k = 1:1:Len
if rx_sig(k)>0
a(k)=1;
else
a(k)=0;
end
end
[number0(l) BER0(l)]=biterr(Sig,a);
q_x(l)=qfunc(Eb_No(l));
end
%%
%Loop for encoded signal
for m = 1:length(snr);
rx_sig2 = awgn(anpovo2,snr(m),'measured');
%Signal deceision
for k = 1:1:length(anpovo2)
if rx_sig2(k)>0
b(k)=1;
else
b(k)=0;
end
end
msg = decode(b,7,4,'linear',genmat,t);
[number1(m) BER1(m)]=biterr(Sig,msg);
end
%% Plotting
semilogy(snr,BER0,'-b*',snr,BER1,'-r*');
grid on
legend('Unencoded','Encoded')
axis([0 20 0.0001 1]);
title('Hamming Code')
xlabel('SNR')
ylabel('BER(log)')