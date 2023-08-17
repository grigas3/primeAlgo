close all

%%% Patient With Tremor 0
d=load('2023071130648_LW_stream.csv');


%%
bradEst=[];
bradInt=[];
%%% Eclude Test regions
testRegions=[60500 60760 ; 94250 94550];
for jj=1:size(testRegions,1)    
    
    p=estimateBrad(d(testRegions(jj,1):testRegions(jj,2),1),d(testRegions(jj,1):testRegions(jj,2),5:7)/20); 
    bradEst=[bradEst;p];
    bradInt=[bradInt;ones(size(p,1),1)];
end

%% P2
%%% Patient With Tremor 2-3
d=load('2023071121320_LW_stream.csv');


%%
%%% Eclude Test and no tremor regions
testRegions=[34200 34600;45900 46200;49000 49300; 58800 59200;62000 63000; 64200 64500; 66800 67300;76300 76600;92000 92400;95300 95500;96500 97500;100500 101000;103200 103700 ];
bradEstM=[];
for jj=1:size(testRegions,1)    
  
    
    p=estimateBrad(d(testRegions(jj,1):testRegions(jj,2),1),d(testRegions(jj,1):testRegions(jj,2),5:7)/20); 
    bradEst=[bradEst;p];
    bradEstM=[bradEstM;max(p)];
    bradInt=[bradInt;2*ones(size(p,1),1)];

end

%%
% t1= -1.3631*(p1)+9.36;
% t2= -1.3631*(p2)+9.36;
%     t1(t1<0)=0;
%     t1(t1>4)=4;
%     
%     t2(t2<0)=0;
%     t2(t2>4)=4;

%%
figure,

boxplot(bradEst,bradInt)
