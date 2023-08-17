function [swingSignalL,swingSignalR]=analyzeIMU(d1)
yL=-d1(:,22);
yR=-d1(:,47);
thres=10;

[a b]=crossing(yL,[],thres);

[pk loc]=findpeaks(yL,'MinPeakHeight',150,'MinPeakDistance',50);
swingSignalL=zeros(size(yL,1),1);

if(0)
    plot(yL)  
    end
for jj=1:length(loc)
    
    i1=find(a<loc(jj));
    
    
    i2=find(a>loc(jj));
    if(length(i1)>0&length(i2)>0)
        i2=a(i2(1));
        i1=a(i1(end));
        if(loc(jj)-i1<50&i2-loc(jj)<50)
            
            swingSignalL(i1:i2)=1;
            
            if(0)
                hold on,plot(loc(jj),yL(loc(jj)),'ro')
                
                hold on,plot(i1,thres,'mo')
                hold on,plot(i2,thres,'ko')
                
                
                
            end
            
        end
        
    end
end



%% Right Leg
[a b]=crossing(yR,[],thres);

[pk loc]=findpeaks(yR,'MinPeakHeight',150,'MinPeakDistance',50);
swingSignalR=zeros(size(yR,1),1);

for jj=1:length(loc)
    
    i1=find(a<loc(jj));
    
    
    i2=find(a>loc(jj));
    
    
    if(length(i1)>0&length(i2)>0)
        
        i1=a(i1(end));
        i2=a(i2(1));
        
        if(loc(jj)-i1<50&i2-loc(jj)<50)
            
            swingSignalR(i1:i2)=1;
        end
    end
    
end



