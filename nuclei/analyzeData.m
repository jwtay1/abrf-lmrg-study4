%ANALYZEDATA  Analyze nuclear data
%
%  This script runs data analysis on the responses.

clearvars
clc

GTfn = 'D:\Work\Research Projects\2022 ABRF Study 4\processed\nuclei\GTnuclei.mat';
Rfn = 'D:\Work\Research Projects\2022 ABRF Study 4\processed\nuclei\responsesNuclei.mat';

%Load the data
load(GTfn)
load(Rfn)

%Summarize the responses






%Compare against ground truth
for iResp = 1:numel(responseData)

    if ~isempty(responseData(iResp).nucl1data)

        xDiff = (responseData(iResp).nucl1data.X - GTdata(1).X).^2;
        yDiff = (responseData(iResp).nucl1data.Y - GTdata(1).Y).^2;
        zDiff = (responseData(iResp).nucl1data.Z - GTdata(1).Z).^2;
        intDiff = (responseData(iResp).nucl1data.Intensity - GTdata(1).Intensity).^2;
        volDiff = (responseData(iResp).nucl1data.Volume - GTdata(1).Volume).^2;

        responseData(iResp).nucl1data.posDiff = sqrt(sum(xDiff + yDiff + zDiff));
        responseData(iResp).nucl1data.intDiff = sqrt(sum(intDiff));
        responseData(iResp).nucl1data.volDiff = sqrt(sum(volDiff));
        responseData(iResp).nucl1data.totalDiff = sqrt(sum(xDiff + yDiff + zDiff + intDiff + volDiff));

    end


    if ~isempty(responseData(iResp).nucl2data)

        xDiff = (responseData(iResp).nucl2data.X - GTdata(2).X).^2;
        yDiff = (responseData(iResp).nucl2data.Y - GTdata(2).Y).^2;
        zDiff = (responseData(iResp).nucl2data.Z - GTdata(2).Z).^2;
        intDiff = (responseData(iResp).nucl2data.Intensity - GTdata(2).Intensity).^2;
        volDiff = (responseData(iResp).nucl2data.Volume - GTdata(2).Volume).^2;

        responseData(iResp).nucl2data.posDiff = sqrt(sum(xDiff + yDiff + zDiff));
        responseData(iResp).nucl2data.intDiff = sqrt(sum(intDiff));
        responseData(iResp).nucl2data.volDiff = sqrt(sum(volDiff));
        responseData(iResp).nucl2data.totalDiff = sqrt(sum(xDiff + yDiff + zDiff + intDiff + volDiff));

    end

    if ~isempty(responseData(iResp).nucl3data)

        xDiff = (responseData(iResp).nucl3data.X - GTdata(3).X).^2;
        yDiff = (responseData(iResp).nucl3data.Y - GTdata(3).Y).^2;
        zDiff = (responseData(iResp).nucl3data.Z - GTdata(3).Z).^2;
        intDiff = (responseData(iResp).nucl3data.Intensity - GTdata(3).Intensity).^2;
        volDiff = (responseData(iResp).nucl3data.Volume - GTdata(3).Volume).^2;

        responseData(iResp).nucl3data.posDiff = sqrt(sum(xDiff + yDiff + zDiff));
        responseData(iResp).nucl3data.intDiff = sqrt(sum(intDiff));
        responseData(iResp).nucl3data.volDiff = sqrt(sum(volDiff));
        responseData(iResp).nucl3data.totalDiff = sqrt(sum(xDiff + yDiff + zDiff + intDiff + volDiff));

    end

    if ~isempty(responseData(iResp).nucl4data)

        xDiff = (responseData(iResp).nucl4data.X - GTdata(4).X).^2;
        yDiff = (responseData(iResp).nucl4data.Y - GTdata(4).Y).^2;
        zDiff = (responseData(iResp).nucl4data.Z - GTdata(4).Z).^2;
        intDiff = (responseData(iResp).nucl4data.Intensity - GTdata(4).Intensity).^2;
        volDiff = (responseData(iResp).nucl4data.Volume - GTdata(4).Volume).^2;

        responseData(iResp).nucl4data.posDiff = sqrt(sum(xDiff + yDiff + zDiff));
        responseData(iResp).nucl4data.intDiff = sqrt(sum(intDiff));
        responseData(iResp).nucl4data.volDiff = sqrt(sum(volDiff));
        responseData(iResp).nucl4data.totalDiff = sqrt(sum(xDiff + yDiff + zDiff + intDiff + volDiff));
        

    end


end
