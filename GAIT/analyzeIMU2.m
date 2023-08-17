function [swingSignalL]=analyzeIMU2(yL)

thres=10;

[a b]=crossing(yL,[],thres);

[pk loc]=findpeaks(yL,'MinPeakHeight',100,'MinPeakDistance',5);
swingSignalL=zeros(size(yL,1),1);

if(1)
    figure,plot(yL)  
    end
for jj=1:length(loc)
    
    i1=find(a<loc(jj));
    
    
    i2=find(a>loc(jj));
    if(length(i1)>0&length(i2)>0)
        i2=a(i2(1));
        i1=a(i1(end));
        if(loc(jj)-i1<10&i2-loc(jj)<10)
            
            swingSignalL(i1:i2)=1;
            
            if(1)
                hold on,plot(loc(jj),yL(loc(jj)),'ro')
                
                hold on,plot(i1,thres,'mo')
                hold on,plot(i2,thres,'ko')
                
                
                
            end
            
        end
        
    end
end

