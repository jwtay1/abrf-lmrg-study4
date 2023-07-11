%COMPAREDATA  Compare data from ground truth to replies
clearvars
clc
close all

GTfn = 'C:\Users\jianw\OneDrive - UCB-O365\Projects\2022 ABRF Study 4\processed\nuclei\GTnuclei.mat';
Rfn = 'C:\Users\jianw\OneDrive - UCB-O365\Projects\2022 ABRF Study 4\processed\nuclei\responsesNuclei.mat';

%Load the data
load(GTfn)
load(Rfn)

%TODO:
% * Is GT in microns or pixels?
% * Decompose into rotation and scale
% * Run over all data sets
% * Export data

%%

storeTform = cell(1, numel(responseData));

storeMetrics = struct;

for resIdx = 1%:numel(responseData)

    % resIdx = 2;

    %Load response data as a pointCloud object (M-by-3)
    moving = pointCloud([responseData(resIdx).nucl1data.X ...
        responseData(resIdx).nucl1data.Y, responseData(resIdx).nucl1data.Z]);

    %Load ground truth data as a pointCloud object
    fixed = pointCloud([GTdata(1).X ...
        GTdata(1).Y, GTdata(1).Z]);

    %%
    % [tform, movingReg, rmse] = pcregistercpd(moving, fixed, 'Transform','rigid');
    [tform, movingReg, rmserr] = pcregistercpd(moving, fixed, 'Transform','affine');

    %[tform, movingReg, rmse] = pcregistericp(moving, fixed);
    % storeTform{resIdx} = tform.A;



    %Use linear assignment to match points
    Cost = pdist2(movingReg.Location, fixed.Location, 'euclidean');
    [M, uR, UC] = matchpairs(Cost, 1.01 * max(Cost(:)));
    %M(:, 1) is the index of the movingReg
    %M(:, 2) is the index of the fixed location

    %Assemble the final matched and registered response
    regResponseData.X = responseData(resIdx).nucl1data.X(M(:, 1));
    regResponseData.Y = responseData(resIdx).nucl1data.Y(M(:, 1));
    regResponseData.Z = responseData(resIdx).nucl1data.Z(M(:, 1));
    regResponseData.Intensity = responseData(resIdx).nucl1data.Intensity(M(:, 1));
    regResponseData.Volume = responseData(resIdx).nucl1data.Volume(M(:, 1));

    %Save the output data into a struct, which we will export into a csv
    %later
    storeMetrics(resIdx).Rotation = 0;
    storeMetrics(resIdx).Scale = 0;
    storeMetrics(resIdx).Translation = 0;

    responseLoc = [regResponseData.X, regResponseData.Y, regResponseData.Z];

    %Need to change RMSE to take into account the five different points
    storeMetrics(resIdx).Pos_RMSE = rmse(responseLoc, fixed.Location);
    storeMetrics(resIdx).Intensity_RMSE = rmse(responseData(1).nucl1data.Intensity,...
        GTdata(1).Intensity);
    storeMetrics(resIdx).Volume_RMSE = rmse(responseData(1).nucl1data.Volume,...
        GTdata(1).Volume);


end

% save('transforms.mat', 'storeTform')


figure;
pcshowpair(moving,fixed,'MarkerSize',50)
% figure;
pcshowpair(movingReg,fixed,'MarkerSize',50)
