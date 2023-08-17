close all
%%% Patient With Tremor 0
d=load('.\IMUData\2023071121320_LL_stream.csv');



%% Gait Regions
regions=[157000 157500;158030 158700;];
results=zeros(size(regions,1),3);
for jj=1:size(regions,1)    
  [swingSignalL]=analyzeIMU2(d([regions(jj,1):regions(jj,2)],5)/16.384)
  [stepsL1 swingTimeL1 stepTimeL1]=extractGaitMeasures(double(swingSignalL),0.8,0.02);
  results(jj,:)=[stepsL1 swingTimeL1 stepTimeL1];
end
