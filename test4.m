loadHighwayDefinition;
q=['SELECT ST_X((g.p).geom), ST_Y((g.p).geom), (g.p).path[1], g.q FROM ( SELECT 1 AS edge_id, ST_DumpPoints(r.way) AS p, r.highway AS q  FROM  planet_osm_line AS r, (  SELECT way FROM planet_osm_polygon WHERE name = ''Bristol'' ORDER BY ST_NPoints(way) DESC LIMIT 1 ) AS s  WHERE highway <> '''' AND ST_Intersects(r.way, s.way)) AS g'];
p=importDB(q);
v=p(:,4);
p(:,4)=cellfun(@(x) highwayType(strmatch(x,highways,'exact')),p(:,4),'UniformOutput',false);
pp=cellfun(@isempty,p(:,4));
[i,j] = find(pp)
disp(v(i));
p(i,:)=[];