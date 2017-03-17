rng default; % For reproducibility

X=[];
j=1;
i=1;
while j <= 1000
    
 a = randn(1)*100;
 b = randn(1)*100; 
    if ((a*a)+(b*b)<=10);        
        X(j,1)=a;
        X(j,2)=b;
        j=j+1;
    end
    i=i+1;
    
end
scatter(X(:,1),X(:,2));


figure;
plot(X(:,1),X(:,2),'.');
title 'Randomly Generated Data';

opts = statset('Display','final');
[idx,C] = kmeans(X,3,'Distance','cityblock',...
    'Replicates',5,'Options',opts);

figure;
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
plot(X(idx==3,1),X(idx==3,2),'g.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
hold off

title('coefficient =1 ')

disp(X(1,1));
disp(X(1,2));
disp(idx(1));
