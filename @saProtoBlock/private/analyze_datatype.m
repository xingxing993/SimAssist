function dt = analyze_datatype(str)
dt = '';
if ismember(str, {'true','false','TRUE','FALSE'})
    dt = 'boolean';
elseif ~isempty(regexp(str, '\.\d+', 'once'))
%     dt = 'single';
end
end