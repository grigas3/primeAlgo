function [psdEnergies]=estimateDyskinesia(time,d)
%%% CAPEMED COPYRIGHT 2023
%%% DYSKINESIA ENERGY ESTIMATOR
%%% Method to estimate an index of tremor intensity based on the PSD of the
%%% gyroscope (or accelerometer) data.
%%% THe method uses window of 128 samples which for a 50 Hz is about 2.5 seconds
%%% Input
%%% time: Timestamp (Unix/milliseconds)
%%%  d : Gyro (X,Y,Z)

%%%%%% FIND FS
dd=diff(time);
ii=find(dd<1000);
FS=1000/mean(dd(ii));

%%% Parameters
N=size(d,1);
W=floor(128);
L=floor(N/W);
dispPlot=0;

if(dispPlot)
figure,
end
fs=linspace(0,FS,W);
N1 = W;
psdEnergies=zeros(L,1);
mEnergies=zeros(L,1);
for jj=1:L
    
    %%% Get Window
    sindex=(jj-1)*W+1:jj*W;
    
    psdxT=zeros(W/2+1,1);
    %%% Estimate PSD for all gyro Channels
    for kk=1:3
        y=d(sindex,kk);
        y=y-mean(y);
        
        xdft = fft(y,N1);
        xdft = xdft(1:floor(N1/2)+1);
        ff1=fs(1:floor(N1/2)+1);
        psdx = 2*abs(xdft)/N1;%(1/(FS*N1)) * abs(xdft).^2;
        psdxT=psdxT+psdx;
    end
    %%% Frequency Bands
    findex1=find(ff1>=3.5&ff1<7);
    findex2=find(ff1>0&ff1<3.5);
    e1=sum(psdxT(findex1))+0.00001; %%% Energy of 3.5-7 Hz
    e2=sum(psdxT(findex2))+0.00001; %%% Energy of 0-3.5 Hz
    w1=sigmf(e2/(e1+e2),[10 0.5]); %%% Weight
       
    
    psdEnergies(jj)=w1*e2+0.00001; %%% Total Tremor Index
    
    if(dispPlot)
        hold on,plot(ff1,psdxT)              
    end
    
end
