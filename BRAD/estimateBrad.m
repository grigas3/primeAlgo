function rmsBrad=estimateBrad(time,d)
%%% CAPEMED COPYRIGHT 2023
%%% TREMOR ENERGY ESTIMATOR
%%% Method to estimate an index of tremor intensity based on the PSD of the
%%% gyroscope (or accelerometer) data.
%%% THe method uses window of 128 samples which for a 50 Hz is about 2.5 seconds
%%% Input
%%% time: Timestamp (Unix/milliseconds)
%%%  d : Gyro (X,Y,Z)
%%% Outpit
%%% rmsBrad;

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
rmsBrad=zeros(L,1);
for jj=1:L
    
    %%% Get Window
    sindex=(jj-1)*W+1:jj*W;  
    
    y=d(sindex,:);
    
    %%% Estimate PSD for all gyro Channels
    for kk=1:3
        y1=y(:,kk);
        y1=y1-mean(y1);
        y(:,kk)=y1;
    end
   rmsBrad(jj)= mean(sqrt(sum(y.^2,2)));
        
     
end
