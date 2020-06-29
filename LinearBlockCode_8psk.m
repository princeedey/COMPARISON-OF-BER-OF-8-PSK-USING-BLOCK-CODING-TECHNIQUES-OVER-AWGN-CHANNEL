clc;
clear all;
close all;
n = 23; % Codeword length
k = 12; % Message length
dmin = 7; % Minimum distance
ebno = (3:0.5:8)';
uncodedBER = berawgn(ebno,'psk',8,'nondiff');
codedBER = bercoding(ebno,'block','hard',n,k,dmin);
semilogy(ebno,uncodedBER,'-b',ebno, codedBER,'*-r')
grid
title('Linear Block Code for 8 PSK');
legend('Uncoded BER','Coded BER')
xlabel('Eb/No (dB)')
ylabel('BER')