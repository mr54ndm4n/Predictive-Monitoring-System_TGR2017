clear all;
close all;
I = imread('colour.jpg');
imshow(I);
plot(I(200,:,1), 'r');
hold on
plot(I(200,:,2), 'g');
plot(I(200,:,3), 'B');
I1 = I+150;
figure;
imshow(I1);
I2 = I(end:-1:1, :);
figure;
imshow(I2);
[M,N] = size(I);
I(1:M/2, 1:N/2) = 0;
I(M/2+1:M, N/2+1:N)= 255;

figure;
imshow(I);