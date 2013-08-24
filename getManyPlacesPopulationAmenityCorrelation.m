function [manyPlacesPopulationAmenityCorrelation] = getManyPlacesPopulationAmenityCorrelation(amenityTags, places, gridSize, sigma, populationWeighted)
% Returns the correlation between population and amenity in grid format for various places and amenities
%
% INPUT:
%           amenityTags{i} (String Cell) - Name of the amenities to consider
%           places{j} (String Cell) - Names of polygon areas in OpenSteetMap
%           gridSize (Integer) - Grid granularity in metres
%           sigma (Integer) - Standard deviation to use for gaussian blurring
%           populationWeighted (Boolean) - Normalise the amenities by population?
% OUTPUT:
%           manyPlacesPopulationAmenityCorrelation(i,j) (Double) - Correlation of amenity
%               map of amenityTags{i} and population of places{j} in grid format
% EXAMPLE:
%           [manyPlacesPopulationAmenityCorrelation] = getManyPlacesPopulationAmenityCorrelation({'bar','atm','hospital'},{'Bristol','London'},250,1,true)

p = length(places);
a = length(amenityTags);
manyPlacesPopulationAmenityCorrelation = zeros(p,a);

for i=1:p
    place = places{i};
    manyPlacesPopulationAmenityCorrelation(i,:) = getPopulationAmenityCorrelation(amenityTags, place, gridSize, sigma, populationWeighted);
end