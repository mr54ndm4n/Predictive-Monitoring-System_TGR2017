
A = importdata('LS.csv');
x=A.data(:,1)
y=A.data(:,2)


p = polyfit(x,y,1);
x1 = linspace(0,4*pi);
y1 = polyval(p,x1);
figure(1)
subplot(2,4,1),plot(x,y,'.');
hold on
plot(x1,y1)
title('coefficient =1 ')
hold off

p = polyfit(x,y,2);
x1 = linspace(0,4*pi);
y1 = polyval(p,x1);
subplot(2,4,2)
plot(x,y,'.');
hold on
title('coefficient =2 ')
plot(x1,y1)

p = polyfit(x,y,2);
x1 = linspace(0,4*pi);
y1 = polyval(p,x1);
subplot(2,4,2)
plot(x,y,'.');
hold on
title('coefficient =2 ')
plot(x1,y1)


p = polyfit(x,y,3);
x1 = linspace(0,4*pi);
y1 = polyval(p,x1);
subplot(2,4,3)
plot(x,y,'.');
hold on
title('coefficient =3 ')
plot(x1,y1)


p = polyfit(x,y,4);
x1 = linspace(0,4*pi);
y1 = polyval(p,x1);
subplot(2,4,4)
plot(x,y,'.');
hold on
title('coefficient =4 ')
plot(x1,y1)


p = polyfit(x,y,5);
x1 = linspace(0,4*pi);
y1 = polyval(p,x1);
subplot(2,4,5)
plot(x,y,'.');
hold on
title('coefficient =5 ')
plot(x1,y1)

p = polyfit(x,y,6);
x1 = linspace(0,4*pi);
y1 = polyval(p,x1);
subplot(2,4,6)
plot(x,y,'.');
hold on
title('coefficient =6 ')
plot(x1,y1)

p = polyfit(x,y,7);
x1 = linspace(0,4*pi);
y1 = polyval(p,x1);
subplot(2,4,7)
plot(x,y,'.');
hold on
title('coefficient =7 ')
plot(x1,y1)

p = polyfit(x,y,8);
x1 = linspace(0,4*pi);
y1 = polyval(p,x1);
subplot(2,4,8)
plot(x,y,'.');
hold on
title('coefficient =8 ')
plot(x1,y1)


