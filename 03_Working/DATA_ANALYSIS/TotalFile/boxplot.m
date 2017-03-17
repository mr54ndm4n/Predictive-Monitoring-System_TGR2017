load fisheriris
s1 = meas(51:100,3);
s2 = meas(101:150,3);
figure
boxplot([s1 s2],'notch','on',...
        'labels',{'versicolor','virginica'})