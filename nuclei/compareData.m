%COMPAREDATA  Compare data from ground truth to replies

%Run the getGroundTruth file first.

T = readtable('../data/Q6.13/R_1ePOgKBqC8pSpzT_Murphy_Malea_nuclei1.csv');

xx = T.x;
yy = T.y;
zz = T.z;

diff = sqrt((xx - stats.Centroid(1)).^2 + (yy - stats.Centroid(2)).^2 + (zz - stats.Centroid(3)).^2);