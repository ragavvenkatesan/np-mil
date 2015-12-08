% MIL - Main Function
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
%       Please refer to the section of the code below. The code is
%       reasonably well commented. In case of queries please email authors.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Initial Parameters - Please set this part of the code up by looking at the comments for the program to run.

% Most of the results depend on the setting of parameters, please refer to
% the paper for the wise choosing of these settings.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
close all;
clear all;


% Load the data ...
load ../data/DR_data

crossValFlag=0; % if crossvalidate then 0 else 1

% minimum and maximum number of neighbours for grid search.
nLow=10;
nHigh=20;
runSteps=10;   % steps to search
plotFlag=0;   % Set 1 if you want to visualize data.

% Train-Test Splits... Do not use for data like DR that already has a test and train set ...
kfold=2;  % Number of splits (actually just a train-test split).
nRuns=1;  % For averaged accuracy over runs.


% Number of iterations. .....
Tsteps=100;     % maximum number of iterations to maximize the trianing accuracy ...
distMethod='euclidean';      % Choice of distance to be used ....


% Method of optimization .....
threshold=1; % if threshold is 1, its threshold learning, if not its optimization for each IP.

% Show a progresbar for every iteration
displayProgress=1;

%% No more parameters in this part of the code ..
classCount=0;
for class=min(labels):max(labels)    
    bagPos=bag(1,labels==class);
    randSelect=randi(size(bag,2),1,size(bagPos,2));
    randSelect(labels(randSelect)==class)=[];
    bagNeg=bag(randSelect);
    labelsCombined=[ones(size(bagPos,2),1);zeros(size(bagNeg,2),1)].';
    if threshold==1
        % Grid search begins.....
        for j=1:nRuns
            accuracy=[];
            trainAcc=[];
            count=1;
            bagCombined=[bagPos bagNeg];
            ind = crossvalind('kfold', size(bagCombined,2) , kfold);
            for i=nLow:runSteps:nHigh
                fprintf('Working on N=%d Neighbours.. \n',i);
                n(count)=i;
                if crossValFlag==0
                    [accuracy(count),testedLabels(count).labels,test(count)]=MIL_threshold(bagCombined(ind>1),labelsCombined(1,ind>1),bagCombined(ind==1),labelsCombined(ind==1),i,Tsteps,distMethod,displayProgress,plotFlag);
                elseif crossValFlag==1
                    [accuracy(count),testedLabels(count).labels,test(count)]=MIL_threshold(bag,labels,testBags,testlabels,i,Tsteps,distMethod,displayProgress,plotFlag);
                end
                
                if accuracy(count)==1
                    break;
                end
                
                
                count=count+1;
                fprintf('\n\n<========================================================>         Run # %d\n\n',j);
                
                
                % To track accuracy
                if plotFlag==1
                    plot(accuracy*100);
                    hold on;
                    plot(test,'color',[1 0 0]);
                    xlabel('Number of neighbors');
                    ylabel('Accuracy');
                    legend('Testing Accuracy','Training Accuracy');
                end
            end
            
            
            
            [accuracyFinal(j), idx(j)]=max(accuracy);
        end
    end
    classCount=classCount+1;
    accuracyClassLevel(classCount)=mean(accuracyFinal);
end

if plotFlag==1
    plot(accuracyClassLevel*100);
    hold on;    
    xlabel('Class');
    ylabel('Accuracy');
    title('Class-wsie Accuracy');
end

%% Print Accuracy

accuracyAvg=mean(accuracyClassLevel);
fprintf('Average Accuracy = %2.4f\n',accuracyAvg*100);

