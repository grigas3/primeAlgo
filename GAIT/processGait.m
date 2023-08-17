close all;
d=load('imuData14.txt');
channelL=24;
channelR=49;
x=d(:,1);
yL=d(:,channelL);
%yL=medfilt1(yL,15);
d1=min(yL);
d2=max(yL);

offThresL=d1+0.2*(d2-d1);


yR=d(:,channelR);
%yR=medfilt1(yR,15);
d1=min(yR);
d2=max(yR);

offThresR=d1+0.2*(d2-d1);


dt=0.01;%mean(diff(x));

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

figure,plot(x,yL)
hold on,plot(x,yR)
lastStance=0;
lastSwing=0;
minS=floor(0.2/dt);
firstStepIndex=-1;
lastStepIndex=-1;
doubleSupport=0;
doubleSupportCount=0;
for jj=1:length(yL)
    
    if(yL(jj)<offThresL)
        
        
        if(firstStepIndex==-1)
           firstStepIndex=jj; 
        end
        if(stancePhaseL==1)
            
            if(stanceTimeL>0.2)
                hold on,plot(x(jj),yL(jj),'ro')
                totalStanceTimeL=totalStanceTimeL+stanceTimeL;
                stanceCountL=stanceCountL+1;
            end
            stanceTimeL=0;
        end
        
        stancePhaseL=0;
        swingPhaseL=1;
        swingTimeL=swingTimeL+dt;
        
    else
    
    if(swingPhaseL==1)
         
        if(lastStepIndex<jj)
           lastStepIndex=jj; 
        end
        
        if(swingTimeL>0.2)
            hold on,plot(x(jj),yL(jj),'r+')
            totalSwingTimeL=totalSwingTimeL+swingTimeL;
            swingCountL=swingCountL+1;            
        end
        swingTimeL=0;
    end
        swingPhaseL=0;
        
        stancePhaseL=1;
        stanceTimeL=stanceTimeL+dt;
        
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
    
    
    %%%%%% RIGHT LEG
    if(yR(jj)<offThresR)
        
           if(firstStepIndex==-1)
           firstStepIndex=jj; 
        end
        if(stancePhaseR==1)
            
            if(stanceTimeR>0.2)
                hold  on,plot(x(jj),yR(jj),'mo')
                totalStanceTimeR=totalStanceTimeR+stanceTimeR;
                stanceCountR=stanceCountR+1;
            end
            stanceTimeR=0;
        end
        stancePhaseR=0;
        swingPhaseR=1;
        swingTimeR=swingTimeR+dt;
        
    else
    
    if(swingPhaseR==1)
        
        if(lastStepIndex<jj)
           lastStepIndex=jj; 
        end
        
        if(swingTimeR>0.2)
            hold on,plot(x(jj),yR(jj),'m+')
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

fprintf('Total Test duration %i %i %f \n',lastStepIndex,firstStepIndex,(lastStepIndex-firstStepIndex)*dt);
