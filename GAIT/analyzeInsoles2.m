function [leftSwingSignal,rightSwingSignal]=analyzeInsoles2(d,thres)
%%% CAPEMED METHOD FOR INSOLE DATA ANALYSIS
%%% COPYRIGHT 2023
%%% INPUTS
%%% d: Data with Insole Data (SmartInsoles dataset)
%%% thres: threshold for no pressure detection
%%% OUTPUTS
%%% leftSwingSignal: left leg swing signal
%%% rightSwingSignal: right leg swing signal
%%% res: stats

smoothWindow=51;
% Left presure signal
yL=max(d(:,2:17),[],2);
yL=yL-min(yL);
yL=medfilt1(yL,smoothWindow);
offThresL=thres;

leftSwingSignal=yL<offThresL;
leftSwingSignal=medfilt1(double(leftSwingSignal),smoothWindow)>0.5;

% Right presure signal
yR=max(d(:,27:42),[],2);
yR=yR-min(yR);
yR=medfilt1(yR,smoothWindow);
offThresR=thres;
rightSwingSignal=yR<offThresR;
rightSwingSignal=medfilt1(double(rightSwingSignal),smoothWindow)>0.5;

end