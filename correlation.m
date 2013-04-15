close all;

city = {'Manchester','Birmingham','London'};
amenity = {'bar','atm','hospital'};

[~,nc] = size(city);

for i = 1:nc,
    [c1,~,b1(1,i),b1(2,i)]=query('bar','atm',city{i});
    [c2,~,b2(1,i),b2(2,i)]=query('bar','hospital',city{i});
    % correlation between amenity 1 and amenity 2
    a(1,i) = c1(1,2);
    a(2,i) = c2(1,2);
    % correlation between population and amenity 1, 2 and 3 (eg. bar, atm and hospital)
    d(1,i) = c1(1,3);
    d(2,i) = c1(2,3);
    d(3,i) = c2(2,3);
end

f1 = figure;
%colormap(gray);
bar(a);
legend (city);
set(f1,'Position', [0, 0, 800, 300]);
set(gca,'XTickLabel',upper({'bar vs atm','bar vs hospital'}),'FontSize',14);
savefig(['cities-comparing-' amenity{:} '.pdf'],f1,'pdf');

f2 = figure;
%colormap(gray);
bar(d);
legend (city,'Location','NorthWest');
set(f2,'Position', [0, 0, 800, 300]);
set(gca,'XTickLabel',upper(amenity),'FontSize',14)
savefig(['population-vs-' amenity{:} '.pdf'],f2,'pdf');

disp (b1);
disp (b2);