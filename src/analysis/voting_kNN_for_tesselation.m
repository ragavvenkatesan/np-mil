
function vote=voting_kNN_for_tesselation(x,accu,labels,distMethod,p_size)
     if nargin<5
         error('The function needs a minimum of 5 input parameters');
     end
        negs=accu(:,labels==0).';
        poss=accu(:,labels==1).';
        [~, idx]=sort(pdist2(x.',accu.',distMethod),2);                
        labelsOut=labels(idx);
        val=sum(labelsOut(1:p_size));
        if val>p_size/2
            vote=1;
        else
            vote=0;
        end
end

    