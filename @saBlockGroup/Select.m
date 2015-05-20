function Select(obj)
for i=1:obj.BlockCount
    set_param(obj.BlockHandles(i),'Selected','on');
end
end