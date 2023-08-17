function [steps swingtime steptime]=extractGaitMeasures(stanceTime,timeThres,dt)

 if ~exist('dt','var')
     % third parameter does not exist, so default it to something
     dt=0.01;
 end



y=medfilt1(stanceTime,15);
prevy=-1;
prevjj=-1;
firsty=-1;
steps=0;
swingtime=0;
steptime=0;
%figure,plot(stanceTime)
for jj=2:length(y)
    
    if(y(jj)==0&y(jj-1)==1&prevy>0&(jj-prevy)*dt<timeThres)
        
        steps=steps+1;
        swingtime=swingtime+(jj-prevy)*dt;
        if(prevjj>0)
            steptime=steptime+(jj-prevjj)*dt;
        end
        prevjj=jj;
        %hold on,plot([prevy prevy jj jj],[0 1 1 0],'r-')
    end
    
    if(y(jj)==0)
        
        if(firsty<0)
            firsty=jj;
        end
        
        prevy=jj;         
        
    end
    
end



%cadence=120*steps/(prevy-firsty)*dt;
swingtime=swingtime/steps;
steptime=steptime/steps;

end