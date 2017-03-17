function [percent,BW_filled] = findSizeDurian(namePic)

    I = imread(namePic);
    BW = im2bw(I,0.6);
    BW = not(BW);
    BW_filled = imfill(BW,'holes');

    %info = imfinfo('durian01.jpg')
    numberOfPixels = numel(BW_filled); % num all Pixel 
    whiteCount = sum(sum(BW == 1));  % count White
    
    percent = whiteCount/numberOfPixels*100;
    
end