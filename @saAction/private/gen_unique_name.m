function validname = gen_unique_name(parsys,rawname)
blks=find_system(parsys,'FollowLinks','on','LookUnderMasks','on','RegExp','on','SearchDepth',1);
validname = genvarname(rawname,get_param(blks,'Name'));
end