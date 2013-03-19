% after changing the query, 
clear;

t1 = 'atm';
t2 = 'pub';
place = 'Edinburgh';

q1 = ['SELECT DISTINCT ST_X(p.way), ST_Y(p.way) '...
          'FROM planet_osm_point AS p, '...
          '(SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS q '...          
          'WHERE (p.amenity=''' t1 ''' OR p.tags ? ''' t1 ''') AND ST_Intersects(p.way, q.way)'];
        
q2 = ['SELECT DISTINCT ST_X(p.way), ST_Y(p.way) '...
          'FROM planet_osm_point AS p, '...
          '(SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS q '...
          'WHERE (p.amenity=''' t2 ''' OR p.tags ? ''' t2 ''') AND ST_Intersects(p.way, q.way)'];
      
q3 = ['SELECT ST_X((g.p).geom), ST_Y((g.p).geom) '...
           'FROM '...
           '(SELECT ST_DumpPoints(f.way) AS p FROM '...
           ' (SELECT way FROM planet_osm_polygon WHERE name = ''' place ''' ORDER BY ST_NPoints(way) DESC LIMIT 1) AS f) AS g'];        


% (g.p).path[1],(g.p).path[2], ;

if ~exist('p1','var')
    p1 = importDB(q1);
end

if ~exist('p2','var')
    p2 = importDB(q2);
end

if ~exist('p3','var')
    p3 = importDB(q3);
end

% p1_lon = cell2mat(p1(:,1));
% p1_lat = cell2mat(p1(:,2));
% 
% 
% p2_lon = cell2mat(p2(:,1));
% p2_lat = cell2mat(p2(:,2));

p3_lon = cell2mat(p3(:,1));
p3_lat = cell2mat(p3(:,2));

f = figure;
set(f,'name',[place ' x ' t1 ' o ' t2],'numbertitle','off')

hold on;
% plot(p1_lon,p1_lat,'x');
% plot(p2_lon,p2_lat,'o');
plot(p3_lon,p3_lat,'.');
