% Function draws a random sample from the space such that there are 4
% potential target points for poitive bag. Random sample can be an instance
% of potive or negative label. (potive bags can contain negative labels too
% 
% right now there are four target positive bags

% This function needs to be generalized instead of hard defining points !

function sample=randSampleGauss(label)

if label==1 % if the bag is the positive bag, choose a point near a potential target region
    
    randVal=randi([1 4],1);
    switch(randVal)
        case 1
            sample=normrnd([20,20],[2,2]);
        case 2
            sample=normrnd([40,23],[2,2]);
        case 3
            sample=normrnd([20,80],[2,2]);
        case 4
            sample=normrnd([54,72],[2,2]);
    end
    
else
    randVal=randi([1 7],1);
    switch(randVal)
        case 1
            sample=normrnd([80,25],[5,5]);
        case 2
            sample=normrnd([15,45],[4,4]);
        case 3
            sample=normrnd([35,50],[8,8]);
        case 4
            sample=normrnd([85,75],[8,8]);
        case 5
            sample=normrnd([54,20],[3,3]);
        case 6
            sample=normrnd([30,20],[0.7,3]);
        case 7
            sample=normrnd([37,77],[2,4]);
    end
               
end
sample(sample>100)=100;
sample(sample<0)=0;
sample=sample./100;
end
    
    