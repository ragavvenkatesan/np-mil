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
%   [1]  Ragav Venkatesan, Parag Shridhar Chandakkar, Baoxin Li, " A
%   Nearest-Neighbour Approach to Multiple-Instance Learning".
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
% clear all;


% Load the data ...
%  load DR_data.mat
%  load '../data/musk2.mat'
%  load synth_data_4;

train_data_dir = '/Users/ragav/Dropbox/SharedWithParag/CVPR2015DATA/data/toggledLabelsTrain/DR_data' ;
train_data = dir (fullfile(train_data_dir,'*.mat'));
flag=1;    % set 1 if the data already has a train-test split; 0 if you want to randomly split.
test_data = '/Users/ragav/Dropbox/SharedWithParag/CVPR2015DATA/data/correctLabelsTesting/DR_data_test.mat';
load(test_data);
testBags = bag;
testlabels = labels;

for l = 1:size(train_data,1)
    
    load(strcat(train_data_dir,'/',train_data(l,1).name));
    
    % minimum and maximum number of neighbours for grid search.
    nLow=1;
    nHigh=50;
    runSteps=2;   % steps to search
    plotFlag=0;   % Set 1 if you want to visualize data.
    
    
    % Train-Test Splits... Do not use for data like DR that already has a test and train set ...
    kfold=10;  % Number of splits (actually just a train-test split).
    nRuns=5;  % For averaged accuracy over runs.
    
    
    % Number of iterations. .....
    Tsteps=100;     % maximum number of iterations to maximize the trianing accuracy ...
    distMethod='euclidean';      % Choice of distance to be used ....
    
    
    % Method of optimization .....
    threshold=1; % if threshold is 1, its threshold learning, if not its optimization for each IP.
    
    % Show a progresbar for every iteration
    displayProgress=0;
    
    %% No more parameters in this part of the code ..
    
    if threshold==1
        % Grid search begins.....
        for j=1:nRuns
            accuracy=[];
            trainAcc=[];
            count=1;
            ind = crossvalind('kfold', size(bag,2) , kfold);
            for i=nLow:runSteps:nHigh
                fprintf('Working on N=%d Neighbours.. \n',i);
                % progressbar(i-nLow+1/(nHigh-nLow+1));
                n(count)=i;
                
                
                if flag==0
                    [accuracy(count),~,test(count)]=MIL_threshold(bag(ind>1),labels(1,ind>1),bag(ind==1),labels(ind==1),i,Tsteps,distMethod,displayProgress,plotFlag);
                elseif flag==1
                    [accuracy(count),~,test(count)]=MIL_threshold(bag,labels,testBags,testlabels,i,Tsteps,distMethod,displayProgress,plotFlag);
                end
                
                if accuracy(count)==1
                    break;
                end
                
                
                count=count+1;
                fprintf('\n\n<========================================================>         Run # %d, %d\n\n',l,j);
            end
            
            % To track accuracy
            if plotFlag==1
                plot(accuracy*100);
                hold on;
                plot(test,'color',[1 0 0]);
                xlabel('Number of neighbors');
                ylabel('Accuracy');
                legend('Testing Accuracy','Training Accuracy');
            end
            
            
            [accuracyFinal(j), idx(j)]=max(accuracy);
            allAccuracy(l,j) = accuracyFinal(j);

        end
    end
    
    
    %% Produce outputs and display
    
    accuracyAvg(l)=mean(accuracyFinal); % Compensate for noisy.clear
    fprintf('Average Accuracy = %2.4f',accuracyAvg(l)*100);
end

    