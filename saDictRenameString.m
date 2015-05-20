function namout=saDictRenameString(namin,dict)
bestsplit=parse_string(namin,dict(:,1));
namout='';
for kk=1:numel(bestsplit.String)
    matchidx=strcmp(bestsplit.String{kk},dict(:,1));
    if any(matchidx)
        matchterm=dict(matchidx,:);
        namout=[namout,matchterm{1,2}];
    else
        namout=[namout,bestsplit.String{kk}];
    end
end
end