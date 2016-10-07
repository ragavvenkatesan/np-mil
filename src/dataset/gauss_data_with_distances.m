clc;
clear all;
close all;

nBags = 200;
nInst = 4;
nPostInstMax = 1;
bag{nBags}=[];

for i=1:floor(nBags/2) % positive bags
    for j=1:nInst
        randVal=randi([1,nPostInstMax],1);
        if j<=randVal
            bag{i}=[bag{i} randSampleGauss(1).'];
        else
            bag{i}=[bag{i} randSampleGauss(0).'];
        end
    end
end

for i=floor(nBags/2)+1:nBags % negative bags
    for j=1:nInst
       bag{i}=[bag{i} randSampleGauss(0).'];
    end
end

labels=[ones(1,floor(nBags/2)) zeros(1,floor(nBags/2))];

accu=[];
 
for i=1:nBags
    accu=[accu bag{i}];
end

accu=accu.';
axes('position',[0 0 1 1]);
plot(accu(1:floor(nBags/2)*nInst,1),accu(1:floor(nBags/2)*nInst,2),'x','color',[1 0 0],'MarkerSize',6);
hold on;
plot(accu(floor(nBags/2)*nInst + 1:nBags*nInst,1),accu(floor(nBags/2)*nInst + 1:nBags*nInst,2),'o','color',[0 0 1],'MarkerSize',6);
hold on;

D = pdist2(accu,accu); 

clearvars -except bag labels nPostInstMax D;
save synth_data.mat;

