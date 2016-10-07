%% Works only when the feature space is a unit square.

clc;
close all;
clear all;

load synth_data_9.mat;
%% Creating the instance space.

accu=[];
labelAccu=[];

for i=1:size(bag,2)
    accu=[accu bag{1,i}]; % create instance space
    labelAccu=[labelAccu ones(1,size(bag{1,i},2))*labels(1,i)]; % propogate bag level labels to instance level
end

distMethod='euclidean';
figure;
plot(accu(1,1:5000),accu(2,1:5000),'X','color',[1 0 0],'MarkerSize',6);
hold on;
plot(accu(1,5001:10000),accu(2,5001:10000),'o','color',[0 0 1],'MarkerSize',6);
axis off;
axis square;
title('Feature Space');

%% Tesselatoin of The space by Proposed Method.

p_size=10;
N=100;
maxInstSize=0;
for i=1:size(bag,2)
    if size(bag{1,i},2)>maxInstSize
        maxInstSize=size(bag{1,i},2);
    end
end

val=realmin*ones(size(bag,2),maxInstSize);

for i=1:size(bag,2)
    progressbar(i/size(bag,2));
    currBag=bag{1,i};
    for j=1:size(currBag,2)
        val(i,j)=voting(currBag(:,j),accu,labelAccu,distMethod,p_size); % brute force again can be made faster easily
    end
end

count=1;
for T=min(min(val)):(max(max(val))-min(min(val)))/N:max(max(val))
    % Grid searching to maximize the training accuracy
    clear accuFlag
    clear train
    clear trainLabel
    train=zeros(size(val));
    train(val>T)=1;
    trainLabel=sum(train,2);
    trainLabel(trainLabel>0)=1;
    accuFlag=zeros(size(labels));
    accuFlag(trainLabel==labels.')=1;
    correct(count)=sum(accuFlag,2);
    threshold(count)=T;
    count=count+1;
end

[trainAccu,idx]=max(correct);
T=threshold(idx);
trainAccu=trainAccu*100/size(bag,2);
fprintf('Maximum Training Accuracy Achieved = %2.4f percent \n',trainAccu);

for i=1:1:N
    progressbar(i/N);
    for j=1:1:N
        %progressbar(j/N);
        x=[i,j]./N;
        valTess(i,j)=voting(x.',accu,labelAccu,distMethod,p_size); % brute force again can be made faster easily
    end
end

valTessNew=valTess;
valTessNew(valTess>=T)=1;
valTessNew(valTess<T)=0;
figure;
imshow(imrotate(valTessNew,90),[]);
title('50-NN MIL');
%% Tesselation of the space by kNN with ground-truth assumptions.

clearvars -except bag labels distMethod label_kNN accu labelAccu;
N=250;

accu=[];
labelAccu=[];


for i=1:size(bag,2)
    accu=[accu bag{1,i}]; % create instance space
    labelAccu=[labelAccu ones(1,size(bag{1,i},2))*labels(1,i)]; % propogate bag level labels to instance level
end

for p_size=60:60
    
    vote=[];
    for i=1:1:N
        progressbar(i/N);
        for j=1:1:N
            %progressbar(j/N);
            x=[i,j]./N;
            vote(i,j)=voting_kNN_for_tesselation(x.',accu,label_kNN,distMethod,p_size); % brute force again can be made faster easily
        end
    end
    figure;
    imshow(imrotate(vote,90),[]);
    title(sprintf(strcat(num2str(p_size),'-NN kNN')));
    
    
    for i=1:size(bag,2)
        progressbar(i/size(bag,2));
        currBag=bag{1,i};
        for j=1:size(currBag,2)
            val(i,j)=voting_kNN_for_tesselation(currBag(:,j),accu,label_kNN,distMethod,p_size); % brute force again can be made faster easily
        end
    end
    
    testVals=zeros(size(val));
    testVals(val==1)=1;
    labelOut=sum(testVals,2);
    labelOut(labelOut>0)=1;
    accuFlagTest=zeros(size(labels));
    accuFlagTest(labelOut==labels.')=1;
    correctTest=sum(accuFlagTest);
    accuracy=correctTest/size(bag,2);
    fprintf('For %d-NN, Testing Accuracy = %2.4f percent \n',p_size,correctTest*100/size(bag,2));
    
    
end


%% Tesselation of the space by EMDD.
clearvars -except bag labels distMethod label_kNN;
cd('/home/ragav/Desktop/DR_related_stuff/CVPR 2014 stuff/code/other_MIL/EMDD');
path(path,'/home/ragav/Desktop/DR_related_stuff/CVPR 2014 stuff/code/other_MIL/EMDD');


p=[];
for i=1:size(bag,2)  
    if labels(1,i)==1
        p=[p [bag{i}]];
    end
end
istar=LearnIPs(p,bag,labels);
label_EMDD_Tess=ones(size(istar,2),1);
istar=istar(1:2,:);
istarTemp=istar;
istar(istar>1)=1;
istar(istar<0)=0;
istar(:,any(istar==0,1))=[];
istar(:,any(istar==1,1))=[];
accu=[];

for i=1:size(bag,2)
    accu=[accu bag{1,i}]; % create instance space
end


N=250;
maxInstSize=0;
for i=1:size(bag,2)
    if size(bag{1,i},2)>maxInstSize
        maxInstSize=size(bag{1,i},2);
    end
end

val=realmin*ones(size(bag,2),maxInstSize);

for i=1:size(bag,2)
    progressbar(i/size(bag,2));
    currBag=bag{1,i};
    for j=1:size(currBag,2)
        val(i,j)=voting_EMDD(currBag(:,j),istar,distMethod); % brute force again can be made faster easily
    end
end

count=1;
for T=min(min(val)):(max(max(val))-min(min(val)))/N:max(max(val))
    % Grid searching to maximize the training accuracy
    clear accuFlag
    clear train
    clear trainLabel
    train=zeros(size(val));
    train(val<T)=1;
    trainLabel=sum(train,2);
    trainLabel(trainLabel>0)=1;
    accuFlag=zeros(size(labels));
    accuFlag(trainLabel==labels.')=1;
    correct(count)=sum(accuFlag,2);
    threshold(count)=T;
    count=count+1;
end

[trainAccu,idx]=max(correct);
T=threshold(idx);
trainAccu=trainAccu*100/size(bag,2);
fprintf('Maximum Training Accuracy Achieved = %2.4f percent \n',trainAccu);

for i=1:1:N
    progressbar(i/N);
    for j=1:1:N
        %progressbar(j/N);
        x=[i,j]./N;
        valTess(i,j)=voting_EMDD(x.',istar,distMethod); % brute force again can be made faster easily
    end
end

valTessNew=valTess;
valTessNew(valTess>=T)=0;
valTessNew(valTess<T)=1;
figure;
imshow(imrotate(valTessNew,90),[]);
title('EMDD Tess');