close all 
clear

I3 = imread('duraincount2.jpg');

I2 = imcomplement(I3);
I = rgb2gray(I2);
BW = imbinarize(I);
BW_filled = imfill(BW,'holes');
[B,L,N,A] = bwboundaries(BW_filled,'noholes');
% imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on

[rowAll,columnAll,z1] = size(I3);

position = zeros(length(B),2);
    
for k = 1:length(B)
    %%%  Plot edge
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
   
   %%% Set position
   numericCells = B(k,1);
   arrayPo = cell2mat(numericCells);
   
   borderX = 20;
   borderY = 20;
   
   minX = 0 + borderX;
   maxX = columnAll - borderX;
   
   minY = 0 + borderY;
   maxY = rowAll - borderY;
   [sizeX,sizeY] = size(arrayPo);
   for j = 1:sizeX
       xValue = arrayPo(j,2);
       yValue = arrayPo(j,1);
       if (xValue > minX) && (xValue < maxX) && (yValue > minY) && (yValue < maxY)
           position(k,1) = xValue;
           position(k,2) = yValue;
       end
   end 
   
end

number = 1:length(B);
box_color = {rand(1,length(B))};
RGB = insertText(I,position,number,'FontSize',10,'BoxOpacity',1,'TextColor','black');

imshow(RGB)
title('Durian Count');