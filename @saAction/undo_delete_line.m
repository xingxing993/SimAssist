function undo_delete_line(obj)
for i=1:numel(obj.Data.DstPort)
    try
        obj.Handle = add_line(obj.Data.System,obj.Data.SrcPort,obj.Data.DstPort(i),'autorouting','on');
    end
end
end