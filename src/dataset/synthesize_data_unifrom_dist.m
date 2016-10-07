clc;
clear all;
%close all;

figure;

bag{1000}=[];
label_kNN=[];
for i=1:500 % positive bags
    for j=1:10
        randVal=randi([1,4],1);
        if j<=randVal
            bag{i}=[bag{i} randSampleInst(1).'];
            label_kNN=[label_kNN 1];
        else
            bag{i}=[bag{i} randSampleInst(0).'];
            label_kNN=[label_kNN 0];
        end
    end
end

for i=501:1000 % negative bags
    for j=1:10
       bag{i}=[bag{i} randSampleInst(0).'];
       label_kNN=[label_kNN 0];
    end
end

labels=[ones(1,500) zeros(1,500)];

accu=[];
 
for i=1:1000
    accu=[accu bag{i}];
end

accu=accu.';

plot(accu(1:5000,1),accu(1:5000,2),'.','color',[rand rand rand],'MarkerSize',6);
hold on;
plot(accu(5001:10000,1),accu(5001:10000,2),'X','color',[rand rand rand],'MarkerSize',6);
axis off;

clearvars -except bag labels label_kNN;
save synth_data_1_kNN.mat;

