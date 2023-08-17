%%% CAPEMED COPYRIGHT 2023
%%% EVALUATION OF TREMOR INTENSITY ESTIMATOR

d=importData('10ca3512-ff6d-4697-af2e-15f809664324.txt');

time=posixtime(d.VarName1);
data=[d.VarName2 d.VarName3 d.VarName4];


%% Tremor of intensity 0, 2,3 and 4.
figure,plot(data(:,1:3))
regions=[3800 4300;600 1800;2600 3600;4600 6200];

tremorEst=[];
mEst=[];
tremorInt=[];

for jj=1:size(regions,1)    
    %%% Estimate Tremor Intensity for each region
    [p m]=estimateTremor(time(regions(jj,1):regions(jj,2))*1000,data(regions(jj,1):regions(jj,2),:));    
    tremorEst=[tremorEst;p];
    mEst=[mEst;m];
    tremorInt=[tremorInt;jj*ones(size(p,1),1)];
end


tremorInt(tremorInt==1)=0;

%% Tremor of very low intensity for tremor 1
d0=importData('592b56b5-8b3b-4162-aa4a-6aa7fecaca72.txt');
time=posixtime(d0.VarName1);
data=[d0.VarName2 d0.VarName3 d0.VarName4];
figure,plot(data(:,1:3))
regions=[1400 2600];

for jj=1:size(regions,1)    
    [p m]=estimateTremor(time(regions(jj,1):regions(jj,2))*1000,data(regions(jj,1):regions(jj,2),:));
    
    tremorEst=[tremorEst;p];
    mEst=[mEst;m];
    tremorInt=[tremorInt;ones(size(p,1),1)];
end
%%

ii=find(tremorEst>5);

yA=zeros(size(tremorEst,1),1);
%%% Box plot

%%% Calc of Tremor Intensity Score
xt=log(tremorEst(ii));
b=robustfit(xt,tremorInt(ii))
y=b(2)*xt+b(1);

yA(ii)=y;
%boxplot(yA,tremorInt);

%%% Bland Altman
BlandAltman(tremorInt,yA,{'Tremor Intensity','Tremor Score'})


%% Data with dyskinesia
d=importData('7c4ba046-0a1d-40d8-9280-f3b2343291f4.txt');

time=posixtime(d.VarName1);
data=[d.VarName2 d.VarName3 d.VarName4];
regions=[1000 4000;5000 6700];
%%
for jj=1:size(regions,1)    
    [p m]=estimateTremor(time(regions(jj,1):regions(jj,2))*1000,data(regions(jj,1):regions(jj,2),:));
    
    tremorEst=[tremorEst;p];
    mEst=[mEst;m];
    tremorInt=[tremorInt;zeros(size(p,1),1)];
end
%%


p1=tremorEst(find(tremorInt==0));
p2=tremorEst(find(tremorInt>1));

C=[ones(size(p1,1),1);2*ones(size(p2,1),1)];

D=[p1;p2];


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


