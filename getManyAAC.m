function [manyAAC, manyTimes] = getManyAAC(amenityTags, places, gridSizes, sigmas)
% Returns the correlation between Amenity/person of different granularities of gridSizes and sigmas for many places and amenities
%
% INPUT:
%           amenityTags(m) (String) - Name of the amenities to consider
%           places(n) (String) - Names of polygon areas in OpenSteetMap
%           gridSizes(i) (Integer Array) - Array of Grid granularity in metres
%           sigmas(j) (Integer Array) - Standard deviation to use for gaussian blurring
% OUTPUT:
%           manyGridSizesSigmasAAC{m,n}(i,j) (Double) 
%               Correlation between amenity map of amenityTags{m} of given 
%               places{n} in grid format for various gridSizes(i) and sigmas(j)
%           manyTimes{m,n}(i,j) (Double) - Time taken to process manyGridSizesSigmasAAC{m,n}(i,j)
% EXAMPLE:
%           [manyGridSizesSigmasAAC, manyTimes] = getManyGridSizesSigmasAACs({'hospital','bar'},{'Bristol','Manchester'},[100:100:4000],[0.2:0.2:8])

g = length(gridSizes);
s = length(sigmas);

a = length(amenityTags);
p = length(places);

manyAAC = cell(p,a,a);
manyTimes = cell(p,a,a);

%%
for m = 1:length(places)
    place = places{m};
    for n = 1:length(amenityTags)
        for o = (n+1):length(amenityTags)

                amenityTag1 = amenityTags{n};
                amenityTag2 = amenityTags{o};

                fCorr = ['./results/AAC/manyGridSizesSigmasAmenityAmenityCorrelation-' place '-' amenityTag1 '-' amenityTag2];
                fCorrR = ['./results/AAC/manyGridSizesSigmasAmenityAmenityCorrelation-' place '-' amenityTag2 '-' amenityTag1];
                fTime = ['./results/AAC/time-manyGridSizesSigmasAmenityAmenityCorrelation-' place '-' amenityTag1 '-' amenityTag2];
                fTimeR = ['./results/AAC/time-manyGridSizesSigmasAmenityAmenityCorrelation-' place '-' amenityTag2 '-' amenityTag1];

                if exist(fCorr,'file') && exist(fTime,'file')
                    correlation = csvread(fCorr);
                    time = csvread(fTime);
                elseif exist(fCorrR,'file') && exist(fTimeR,'file')
                    correlation = csvread(fCorrR);
                    time = csvread(fTimeR);
                else
                    correlation = zeros(g,s);
                    time = zeros(g,s);

                    step = ['Processing ' place ':' amenityTag1 ':' amenityTag2 '...'];
                    disp(step);

                    h = waitbar(0,step);

                    for i=1:g
                        gridSize = gridSizes(i);
                        for j=1:s
                            tic;
                            completed = (i-1 + j/s)/g;
                            waitbar(completed,h,[step num2str(completed*100) '%']);
                            sigma = sigmas(j);
                            disp(['Processing gridSize:sigma (' num2str(gridSize) ':' num2str(sigma) ')...']);                            
                           
                            correlation(i,j) = getAAC({amenityTag1 amenityTag2}, place, gridSize, sigma);
                            time(i,j) = toc;
                        end
                    end

                    close(h);

                    disp(['Saving results to file ' fCorr '...']);
                    csvwrite(fCorr,correlation);
                    disp(['Saving times to file ' fTime '...']);
                    csvwrite(fTime,time);
                end

                manyAAC{m,n,o} = correlation;
                manyAAC{m,o,n} = correlation;
                manyTimes{m,n,o} = time;
                manyTimes{m,o,n} = time;
        end
    end
end