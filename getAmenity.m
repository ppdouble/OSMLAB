function [result] = getAmenity(amenity, place)

query = ['SELECT DISTINCT ST_X(p.way), ST_Y(p.way) '...
        'FROM planet_osm_point AS p, '...
        '(SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS q '...
        'WHERE (p.amenity=''' amenity ''' OR p.tags ? ''' amenity ''') AND ST_Intersects(p.way, q.way)'];

result = fileOrQuery(['./cache/' amenity '-' place], query);