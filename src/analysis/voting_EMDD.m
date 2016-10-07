%% Voting Function for MIL EMDD

function val=voting_EMDD(A,B,distMethod) 
val=pdist2(A.',B.',distMethod);
val=min(val(:));
end