%% MIL using Threshold Brute Force Optimization - Main Function
% 
% Written by: 
%
%    Ragav Venkatesan
%    Visual Processing and Representation Group
%    Arizona State University
%    http://www.public.asu.edu/~rvenka10    
%
%
%   Reference:
%
%   [1]  Ragav Venkatesan, Parag Shridhar Chandakkar, Baoxin Li, " Simple methods
%    provide as good or better results to Multiple Instance Learning", ICCV 2015.
%
%   About:
%
%       Please refer to the paper and the attached MILlooper code for
%       parameters and other details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[accuracy, labelOut, trainAccu]=MIL_threshold(bag,labels,testBags,testlabels,p_size,N,distMethod,displayProgress,plotFlag)

if nargin<9
    plotFlag=0;
    if nargin<8
        displayProgress=1;
        if nargin<7
            distMethod='euclidean';
            if nargin<6
                N=100;                
                if nargin<5
                    p_size=10;
                    fprintf('Assuming k to be 10');
                    if nargin<4
                        error('The Function MIL requires atleast 4 arguments as input');
                    end
                end
            end
        end
    end
end                          
%% Creating the instance space
fprintf('Creating the Instance Space... \n');
accu=[];
labelAccu=[];

for i=1:size(bag,2)
    accu=[accu bag{1,i}]; % create instance space
    labelAccu=[labelAccu ones(1,size(bag{1,i},2))*labels(1,i)]; % propogate bag level labels to instance level
end
%% Plotting the feature space - only for servicing the code and visualizing purposes

progressBar=displayProgress;
if plotFlag==1
    fprintf('Plotting the feature space and probability density ... \n');
    axes('position',[0 0 1 1]);
    
    plot(accu(1,1:5000),accu(2,1:5000),'X','color',[1 0 0],'MarkerSize',6);
    hold on;
    plot(accu(1,5001:10000),accu(2,5001:10000),'o','color',[0 0 1],'MarkerSize',6);
    axis off;
    
    % Run through brute force
    
    N=100;
    for i=1:1:N
        if progressBar==1
            progressbar(i/N);
        end
        for j=1:1:N
            %progressbar(j/N);
            x=[i,j]./N;
            val(i,j)=voting(x.',accu,labelAccu,distMethod,p_size); % brute force again can be made faster easily
        end
    end
    
    
    figure;
    imshow(imrotate(val,90),[]);
    colormap('jet');
    
    
end
%% Training the probability space.
fprintf('Training the probability space... \n');
maxInstSize=0;
for i=1:size(bag,2)
    if size(bag{1,i},2)>maxInstSize
        maxInstSize=size(bag{1,i},2);
    end
end
val=realmin*ones(size(bag,2),maxInstSize);
for i=1:size(bag,2)
    if progressBar==1
        progressbar(i/size(bag,2));
    end
    currBag=bag{1,i};
    for j=1:size(currBag,2)
        val(i,j)=voting(currBag(:,j),accu,labelAccu,distMethod,p_size); % brute force again can be made faster easily
    end
end
%% Maximizing traning accuracy to find threshold.
fprintf('Maximizing Training Accuracy... \n');
count=1;

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
%% Testing
fprintf('Testing... \n');
clear val;
for i=1:size(testBags,2)
    if progressBar==1
        progressbar(i/size(testBags,2));
    end
    currBag=testBags{1,i};
    for j=1:size(currBag,2)
        val(i,j)=voting(currBag(:,j),accu,labelAccu,distMethod,p_size); % brute force again can be made faster easily
    end
end

testVals=zeros(size(val));
testVals(val>T)=1;
labelOut=sum(testVals,2);
labelOut(labelOut>0)=1;
accuFlagTest=zeros(size(testlabels));
accuFlagTest(labelOut==testlabels.')=1;
correctTest=sum(accuFlagTest);
accuracy=correctTest/size(testBags,2);
fprintf('Testing Accuracy = %2.4f percent \n',correctTest*100/size(testBags,2));
end
