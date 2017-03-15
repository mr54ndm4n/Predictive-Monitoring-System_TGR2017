I = imread('ทุเรียน.jpg');


BW = im2bw(I,0.6);
BW = not(BW);
BW_filled = imfill(BW,'holes');

% %info = imfinfo('durian01.jpg')
% numberOfPixels = numel(BW_filled); % num all Pixel 
% whiteCount = sum(sum(BW == 1));  % count White
% percent = whiteCount/numberOfPixels*100;

%% new method
I2 = imgaussfilt(I);
imgray2=rgb2gray(I2);

J = imnoise(imgray2,'salt & pepper',0.02);
imgray = medfilt2(J);
% imshow(imgray)
% imgray = imadjust(imgray2,[0.3 0.7],[]);


[~, threshold] = edge(imgray, 'sobel');

fudgeFactor = .5;
BWs = edge(imgray,'sobel', threshold * fudgeFactor);

se90 = strel('line', 20, 90); % expand size of line 90 degree
se0 = strel('line', 20, 0);

BWsdil = imdilate(BWs, [se90 se0]);
BWdfill = imfill(BWsdil, 'holes');

BWnobord = imclearborder(BWdfill, 4);
seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);

BW2 = bwareaopen(BWfinal, 700);
imshow(BW2)

NumberOnRealWorld=1;
NumberOnPixel=9;
scallingPix=NumberOnRealWorld/NumberOnPixel;

%% Find Volume
[heigh,wide,z1] = size(BW2);

valArea = 1:wide;
valR = 1:wide;
valRFalse = 1:wide;
volume = 0;

checkFirstCol = 0;
firstCol  = 0;

checkLastCol = 0;
lastCol  = 0;


minRow = heigh;


maxRow = 0;


for col=1:wide
    countPixel = 0;
   for row=1:heigh
       
       
         
       if BW2(row,col) == 1
            countPixel = countPixel +1 ;
            
            if checkFirstCol == 0 
                checkFirstCol = 1;
                firstCol = col;                
            end 
            
            if maxRow < row
                maxRow = row;
            end
            
            if minRow > row
                minRow = row;
            end
       end

   end
    
   if countPixel < 120  && checkFirstCol == 1 && checkLastCol == 0 && col > firstCol + 90
       checkLastCol = 1;
       lastCol = col;
   end   
       
    r = countPixel/2.0;
    realR = r*scallingPix;
    area = 3.14*realR*realR*scallingPix;
    
    valRFalse(col) = r;
    valR(col) = realR;
    valArea(col) = area;
    
    if countPixel > 100
        volume = volume + area;
    end

end

txt = fprintf('\n Area = %.2f cm^3 \n', volume);

widthDurian = (maxRow - minRow) * scallingPix
heightDurian = (lastCol - firstCol) * scallingPix  

ratio=heightDurian/widthDurian

hold on;

rectangle('Position',[firstCol minRow (lastCol - firstCol) (maxRow - minRow)],'LineWidth',2,'EdgeColor','yellow')


