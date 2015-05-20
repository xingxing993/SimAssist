function blkset = saFindBroBlocks(blk)
% find HANDLES of all blocks of the entire signal flow:
% 1: 'From','Goto','GotoTagVisibility'
% 2: 'DataStoreMemory','DataStoreRead','DataStoreWrite'
if isempty(blk)
    blkset={};
else
    blkset = {blk};
end
blktyp = get_param(blk, 'BlockType');
startsys = get_param(blk, 'Parent');
startsysp = getfullname(startsys);
msktyp = get_param(blk, 'MaskType');
if ismember(blktyp, {'From','Goto','GotoTagVisibility'})
    tag = get_param(blk, 'GotoTag');
elseif ismember(blktyp, {'DataStoreMemory','DataStoreRead','DataStoreWrite'})
    tag = get_param(blk, 'DataStoreName');
elseif ismember(msktyp, {'LGPT_DataWriteEnable'})
    tag = get_param(blk, 'DataStoreName');
    blktyp = msktyp;
else
    return;
end
switch blktyp
    case 'From'
        % find goto
        % try at current system level first
        gotoblk = find_system(startsys, 'SearchDepth',1,'FollowLinks','on','LookUnderMasks','on','BlockType','Goto','GotoTag',tag,'TagVisibility','local');
        if isempty(gotoblk) % if no goto block at current level, look under through
            gotoblk = find_system(startsys,'FollowLinks','on','LookUnderMasks','on','BlockType','Goto','GotoTag',tag,'TagVisibility','scoped');
            if isempty(gotoblk) % if still none found
                rtsys = bdroot(startsys); %
                gotoblks = [{};find_system(rtsys,'FollowLinks','on','LookUnderMasks','on','BlockType','Goto','GotoTag',tag)];
                if isempty(gotoblks) % no Goto in the entire model
                    blkset = cellfun(@(h)get_param(h,'Handle'), blkset);
                    return;
                else % scoped goto at higher level or global goto
                    gotoblk = find_within_same_branch(blk, gotoblks, 'lowest');
                    if isempty(gotoblk)% must be global
                        gotoblk = gotoblks{1};
                    end
                end
            end
        end
        if iscell(gotoblk)
            gotoblk=gotoblk{1};
            blkset = saFindBroBlocks(gotoblk);
        else
            blkset = saFindBroBlocks(gotoblk);
        end
    case 'Goto'
        vis = get_param(blk, 'TagVisibility');
        if strcmp(vis, 'local')
            blkset = [{}; find_system(startsys, 'SearchDepth',1,'FollowLinks','on','LookUnderMasks','on','GotoTag',tag)];
        elseif strcmp(vis, 'global')
            rtsys = bdroot(startsys);
            blkset = [{}; find_system(rtsys,'FollowLinks','on','LookUnderMasks','on','GotoTag',tag)];
        elseif strcmp(vis, 'scoped')
            blk_sametags = [{}; find_system(bdroot(startsys),'FollowLinks','on','LookUnderMasks','on','BlockType','GotoTagVisibility','GotoTag',tag)];
            visblk = find_within_same_branch(blk, blk_sametags, 'highest');
            if ~isempty(visblk)
                rtsys = get_param(visblk, 'Parent');
            else
                rtsys = startsys;
            end
            blkset = [{}; find_system(rtsys,'FollowLinks','on','LookUnderMasks','on','GotoTag',tag)];
        else
        end
    case 'GotoTagVisibility'
        rtsys = startsys;
        blkset = [{}; find_system(rtsys,'FollowLinks','on','LookUnderMasks','on','GotoTag',tag)];
    case 'DataStoreMemory'
        rtsys = startsys;
        blkset = [{}; find_system(rtsys,'FollowLinks','on','LookUnderMasks','on','DataStoreName',tag)];
    case {'DataStoreRead','DataStoreWrite','LGPT_DataWriteEnable'}
        rtsys = bdroot(startsys);
        dsmblks = [{};find_system(rtsys,'FollowLinks','on','LookUnderMasks','on','BlockType','DataStoreMemory','DataStoreName',tag)];
        if isempty(dsmblks) % no DataStoreMemory, means global
            blkset = [{};find_system(rtsys,'FollowLinks','on','LookUnderMasks','on','DataStoreName',tag)];
        else
            dsmblk = find_within_same_branch(blk, dsmblks, 'lowest');
            blkset = saFindBroBlocks(dsmblk);
        end
    otherwise
end
if iscell(blkset)
    blkset = cellfun(@(h)get_param(h,'Handle'), blkset);
end 
end

function blk = find_within_same_branch(archblk, candidates, level)
    if nargin<3
        level = 'highest';
    end
    blks={};
    archsys = get_param(archblk, 'Parent');
    candsyss = [{};get_param(candidates, 'Parent')];
    n1 = numel(archsys);
    for i=1:numel(candidates)
        yes = strncmp(archsys, candsyss{i}, min(numel(candsyss{i}),n1));
        if yes
            blks = [blks; candidates(i)];
        end
    end
    if ~isempty(blks)
        parsyss = get_param(blks, 'Parent');
        len = cellfun('length', parsyss);
        [tmp, idx] = sort(len);
        blks = blks(idx);
        switch level
            case 'highest'
                blk = blks{1};
            case 'lowest'
                blk = blks{end};
            otherwise
        end
    else
        blk = '';
    end
end