close all
clear


rootFolder='G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\';
mainFolders=dir(rootFolder);
allFiles=0;
dispPlot=0;
filecount=1;
for jj=3:length(mainFolders)
    
    folder=[rootFolder  '\\'  mainFolders(jj).name];
    
    subjectFolders=dir(folder);
    for kk=3:length(subjectFolders)
        
        subjfolder=[rootFolder  '\\'  mainFolders(jj).name '\\' subjectFolders(kk).name];
        subjectFiles=dir(subjfolder);
        allFiles=allFiles+length(subjectFiles)-2;
    end
end

pdSubject=zeros(allFiles,1);
for jj=3:length(mainFolders)
    
    folder=[rootFolder  '\\'  mainFolders(jj).name];
    pd=strcmp(mainFolders(jj).name,'PD')==1;
    el=strcmp(mainFolders(jj).name,'EL')==1;
    subjectFolders=dir(folder);
    for kk=3:length(subjectFolders)
        
        subjfolder=[folder '\\' subjectFolders(kk).name];
        subjectFiles=dir(subjfolder);
        for tt=3:length(subjectFiles)
            files{filecount}=[subjfolder '\\' subjectFiles(tt).name];
            pdSubject(filecount)=pd+el*2;
            filecount=filecount+1;
        end
    end
end
%
%
% files={'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\EL\EL001_260220\\el001_2tug1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\EL\EL001_260220\\el001_2tug2.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\EL\EL001_260220\\el001_1slow1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\EL\EL001_260220\\el001_1slow2.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\EL\EL001_260220\\el001_1norm1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\EL\EL001_260220\\el001_1norm2.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\EL\EL001_260220\\el001_1high1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\EL\EL001_260220\\el001_1high2.csv',...
% };
%
% files={'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\PD\\PD002_270220\\pd002_1high1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\PD\\PD002_270220\\pd002_1high2.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\PD\\PD002_270220\\pd002_1slow1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\PD\\PD002_270220\\pd002_2tug1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\PD\\PD002_270220\\pd002_2tug2.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\PD\\PD002_270220\\pd002_1norm2.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\PD\\PD002_270220\\pd002_1norm1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\PD\\PD004_270220\\pd004_1high1.csv',...resu
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\PD\\PD004_270220\\pd004_1slow1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\PD\\PD004_270220\\pd004_1norm1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\S\\S001_140220\\s001_1slow2.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\S\\S001_140220\\s001_1slow1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\S\\S001_140220\\s001_1norm2.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\S\\S001_140220\\s001_1norm1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\S\\S001_140220\\s001_1high1.csv',...
% 'G:\\MATLAB\\PRIME\\GAIT\\SmartInsole\\Annotated_Data_csv\\S\\S001_140220\\s001_1high1.csv',...
% };

%excluded=[79 148];
for thres=3:0.5:3
    results=zeros(length(files),20);
    %%
    for ff=1:length(files)
        
        if(exist(files{ff}))
            data=importSmartInsole(files{ff});
            leftFootEvents=data.Event_LabelLevel2_LeftFoot;
            rightFootEvents=data.Event_LabelLevel2_RightFoot;
            %leftSwingAnnot=leftFootEvents=='TOF'|leftFootEvents=='HES';
            %rightSwingAnnot=rightFootEvents=='TOF'|rightFootEvents=='HES';;
            
            leftSwingAnnot=leftFootEvents=='TOF';
            rightSwingAnnot=rightFootEvents=='TOF';
            insoleData=data(:,1:51);
            d1=table2array(insoleData);
            
            if(100*max(sum(isnan(d1)))/size(d1,1)>5)
                continue;
            end
            
            [leftSwing,rightSwing]=analyzeInsoles2(d1,thres);
            
            
            i1=find(leftSwingAnnot==1);
            
            i2=find(rightSwingAnnot==1);
            if(length(i1)>0&length(i2)>0)
                p1=i1(1);
                p2=i1(end);
                leftSwing(1:p1)=0;
                leftSwing(p2:end)=0;
                
                
                p1=i2(1);
                p2=i2(end);
                rightSwing(1:p1)=0;
                rightSwing(p2:end)=0;
                
                
                
                c=confusionmatStats(confusionmat(leftSwing==1,leftSwingAnnot==1));
                acc1=c.accuracy(1);
                
                c=confusionmatStats(confusionmat(rightSwing==1,rightSwingAnnot==1));
                acc2=c.accuracy(1);
                
                l1=sum(leftSwing)/length(leftSwing);
                l2=sum(leftSwingAnnot)/length(leftSwingAnnot);
                
                r1=sum(rightSwing)/length(rightSwing);
                r2=sum(rightSwingAnnot)/length(rightSwingAnnot);
                
                [stepsL1 swingTimeL1 stepTimeL1]=extractGaitMeasures(double(leftSwingAnnot),0.8);
                [stepsL2 swingTimeL2 stepTimeL2]=extractGaitMeasures(double(leftSwing),0.8);
                [stepsR1 swingTimeR1 stepTimeR1]=extractGaitMeasures(double(rightSwingAnnot),0.8);
                [stepsR2 swingTimeR2 stepTimeR2]=extractGaitMeasures(double(rightSwing),0.8);
                
                
                [doubleS1,doubleST1]=extractGaitMeasures(double((leftSwingAnnot==0)&(rightSwingAnnot==0)),0.5);
                [doubleS2,doubleST2]=extractGaitMeasures(double((leftSwing==0)&(rightSwing==0)),0.5);
                
                %      if(acc1>0.9&abs(stepTimeL1-stepTimeL2)>0.05 )
                %
                %
                %    % figure,plot([d1(:,21:23) leftSwingAnnot*100 leftSwing*200])
                %       figure,subplot(2,1,1),plot([medfilt1(max(d1(:,2:14),[],2)-min(max(d1(:,2:14),[],2)),60)  leftSwingAnnot*10 leftSwing*20])
                %       subplot(2,1,2),plot([medfilt1(max(d1(:,27:42),[],2)-min(max(d1(:,27:42),[],2)),60)  rightSwingAnnot*10 rightSwing*20])
                %      end
                results(ff,:)=[l1 l2 r1 r2  stepsL1 stepsL2 stepsR1 stepsR2 swingTimeL1 swingTimeL2 swingTimeR1 swingTimeR2  stepTimeL1 stepTimeL2 stepTimeR1 stepTimeR2 doubleST1 doubleST2 acc1 acc2];
            end
        else
            fprintf('Does not exist %s \r\n',files{ff});
        end
    end
    
    fprintf('Average %f %f %f \n',thres,mean(results(:,end-1)),mean(results(:,end)));
end




%%
ii=find(results(:,end-1)>0.9&results(:,end)>0.9&results(:,6)>5&results(:,6)<80);
BlandAltman(results(ii,5),results(ii,6),{'ANNOTATION','PRIME'})
BlandAltman(results(ii,9),results(ii,10),{'ANNOTATION','PRIME'})
BlandAltman(results(ii,13),results(ii,14),{'ANNOTATION','PRIME'})
BlandAltman(results(ii,17),results(ii,18),{'ANNOTATION','PRIME'})
% 
% res1=results(ii,:);
% pdSubject1=pdSubject(ii);
% [a1 b1]=ttest2(res1(pdSubject1==1,:),res1(pdSubject1==0,:))
% [a2 b2]=ttest2(res1(pdSubject1==1,:),res1(pdSubject1==2,:))
% [a3 b3]=ttest2(res1(pdSubject1==0,:),res1(pdSubject1==2,:))
% figure,
% boxplot(res1(:,13),pdSubject1);



