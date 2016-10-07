% Function draws a random sample from the space such that there are 4
% potential target points for poitive bag. Random sample can be an instance
% of potive or negative label. (potive bags can contain negative labels too
% 
% right now there are four target positive bags

% This function needs to be generalized instead of hard defining points !

function sample=randSampleInst(label)

if label==1 % if the bag is the positive bag, choose a point near a potential target region
    
    randVal=randi([1 4],1);
    switch(randVal)
        case 1
            sample=[randi([35,40],1),randi([25,30],1)];
        case 2
            sample=[randi([20,23],1),randi([9,14],1)];
        case 3
            sample=[randi([19,23],1),randi([80,84],1)];
        case 4
            sample=[randi([54,56],1),randi([75,79],1)];
    end
    
else
    accept=0;
    while (accept==0)
           sample=[randi([1,100],1),randi([1,100],1)];
           if sample(1)>34 && sample(1)<41 && sample(2)>24 && sample(2) <31
               accept=0;
           elseif sample(1)>19 && sample(1)<24 && sample(2)>8 && sample(2) <15
               accept=0;
           elseif sample(1)>18 && sample(1)<24 && sample(2)>79 && sample(2) <85
               accept=0;
           elseif sample(1)>53 && sample(1)<56 && sample(2)>74 && sample(2) <79
                accept=0;
           else
               accept=1;
           end
    end
               
end
sample=sample./100;
end
    
    