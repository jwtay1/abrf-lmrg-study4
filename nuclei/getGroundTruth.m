%GETGROUNDTRUTH  Get the ground truth data
%
%  This script processes the ground truth files for the nuclear dataset and
%  saves the centroid, mean intensity, and volume as a MAT-file.

clearvars
clc

dataDir = 'D:\Work\Research Projects\2022 ABRF Study 4\data\GT\nuclei';
filenames = {'out_c00_dr90', 'out_c90_dr90', 'out_c00_dr10', 'out_c90_dr10'};  %In question order

outputDir = 'D:\Work\Research Projects\2022 ABRF Study 4\processed\nuclei';

GTdata = struct('Filename', {}, 'X', {}, 'Y', {}, 'Z', {}, 'Intensity', {}, 'Volume', {});

vxSize = [0.124 0.124 0.2];

for iFile = 1:numel(filenames)

    imgFile = fullfile(dataDir, [filenames{iFile}, '_image.tif']);
    labelFile = fullfile(dataDir, [filenames{iFile}, '_label.tif']);

    %Read metadata from image file
    fileInfo = imfinfo(imgFile);

    %Set up storage variables
    storeGTimage = zeros(fileInfo(1).Height, fileInfo(1).Width, numel(fileInfo), 'uint16');
    storeGTlabels = zeros(fileInfo(1).Height, fileInfo(1).Width, numel(fileInfo), 'uint16');

    %Read in the image and label data
    for iZ = 1:numel(fileInfo)

        storeGTimage(:, :, iZ) = imread(imgFile, iZ);
        storeGTlabels(:, :, iZ) = imread(labelFile, iZ);

    end

    %Parse using regionprops to get x, y, z, intensity and volume
    stats = regionprops3(storeGTlabels, storeGTimage, 'Centroid', 'MeanIntensity', 'Volume');

    %Append data to output struct
    GTdata(iFile).Filename = filenames{iFile};
    GTdata(iFile).X = stats.Centroid(:, 1) * vxSize(1);
    GTdata(iFile).Y = stats.Centroid(:, 2) * vxSize(2);
    GTdata(iFile).Z = stats.Centroid(:, 3) * vxSize(3);
    GTdata(iFile).Intensity = stats.MeanIntensity;
    GTdata(iFile).Volume = stats.Volume .* (vxSize(1) * vxSize(2) * vxSize(3));

end

%Save the file
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

save(fullfile(outputDir, 'GTnuclei.mat'), 'GTdata');