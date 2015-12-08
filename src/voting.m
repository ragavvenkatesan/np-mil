%% Voting Function for MIL KNN Function
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



function val=voting(x,accu,labels,distMethod,p_size)
     if nargin<5
         error('The function needs a minimum of 5 input parameters');
     end
        negs=accu(:,labels==0).';
        poss=accu(:,labels==1).';
        [distNeg idxNeg]=sort(pdist2(x.',negs,distMethod),2);        
        [distPos idxPos]=sort(pdist2(x.',poss,distMethod),2);                   
        val=sum(distNeg(1:p_size))-sum(distPos(1:p_size));
end