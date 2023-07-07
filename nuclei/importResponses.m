%IMPORTRESPONSES  Import survey responses
%
%  This script imports survey responses as a struct, binning the responses
%  from individual together.
%
%  Output data struct:
%     responseID - alphanumeric_code
%     nuclXdata - X being image
%        .X,Y,Z
%     nuclXcalibration - calibration data

clearvars
clc

dataDir = 'D:\Work\Research Projects\2022 ABRF Study 4\data\';
questionDirs = {'Q6.13', 'Q7.13', 'Q8.13', 'Q9.13'};

calibrationDirs = {'Q6.14', 'Q7.14', 'Q8.14', 'Q9.14'};


outputDir = 'D:\Work\Research Projects\2022 ABRF Study 4\processed\nuclei';

%Create output data structure
responseData = struct('responseID', {}, ...
    'nucl1data', {}, 'nucl1calib', {}, ...
    'nucl2data', {}, 'nucl2calib', {}, ...
    'nucl3data', {}, 'nucl3calib', {}, ...
    'nucl4data', {}, 'nucl4calib', {});

for iQuestion = 1:numel(questionDirs)

    currDir = fullfile(dataDir, questionDirs{iQuestion});

    %Get a list of CSV files in the question directory
    csvFiles = dir(fullfile(currDir, '*.csv'));

    if isempty(csvFiles)
        error('importResponses:NoFilesFound', 'Directory %s does not contain CSV files.', currDir)
    end

    for iFile = 1:numel(csvFiles)

        %Read in answers as a table
        T = readtable(fullfile(csvFiles(iFile).folder, csvFiles(iFile).name));

        T = renameTableCols(T);

        %Extract response ID
        currResponseID = regexp(csvFiles(iFile).name, ...
            'R_([a-zA-Z0-9]*)_.*', 'tokens');

        %Append data to output struct
        currDataset = ['nucl', int2str(iQuestion), 'data'];

        %Determine if respondent is already present in struct
        if ~isempty(responseData)
            idx = ismember({responseData.responseID}, currResponseID{1}{1});
        else
            idx = false;
        end

        if any(idx)

            idx = find(idx, 1, 'first');

        else
            %Create a new entry
            idx = numel(responseData) + 1;

        end

        responseData(idx).responseID = currResponseID{1}{1};
        responseData(idx).(currDataset).X = T.x;
        responseData(idx).(currDataset).Y = T.y;
        responseData(idx).(currDataset).Z = T.z;
        responseData(idx).(currDataset).Intensity = T.intensity;
        responseData(idx).(currDataset).Volume = T.volume;

    end

end

%Load in the calibration data
for iCalib = 1:numel(calibrationDirs)

    currDir = fullfile(dataDir, questionDirs{iCalib});

    %Get a list of CSV files in the question directory
    csvFiles = dir(fullfile(currDir, '*.csv'));

    if isempty(csvFiles)
        error('importResponses:NoFilesFound', 'Directory %s does not contain CSV files.', currDir)
    end

    for iFile = 1:numel(csvFiles)

        %Read in answers as a table
        T = readtable(fullfile(csvFiles(iFile).folder, csvFiles(iFile).name));

        T = renameTableCols(T);

        %Extract response ID
        currResponseID = regexp(csvFiles(iFile).name, ...
            'R_([a-zA-Z0-9]*)_.*', 'tokens');

        %Append data to output struct
        currDataset = ['nucl', int2str(iCalib), 'calib'];

        %Determine if respondent is already present in struct
        if ~isempty(responseData)
            idx = ismember({responseData.responseID}, currResponseID{1}{1});
        else
            idx = false;
        end

        if any(idx)

            idx = find(idx, 1, 'first');

        else
            %Create a new entry
            idx = numel(responseData) + 1;

        end
        responseData(idx).(currDataset).X = T.x;
        responseData(idx).(currDataset).Y = T.y;
        responseData(idx).(currDataset).Z = T.z;
        responseData(idx).(currDataset).Intensity = T.intensity;
        responseData(idx).(currDataset).Volume = T.volume;

    end


end

save(fullfile(outputDir, 'responsesNuclei.mat'), 'responseData')


function tbl = renameTableCols(tbl)
%RENAMETABLECOLS  Rename table columns
%
%  T = RENAMETABLECOLS(T) will rename table columns (properties) to match
%  the expected data: x, y, z, intensity, volume. The table columns are
%  identified based on which column in closest, as calculated using the
%  Levahstein distance.

%Change table columns to lowercase names
tbl = renamevars(tbl, 1:width(tbl), lower(tbl.Properties.VariableNames));

%If table columns were not named correctly, rename them
tableProperties = tbl.Properties.VariableNames;
if ~ismember('x', tbl.Properties.VariableNames)

    strIdx = findClosestString('x', tableProperties);

    %Rename the string
    tbl = renamevars(tbl, strIdx, {'x'});

end

if ~ismember('y', tbl.Properties.VariableNames)

    strIdx = findClosestString('y', tableProperties);

    %Rename the string
    tbl = renamevars(tbl, strIdx, {'y'});

end

if ~ismember('z', tbl.Properties.VariableNames)

    strIdx = findClosestString('z', tableProperties);

    %Rename the string
    tbl = renamevars(tbl, strIdx, {'z'});

end

if ~ismember('intensity', tbl.Properties.VariableNames)

    strIdx = findClosestString('intensity', tableProperties);

    %Rename the string
    tbl = renamevars(tbl, strIdx, {'intensity'});

end

if ~ismember('volume', tbl.Properties.VariableNames)

    strIdx = findClosestString('volume', tableProperties);

    %Rename the string
    tbl = renamevars(tbl, strIdx, {'volume'});

end

end
















