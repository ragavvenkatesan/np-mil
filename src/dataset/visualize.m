function visualize(bag, labels)

accu=[];
 
for i=1: size(bag,2)
    accu=[accu bag{i}];
end

accu=accu.';

plot(accu(1:sum(labels==1)*size(bag{1,1},2),1),accu(1:sum(labels==1)*size(bag{1,1},2),2),'.','color',[rand rand rand],'MarkerSize',6);
hold on;
plot(accu(sum(labels==1)*size(bag{1,1},2)+1:size(accu,1),1),accu(sum(labels==1)*size(bag{1,1},2)+1:size(accu,1),2),'X','color',[rand rand rand],'MarkerSize',6);
axis off;

clearvars -except bag labels label_kNN;

end