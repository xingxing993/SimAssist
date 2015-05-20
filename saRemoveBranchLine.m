function objs = saRemoveBranchLine(objs)
lns = objs(strcmp(get_param(objs,'Type'),'line'));
lns_rmv = [];
for i=1:numel(lns)
    if ismember(get_param(lns(i),'LineParent'), objs)
        lns_rmv = [lns_rmv, lns(i)];
    end
end
objs = setdiff(objs, lns_rmv);
end