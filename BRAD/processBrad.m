%%% CAPEMED COPYRIGHT 2023
%%% EVALUATION OF brad INTENSITY ESTIMATOR

d=importData('3b1e3ddb-5927-4f7f-919f-4853297a3ee8.txt');

time=posixtime(d.VarName1);
data=[d.VarName2 d.VarName3 d.VarName4];


%% brad of intensity 0, 2,3 and 4.
figure,plot(data(:,1:3))
regions=[500 1500;2400 2800;];

bradEst=[];
bradInt=[];
for jj=1:size(regions,1)    
    %%% Estimate brad Intensity for each region
    p=estimateBrad(time(regions(jj,1):regions(jj,2))*1000,data(regions(jj,1):regions(jj,2),:));    
    bradEst=[bradEst;p];
    bradInt=[bradInt;jj*ones(size(p,1),1)];
end


%%
%%% Box plot
boxplot((bradEst),bradInt);

minE=mean(bradEst(bradInt)==1);
maxE=mean(bradEst(bradInt)==2);
cbradInt=bradInt;
cbradInt(bradInt==1)=4;
cbradInt(bradInt==2)=0;
fprintf('Min Brad speed %f\n Max Brad Speed %f\n',minE,maxE)
%%% Calc of brad Intensity Score
 xt=log(bradEst);
 b=robustfit(xt,cbradInt)
 y=b(2)*xt+b(1);
% 
% %%% Bland Altman
 BlandAltman(cbradInt,y,{'Brad Annotation','Brad Score'})
