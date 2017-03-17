
a=5*[randn(500,1)+5,randn(500,1)+5];
b=5*[randn(500,1)+5,randn(500,1)-5];
c=5*[randn(500,1)-5,randn(500,1)+5];
d=5*[randn(500,1)-5,randn(500,1)-5];
e=5*[randn(500,1),randn(500,1)];
all_data=[a;b;c;d;e];
plot(a(:,1),a(:,2),'.'); hold on
plot(b(:,1),b(:,2),'r.');
plot(c(:,1),c(:,2),'g.');
plot(d(:,1),d(:,2),'k.');
plot(e(:,1),e(:,2),'c.');
IDX= kmeans(all_data,5);

for k = 1:2500
  text(all_data(k,1),all_data(k,2),num2str(IDX(k))); hold on
end


Y = pdist(all_data);
Z=linkage(Y);
thershold= 1.2;
T=cluster(Z,'cutoff',thershold);
for k = 1:2500
  text(all_data(k,1),all_data(k,2),num2str(T(k))); hold on
end
axis([-70 70 -70 70])

