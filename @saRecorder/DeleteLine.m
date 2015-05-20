function DeleteLine(obj,lnhdls)
lnhdls = saRemoveBranchLine(lnhdls);
for i=1:numel(lnhdls)
    sa = saAction('delete_line', lnhdls(i));
    obj.PushItem(sa);
end
end