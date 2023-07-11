%COMPAREDATA  Compare data from ground truth to replies
clearvars
clc
close all

GTfn = 'D:\Work\Research Projects\2022 ABRF Study 4\processed\nuclei\GTnuclei.mat';
Rfn = 'D:\Work\Research Projects\2022 ABRF Study 4\processed\nuclei\responsesNuclei.mat';

%Load the data
load(GTfn)
load(Rfn)

%%

storeTform = cell(1, numel(responseData));

for resIdx = 1:numel(responseData)

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


    storeTform{resIdx} = tform.A;


end

save('transforms.mat', 'storeTform')




% figure;
% %pcshowpair(moving,fixed,'MarkerSize',50)
% % figure;
% pcshowpair(movingReg,fixed,'MarkerSize',50)
