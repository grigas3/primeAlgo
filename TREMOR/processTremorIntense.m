close all

%%% Patient With Tremor 0
d=load('2023071130648_LW_stream.csv');



%%% Eclude Test regions
excludeRegions=[9350 14500 ;58000 66000;93500 95000];
for jj=1:size(excludeRegions,1)    
   d(excludeRegions(jj,1):excludeRegions(jj,2),2:end)=0.5;
end
p1=estimateTremor(d(:,1),d(:,5:7)/20);

%%% Patient With Tremor 2-3
d=load('2023071121320_LW_stream.csv');



%%% Eclude Test and no tremor regions
excludeRegions=[55000 70000];
for jj=1:size(excludeRegions,1)    
   d(excludeRegions(jj,1):excludeRegions(jj,2),2:end)=0.0;
end

p2=estimateTremor(d(:,1),d(:,5:7)/20);
%%
t1=log(p1)*0.7700-1.3549;
t2=log(p2)*0.7700-1.3549;
    t1(t1<0)=0;
    t1(t1>4)=4;
    
    t2(t2<0)=0;
    t2(t2>4)=4;

%%
figure,

boxplot([t1;t2],[ones(size(p1,1),1);2*ones(size(p2,1),1)])

%%
C=[ones(size(p1,1),1);2*ones(size(p2,1),1)];

D1=[p1;p2];
D=[t1;t2];
C(D1<5)=1;

  labels=cell(size(C,1),1);
    for rr=1:size(C,1)
        if(C(rr)==1)           
            labels{rr}='No';
        else
            labels{rr}='Yes';
        end
        
    end
    
    
   classes=C;
    scores=D;
    [X,Y,T,AUC,OPTROCPT] =  perfcurve(labels,scores,'Yes');
    
    thres=T((X==OPTROCPT(1))&(Y==OPTROCPT(2)));
    conf=zeros(2);
    conf(1,1)=sum((scores<thres)&(classes==1));
    conf(1,2)=sum((scores>=thres)&(classes==1));
    conf(2,1)=sum((scores<thres)&(classes==2));
    conf(2,2)=sum((scores>=thres)&(classes==2));
     
    
    
    figure,boxplot(D,C)
%      
%     
%     fprintf('%i AUC=%f with thres %f (N: %d vs %d) Corr UPDRS-%s with PDMonitor %s %f ttest p-value %f (%i->%i)\n  ',jj,AUC,thres,sum(classes==0),sum(classes==1), updrsLabels{jj},pdOutcomes{bb},a,pA(1),b,b1);
%   
