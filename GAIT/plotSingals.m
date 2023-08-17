close all
sL=sqrt(sum(d1(:,21:23).^2,2));
sR=sqrt(sum(d1(:,46:48).^2,2));

figure,subplot(2,1,1),plot([sL leftSwingAnnot*100 leftSwing*200])
subplot(2,1,2),plot([sL leftSwingAnnot*100 leftSwing*200])
figure,subplot(2,1,1),plot([(max(d1(:,2:17),[],2)-min(max(d1(:,2:17),[],2)))  leftSwingAnnot*10 leftSwing*20])
subplot(2,1,2),plot([(max(d1(:,27:42),[],2)-min(max(d1(:,27:42),[],2)))  rightSwingAnnot*10 rightSwing*20])

figure,subplot(2,1,1),plot([d1(:,22)/50 (max(d1(:,2:17),[],2)-min(max(d1(:,2:17),[],2))) leftSwingAnnot*10])
subplot(2,1,2),plot([d1(:,47)/50 (max(d1(:,27:42),[],2)-min(max(d1(:,27:42),[],2))) rightSwingAnnot*10])