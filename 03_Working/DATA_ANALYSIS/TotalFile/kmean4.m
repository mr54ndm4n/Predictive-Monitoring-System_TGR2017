rng default; % For reproducibility

X=[];
j=1;
i=1;
while j <= 1000
    
 a = randn(1)*100;
 b = randn(1)*100; 
 c = randn(1)*100; 
    if ((a*a)+(b*b)<=10);        
        X(j,1)=a;
        X(j,2)=b;
        X(j,2)=c;
        j=j+1;
    end
    i=i+1;
    
end


normplot(X)
