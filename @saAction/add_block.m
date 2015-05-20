function add_block(obj,varargin)
obj.Data.Source = varargin{1};
prop = varargin(3:end);
% if 'Name' in property list, merge into destination parameter
loc = [];
for i=1:numel(prop)
    if isstr(prop{i}) && strcmp(prop{i}, 'Name')
        loc = i;
        break;
    end
end

if ~isempty(loc)
    obj.Data.Destination = regexprep(varargin{2}, '[^/]+$', prop{loc+1});
    prop([loc, loc+1])=[];
else
    obj.Data.Destination = varargin{2};
end
% action
obj.Handle = add_block(obj.Data.Source, obj.Data.Destination, 'MakeNameUnique', 'on', prop{:});
obj.Property = [prop(1:2:end);prop(2:2:end)];
end