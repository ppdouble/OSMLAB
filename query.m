% after changing the query,
% clear;

t1 = 'atm';
t2 = 'pub';
place = 'Cardiff';

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
    p1 = cell2mat(importDB(q1));
end

if ~exist('p2','var')
    p2 = cell2mat(importDB(q2));
end

if ~exist('p3','var')
    p3 = cell2mat(importDB(q3));
end

% longitude is (:,1)
% latitude  is (:,2)

% f1 = figure;
% set(f1,'name',[place ' x ' t1 ' o ' t2],'numbertitle','off')
% 
% hold on;
% plot(p1(:,1),p1(:,2),'x','Color','blue');
% plot(p2(:,1),p2(:,2),'o','Color','red');
% plot(p3(:,1),p3(:,2),'.','Color','green');

max1 = max(p3(:,1));
max2 = max(p3(:,2));
min1 = min(p3(:,1));
min2 = min(p3(:,2));

% delta of min and max longitudes
d1 = max1 - min1;
% delta of min and max latitudes of the map
d2 = max2 - min2;

% level of detail in longitudinal direction
x1 = 50;
% level of detail in latitudinal direction calculated as a round off of the
% proportion of the map.
x2 = round (x1* (d2 / d1));

% size of each unit cell
u1 = d1 / x1;
u2 = d2 / x2;

% create empty matrices with zeroes to count the number of amenities that
% fall within the each of the grid
a1 = zeros(x1,x2);
a2 = zeros(x1,x2);

% number of each of the amenities
[n1,~]=size(p1);
[n2,~]=size(p2);

for i = 1:n1,
    g1 = ceil((p1(i,1) - min1)/u1);
    g2 = ceil((p1(i,2) - min2)/u2);
    a1(g1,g2) = a1(g1,g2) + 1;
end

for i = 1:n1,
    g1 = ceil((p2(i,1) - min1)/u1);
    g2 = ceil((p2(i,2) - min2)/u2);
    a2(g1,g2) = a2(g1,g2) + 1;
end

disp(corrcoef(a1,a2));
