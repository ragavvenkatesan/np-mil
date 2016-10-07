clc;
clear all;
close all;

bag{1000}=[];
label_kNN=[];
for i=1:500 % positive bags
    for j=1:10
        randVal=randi([1,3],1);
        if j<=randVal
            bag{i}=[bag{i} randSampleGauss3(1).'];
            label_kNN=[label_kNN 1];
        else
            bag{i}=[bag{i} randSampleGauss3(0).'];
            label_kNN=[label_kNN 0];
        end
    end
end

for i=501:1000 % negative bags
    for j=1:10
       bag{i}=[bag{i} randSampleGauss3(0).'];
       label_kNN=[label_kNN 0];
    end
end

labels=[ones(1,500) zeros(1,500)];

accu=[];
 
for i=1:1000
    accu=[accu bag{i}];
end

accu=accu.';
p=3;

axes('position',[0 0 1 1]);

plot(accu(1:5000,1),accu(1:5000,2),'X','color',[1 0 0],'MarkerSize',6);
hold on;
plot(accu(5001:10000,1),accu(5001:10000,2),'o','color',[0 0 1],'MarkerSize',6);
axis off;
axis square;

clearvars -except bag labels p label_kNN;
save synth_data_4_kNN.mat;

