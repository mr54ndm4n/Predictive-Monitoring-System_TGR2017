X=[];
y=[];
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


