%COMPAREDATA  Compare data from ground truth to replies
clearvars
clc
close all

GTfn = 'C:\Users\jianw\OneDrive - UCB-O365\Projects\2022 ABRF Study 4\processed\nuclei\GTnuclei.mat';
Rfn = 'C:\Users\jianw\OneDrive - UCB-O365\Projects\2022 ABRF Study 4\processed\nuclei\responsesNuclei.mat';

%Load the data
load(GTfn)
load(Rfn)

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
    [tform, movingReg, rmse] = pcregistercpd(moving, fixed, 'Transform','affine');

    %[tform, movingReg, rmse] = pcregistericp(moving, fixed);
    % storeTform{resIdx} = tform.A;

    %TODO:
    % * Do we need to reorder/assign data?
    % * Is GT in microns or pixels?

    %Use linear assignment to match points
    Cost = pdist2(movingReg.Location, fixed.Location, 'euclidean');
    [M, uR, UC] = matchpairs(Cost, 1.01 * max(Cost(:)));

    %Assemble the final matched and registered response
    regResponseData.X = responseData(resIdx).nucl1data.X(M(:, 1));
    regResponseData.Y = responseData(resIdx).nucl1data.Y(M(:, 1));
    regResponseData.Z = responseData(resIdx).nucl1data.Z(M(:, 1));
    regResponseData.Intensity = responseData(resIdx).nucl1data.Intensity(M(:, 1));
    regResponseData.Volume = responseData(resIdx).nucl1data.Volume(M(:, 1));


    %M(:, 1) is the index of the movingReg
    %M(:, 2) is the index of the fixed location

    


    % % %Sanity check
    % % for ii = 1:size(M, 1)
    % % 
    % %     plot3(movingReg.Location(M(ii, 1), 1), ...
    % %         movingReg.Location(M(ii, 1), 2), ...
    % %         movingReg.Location(M(ii, 1), 3), 'ro')
    % %     hold on
    % %     text(movingReg.Location(M(ii, 1), 1), ...
    % %         movingReg.Location(M(ii, 1), 2),...
    % %         movingReg.Location(M(ii, 1), 3), ... 
    % %         int2str(M(ii, 1)), 'color', 'red');
    % % 
    % %     plot3(fixed.Location(M(ii, 2), 1), ...
    % %         fixed.Location(M(ii, 2), 2), ...
    % %         fixed.Location(M(ii, 2), 3), 'bo')
    % %     text(fixed.Location(M(ii, 2), 1), ...
    % %         fixed.Location(M(ii, 2), 2), ...
    % %         fixed.Location(M(ii, 2), 3), ...
    % %         int2str(M(ii, 2)), 'color', 'blue')
    % % 
    % %     % hold on
    % %     % text(movingReg.Location(M(:, 1), 1), ...
    % %     %     movingReg.Location(M(:, 1), 2), int2str(M(:, 1)));
    % % 
    % % 
    % % end
    % % hold off

    % 
    % 
    % %Save the output data into a struct, which we will export into a csv
    % %later
    % storeMetrics(resIdx).Rotation = 0;
    % storeMetrics(resIdx).Scale = 0;
    % storeMetrics(resIdx).Translation = 0;
    % 
    % storeMetrics(resIdx).Pos_RMSE = rmse(movingReg, fixed);
    % storeMetrics(resIdx).Intensity_RMSE = rmse(responseData(1).nucl1data.Intensity,...
    %     GTdata(1).Intensity);
    % storeMetrics(resIdx).Volume_RMSE = rmse(responseData(1).nucl1data.Volume,...
    %     GTdata(1).Volume);
    % 

end

% save('transforms.mat', 'storeTform')


figure;
pcshowpair(moving,fixed,'MarkerSize',50)
% figure;
pcshowpair(movingReg,fixed,'MarkerSize',50)
