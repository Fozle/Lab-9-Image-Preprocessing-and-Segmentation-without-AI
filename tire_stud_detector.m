
%% Tire Stud Detection using Image Processing
% Detect possible metal studs using image processing
% and connected-component analysis.

clear;
close all;
clc;

%% 1. Image files

imageFiles = {'studded_tire.jpeg', 'summer_tire.jpg'};

%% 2. Detection parameters

minA = 4;
maxA = 120;
minCirc = 0.6;
maxEcc = 0.85;

% Classification threshold
minStudCount = 30;

%% 3. Process both tire images

for i = 1:numel(imageFiles)

    % Read and resize image
    if ~isfile(imageFiles{i})
        error('Image not found: %s', imageFiles{i});
    end

    I = imread(imageFiles{i});
    I = imresize(I, 0.5);

    % Convert to grayscale
    if size(I,3) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end

    IgrayDouble = im2double(Igray);

    %% 4. Create tire mask

    tireMask = IgrayDouble < 0.55;
    tireMask = imfill(tireMask, 'holes');
    tireMask = bwareaopen(tireMask, 500);

    % Keep the largest connected region
    CC_tire = bwconncomp(tireMask);

    if CC_tire.NumObjects > 0
        areas = cellfun(@numel, CC_tire.PixelIdxList);
        [~, largestIndex] = max(areas);

        tireMask = false(size(tireMask));
        tireMask(CC_tire.PixelIdxList{largestIndex}) = true;
    end

    %% 5. Detect bright candidate studs

    cand = (IgrayDouble > 0.45) & tireMask;
    cand = bwareaopen(cand, minA);
    cand = imclose(cand, strel('disk', 1));
    cand = imopen(cand, strel('disk', 1));

    %% 6. Connected component analysis

    CC = bwconncomp(cand);

    stats = regionprops(CC, ...
        'Area', 'Perimeter', 'Eccentricity');

    studMask = false(size(cand));
    studCount = 0;

    for k = 1:numel(stats)

        area = stats(k).Area;
        perimeter = stats(k).Perimeter;
        eccentricity = stats(k).Eccentricity;

        if perimeter > 0
            circularity = 4*pi*area/(perimeter^2);
        else
            circularity = 0;
        end

        if area >= minA && area <= maxA && ...
                circularity >= minCirc && ...
                eccentricity <= maxEcc

            studMask(CC.PixelIdxList{k}) = true;
            studCount = studCount + 1;
        end
    end

    %% 7. Classification

    isStudded = studCount >= minStudCount;

    if isStudded
        classification = 'STUDDED TIRE';
    else
        classification = 'NON-STUDDED TIRE';
    end

    %% 8. Display results

    figure('Color', 'white', 'Name', imageFiles{i});

    subplot(1,3,1);
    imshow(I);
    title('Original Image');

    subplot(1,3,2);
    imshow(cand);
    title('Candidate Studs');

    subplot(1,3,3);
    imshow(I);
    hold on;
    visboundaries(studMask, 'Color', 'r', 'LineWidth', 0.7);
    title(sprintf('%s (Count: %d)', classification, studCount));

    %% 9. Display information

    fprintf('\nImage: %s\n', imageFiles{i});
    fprintf('Detected possible studs: %d\n', studCount);
    fprintf('Classification: %s\n', classification);

    % Save result figure
    filename = sprintf('tire_result_%d.png', i);
    saveas(gcf, filename);

end

fprintf('\nTire stud detection completed.\n');
