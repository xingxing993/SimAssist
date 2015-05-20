function objs = MatchPattern(objarr, cmdstr)
% Find the matching macro object(s) from objarr

ptns = {objarr.Pattern}';
idxm = cellfun(@(c) ~isempty(regexp(cmdstr, c)), ptns);
objs = objarr(idxm);

end