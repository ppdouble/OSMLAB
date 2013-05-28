function [p]=getFileOrQuery(f,q,varargin)
if exist(f,'file')
    p = csvread(f);
else
    p = importDB(q);
    
    if (nargin > 2)
        if (strmatch(varargin{1},'highway'))
            highways = varargin{2};
            highwayType = varargin{3};
            v=p(:,4);
            p(:,4)=cellfun(@(x) highwayType(strmatch(x,highways,'exact')),p(:,4),'UniformOutput',false);
            pp=cellfun(@isempty,p(:,4));
            [i,j] = find(pp);
            if(i)
                disp('Omitting the following tags:');
                disp(v(i));
                p(i,:)=[];
            end
        end
    end
    
    p = cell2mat(p);
    csvwrite(f,p);
    
end