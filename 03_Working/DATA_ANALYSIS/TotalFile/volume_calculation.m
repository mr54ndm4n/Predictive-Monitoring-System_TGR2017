function volume_calculation()
tic();

%function volume = volume_calculation(target_image)
%% PREPROCESSING
    %  Convert uint8 to double image type
    target_image = imread('durainpi.jpg');
    image_double = im2double(target_image);
    %  Convert RGB to Gray scale
    image_gray = rgb2gray(target_image);
    image_adjust = imadjust(image_gray);
    %mask = image_gray >= 200;
    %image_gray(mask) = 200;
    orignal_pane = figure('Name', 'Original Image');
    subplot(1,2,1);
    imshow(target_image);
    title('Original image');
    subplot(1,2,2);
    imshow(image_gray);
    title('Edge image');

%% FEATURE EXTRACTION
%  edge --> boudary --> shape, volume, size
%  extract interest inforamtion from image

%  Edge detection.
    [~, th] = edge(image_gray, 'Canny');
    factors = 0.90;
    image_edge = edge(image_gray, 'Canny', th * factors);
    edge_panel = figure('Name', 'Edge Image');
    subplot(1,5,1);
    imshow(image_edge);
    title('Gray scale image');


%  Expand edge width
    SE90 = strel('line', 2, 90);
    SE0 = strel('line', 2, 0);
    image_dilation = imdilate(image_edge, [SE90, SE0]);
    subplot(1,5,2);
    imshow(image_dilation);
    title('Dilation image');

CC = bwconncomp(image_dilation);
%  Fill hole in image
    image_filled = imfill(image_dilation, 'holes');
    subplot(1,5,3);
    imshow(image_filled);
    title('Filled image');

%  Clear border
    image_clear_border = imclearborder(image_filled, 8);
    subplot(1,5,4);
    imshow(image_clear_border);
    title('Cleared border image');

%  Perlim
    image_perlim = bwperim(image_clear_border);
    subplot(1,5,5);
    imshow(image_perlim);
    title('Delete hole image');

%  Remove noise
    image_conncomp = bwconncomp(image_perlim);
    num_pixels = cellfun(@numel,image_conncomp.PixelIdxList);
    [biggest_size,idx] = max(num_pixels);
    image_final = false(size(image_clear_border));
    image_final(image_conncomp.PixelIdxList{idx}) = true;
    imshow(image_final);
    title('Edge image');

    area = regionprops(image_final , 'Area');

%% Compare image
    orignal_panel = figure('Name', 'Original Image');
    subplot(1,2,1);
    imshow(target_image);
    title('Original image');
    subplot(1,2,2);
    imshow(image_final);
    title('Edge image');


%% Find volume
    real_world_scale_cm=2.54;
    image_scale_pixel=72;
    scalling=real_world_scale_cm/image_scale_pixel;
    d_size = size(image_final);
    d_weight_dive_by_2 = (d_size(2)/2);
    d_height_margin = 10;

    result = 0;
    for a =1:1:d_size(1)
        %disp(a)
        cen = image_final(a,d_weight_dive_by_2);
        lhs = 0;
        rhs = 0;
        for i = d_weight_dive_by_2:-1: 1
            if image_final(a,i) 
                %disp(i)
                lhs = i;
            end
            %disp(i)
        end
        for i = d_weight_dive_by_2:1: d_size(2)
            if image_final(a,i) 
                %disp(i)
                rhs = i;
            end
            %disp(i)
        end
        if rhs > 0
            r = (rhs - a)/2;
            real_r = r * scalling;
            result = result + (pi*real_r*real_r) * scalling;
        end
        if lhs > 0
            r = (a-lhs)/2;
            real_r = r * scalling;
            result = result + (pi * real_r * real_r)* scalling;
        end
    end
    fprintf('Volume : %.8f cm^3\n', result * 2);

%toc();
%tic();

%% Find Width & Height
    heigh = 0;
    for i =1:1:d_size(1)
        for j =1:1:d_size(2)
            if image_final(i,j)
                heigh = heigh + 1;
                break
            end
        end    
    end    

weight =0;

    for i =1:1:d_size(2)
        for j =1:1:d_size(1)
            if image_final(j,i)
                weight = weight + 1;
                break
            end
        end    
    end

    real_height = heigh * scalling;
    real_width = weight * scalling;

    fprintf('Area : %.2f cm^ 2\n', pi * real_width * real_width / 4);
    fprintf('Height : %.2f cm\n', real_height);
    fprintf('Width : %.2f cm\n', real_width);
    fprintf('Ratio HEIGHT/WIDTH : %.3f\n', real_height / real_width);

toc();
end