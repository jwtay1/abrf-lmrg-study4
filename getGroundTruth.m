%GETGROUNDTRUTH  Get the ground truth data

clearvars
clc

GTfname = 'D:\Work\Research Projects\2022 ABRF Study 4\data\GT\nuclei\out_c00_dr10_label.tif';
Intfname = 'D:\Work\Research Projects\2022 ABRF Study 4\data\GT\nuclei\out_c00_dr10_image.tif';

%Load the ground truth data in
fileInfo = imfinfo(Intfname);

storeGTimage = zeros(fileInfo(1).Height, fileInfo(1).Width, numel(fileInfo), 'uint16');
storeGTlabels = zeros(fileInfo(1).Height, fileInfo(1).Width, numel(fileInfo), 'uint16');

for iZ = 1:numel(fileInfo)

    storeGTlabels(:, :, iZ) = imread(GTfname, iZ);
    storeGTimage(:, :, iZ) = imread(Intfname, iZ);

%     imshowpair(storeGTimage(:, :, iZ), storeGTlabels(:, :, iZ));
%     pause;
    
end

%Parse using regionprops to get x, y, z, intensity and volume
stats = regionprops3(storeGTlabels, storeGTimage, 'Centroid', 'MeanIntensity', 'Volume');