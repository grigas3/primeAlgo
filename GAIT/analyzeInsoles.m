function [leftSwingSignal,rightSwingSignal,res]=analyzeInsoles(d,thres)
%%% CAPEMED METHOD FOR INSOLE DATA ANALYSIS
%%% COPYRIGHT 2023
%%% INPUTS
%%% d: Data with Insole Data (SmartInsoles dataset)
%%% thres: threshold for no pressure detection
%%% OUTPUTS
%%% leftSwingSignal: left leg swing signal
%%% rightSwingSignal: right leg swing signal
%%% res: stats
% Left presure signal
yL=max(d(:,2:17),[],2);
yL=yL-min(yL);
offThresL=thres;


% Right presure signal
yR=max(d(:,27:42),[],2);
yR=yR-min(yR);
offThresR=thres;

% x=d(:,1);
dt=0.01;%mean(diff(x));
%Init Parameters
totalSwingTimeL=0;
totalStanceTimeL=0;
swingTimeL=0;
stanceTimeL=0;
stanceCountL=0;
swingCountL=0;
stancePhaseL=0;
swingPhaseL=0;
totalSwingTimeR=0;
totalStanceTimeR=0;
swingTimeR=0;
stanceTimeR=0;
stanceCountR=0;
swingCountR=0;
stancePhaseR=0;
swingPhaseR=0;

totaldoubleSupport=0;
firstStepIndex=-1;
lastStepIndex=-1;
doubleSupport=0;
doubleSupportPhase=0;
doubleSupportCount=0;
leftSwingSignal=zeros(length(yL),1);
rightSwingSignal=zeros(length(yL),1);

for jj=1:length(yL)
    
   %% LEFT LEG
    if(yL(jj)<offThresL) % when signal less than thres then foot has contact (no swing)
        
        
        if(firstStepIndex==-1)
            firstStepIndex=jj;
        end
        if(stancePhaseL==1)
            
            if(stanceTimeL>0.2)
                totalStanceTimeL=totalStanceTimeL+stanceTimeL;
                stanceCountL=stanceCountL+1;
            end
            stanceTimeL=0;
        end
        
        stancePhaseL=0;
        swingPhaseL=1;
        swingTimeL=swingTimeL+dt;
        leftSwingSignal(jj)=1;
    else
        
        if(swingPhaseL==1)
            
            if(lastStepIndex<jj)
                lastStepIndex=jj;
            end
            
            if(swingTimeL>0.2)
                totalSwingTimeL=totalSwingTimeL+swingTimeL;
                swingCountL=swingCountL+1;
            end
            swingTimeL=0;
        end
        swingPhaseL=0;
        
        stancePhaseL=1;
        stanceTimeL=stanceTimeL+dt;

        %%%% Double Support
        if(stancePhaseR==1)
            
            doubleSupportPhase=1;
            doubleSupport=doubleSupport+dt;
        else
            
            if(doubleSupportPhase==1)
                
                totaldoubleSupport=totaldoubleSupport+doubleSupport;
                doubleSupportCount=doubleSupportCount+1;
                doubleSupport=0;
            end
            
            doubleSupportPhase=0;
        end
    end
    
    
    %% RIGHT LEG
    if(yR(jj)<offThresR) % when signal less than thres then foot has contact (no swing)
        
        if(firstStepIndex==-1)
            firstStepIndex=jj;
        end
        if(stancePhaseR==1)
            
            if(stanceTimeR>0.2)
                totalStanceTimeR=totalStanceTimeR+stanceTimeR;
                stanceCountR=stanceCountR+1;
            end
            stanceTimeR=0;
        end
        stancePhaseR=0;
        swingPhaseR=1;
        swingTimeR=swingTimeR+dt;
        
        rightSwingSignal(jj)=1;
    else
        
        if(swingPhaseR==1)
            
            if(lastStepIndex<jj)
                lastStepIndex=jj;
            end
            
            if(swingTimeR>0.2)
                totalSwingTimeR=totalSwingTimeR+swingTimeR;
                swingCountR=swingCountR+1;
                
            end
            swingTimeR=0;
        end
        swingPhaseR=0;
        stancePhaseR=1;
        stanceTimeR=stanceTimeR+dt;
        
    end
end






totalSwingTimeL=totalSwingTimeL/swingCountL;
totalStanceTimeL=totalStanceTimeL/stanceCountL;
totalSwingTimeR=totalSwingTimeR/swingCountR;
totalStanceTimeR=totalStanceTimeR/stanceCountR;
totaldoubleSupport=totaldoubleSupport/doubleSupportCount;
res={};
res.totalSwingTimeL=totalSwingTimeL;
res.totalSwingTimeR=totalSwingTimeR;
res.totalStanceTimeR=totalStanceTimeR;
res.totalStanceTimeL=totalStanceTimeL;
res.totaldoubleSupport=totaldoubleSupport;

end