function sabt = regprotoblock_subsystem
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saProtoBlock('#SubSystem');
sabt.ProtoPriority = 1; % subsystem generally should be first checked
sabt.ProtoCheckMethod = @check_proto;

sabt.ProtoProperty = {'DictRenameMethod','InportStringMethod', 'OutportStringMethod', ...
    'PropagateUpstreamStringMethod', 'PropagateDownstreamStringMethod', ...
    'BlockSize','AutoSizeMethod', 'BlockPreferOption', 'LayoutSize',...
    'CleanMethod','PlusMethod','MinusMethod','ArrangePortMethod'};

sabt.MajorProperty = -1;
sabt.DictRenameMethod = 1;

sabt.PropagateUpstreamStringMethod = @subsys_propagate_inport;
sabt.PropagateDownstreamStringMethod = @subsys_propagate_outport;
sabt.OutportStringMethod = @subsys_gen_port_string;
sabt.InportStringMethod = @subsys_gen_port_string;

sabt.BlockSize = [150, 70];
sabt.AutoSizeMethod = -1;

sabt.BlockPreferOption.ShowName = 'on';

sabt.LayoutSize.PortSpacing = 35;
sabt.LayoutSize.ToLineOffset = [50 100];


sabt.ArrangePortMethod = {@subsys_arrange_inport, @subsys_arrange_outport};
sabt.CleanMethod = @clean;
sabt.PlusMethod = @subsys_plus;
sabt.MinusMethod = @subsys_minus;


end

function tf = check_proto(blkhdl)
tf = strcmp(get_param(blkhdl, 'BlockType'), 'SubSystem');
end

function actrec = clean(blkhdl, console)
actrec = saRecorder;
% remove unconnected inports and outports
actrec + subsys_minus(blkhdl, '-', console); % equivalent to '--'
end

function actrec = subsys_arrange_inport(blkhdl)
actrec = saRecorder;
lns = get_param(blkhdl,'LineHandles');
inportblks=find_system(blkhdl,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','FindAll','on','BlockType','Inport');
srcinfo = [];
for i=1:numel(lns.Inport)
    if lns.Inport(i)>0
        tmplnpos = get_param(lns.Inport(i), 'Points');
        srcinfo = [srcinfo; struct('Y', tmplnpos(1,2), 'BlockHandle', inportblks(i))];
    end
end
if ~isempty(srcinfo)
    [tmp, yidx] = sort([srcinfo.Y]); % in Y order
    for i=1:numel(yidx)
        actrec.SetParam(srcinfo(yidx(i)).BlockHandle, 'Port', int2str(i));
    end
end
end

function actrec = subsys_arrange_outport(blkhdl)
actrec = saRecorder;
lns = get_param(blkhdl,'LineHandles');
outportblks=find_system(blkhdl,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','FindAll','on','BlockType','Outport');
dstinfo = [];
for i=1:numel(lns.Outport)
    if lns.Outport(i)>0
        tmplnpos = get_param(lns.Outport(i), 'Points');
        dstinfo = [dstinfo; struct('Y', tmplnpos(end,2), 'BlockHandle', outportblks(i))];
    end
end
if ~isempty(dstinfo)
    [tmp, yidx] = sort([dstinfo.Y]); % in Y order
    for i=1:numel(yidx)
        actrec.SetParam(dstinfo(yidx(i)).BlockHandle, 'Port', int2str(i));
    end
end
end


function actrec = subsys_propagate_inport(sshdl, strarr)
% sshdl: block handle
% strarr : cell of strings at inports
actrec = saRecorder;
inportblks=find_system(sshdl,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','BlockType','Inport');
strarr = cellstr(strarr);
for i=1:numel(strarr)
    if isempty(strarr{i})
        continue;
    end
    actrec.SetParam(inportblks(i),'Name',strarr{i});
end
end


function actrec = subsys_propagate_outport(sshdl, strarr)
actrec = saRecorder;
outportblks=find_system(sshdl,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','BlockType','Outport');
strarr = cellstr(strarr);
for i=1:numel(strarr) %Try to trace forward a name for each port
    if isempty(strarr{i})
        continue;
    end
    actrec.SetParam(outportblks(i),'Name',strarr{i});
end
end

function thestr = subsys_gen_port_string(pthdl)
ptnum = get_param(pthdl, 'PortNumber');
parblk = get_param(pthdl, 'Parent');
pttyp = get_param(pthdl, 'PortType');
switch pttyp
    case 'inport'
        blktyp = 'Inport';
        ptblk=find_system(parblk,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','BlockType',blktyp,'Port',int2str(ptnum)); % Use name of the corresponding inport block
    case 'outport'
        blktyp = 'Outport';
        ptblk=find_system(parblk,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','BlockType',blktyp,'Port',int2str(ptnum)); % Use name of the corresponding outport block
    case 'trigger'
        blktyp = 'TriggerPort';
        ptblk=find_system(parblk,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','BlockType',blktyp); % Use name of the corresponding trigger block
    case 'enable'
        blktyp = 'EnablePort';
        ptblk=find_system(parblk,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','BlockType',blktyp); % Use name of the corresponding enable block
    otherwise
end
if ~isempty(ptblk)
    thestr=get_param(ptblk,'Name');
else
    thestr = '';
end
end


function actrec = subsys_plus(blkhdl, optstr, console)
actrec = saRecorder;
% command parse
[iptnum, optnum, fc, en] = parse_subsys(optstr);
% execution
% add inport/outport/enable/function call
subsys = getfullname(blkhdl);
currblks = find_system(subsys, 'FollowLinks','on', 'LookUnderMasks', 'on', 'FindAll', 'on', 'SearchDepth',1, 'Type', 'Block');
currblks = setdiff(currblks, blkhdl);
poss = get_param(currblks, 'Position');
if iscell(poss)
    posmat = cell2mat(poss);
else
    posmat = poss;
end
boundary = [min(posmat(:,1:2), [], 1), max(posmat(:,3:4), [], 1)];
%inport
if iptnum>0
    pos1 = [boundary(1), boundary(4)+50]; % default first inport position
    inportbt = console.MapTo('Inport');
    actrec + inportbt.AddBlockArray(pos1, iptnum, [subsys,'/In']);
end
%outport
if optnum>0
    pos2 = [boundary(3), boundary(4)+50]; % default first outport position
    outportbt = console.MapTo('Outport');
    actrec + outportbt.AddBlockArray(pos2, optnum, [subsys,'/Out']);
end
%function-call
if fc
    trigbt = console.MapTo('TriggerPort');
    ltpos = [150 30]; blkpos = [ltpos, ltpos+trigbt.GetBlockSize];
    actrec + trigbt.AddBlock([subsys,'/Trigger'],blkpos);
end
%enable
if en
    enablebt = console.MapTo('EnablePort');
    ltpos = [200 30]; blkpos = [ltpos, ltpos+enablebt.GetBlockSize];
    actrec + enablebt.AddBlock([subsys,'/Enable'],blkpos);
end

end

function actrec = subsys_minus(blkhdl, optstr, console)
actrec = saRecorder; 
actrec.Dummy;% use this trick to make actrec not empty (otherwise this action may be taken as unsuccessful)
if nargin<3 || isempty(console)
    side = [true, true];
else
    side = console.SessionPara.ConnectSide;
end
[iptnum, optnum, fc, en] = parse_subsys(optstr);
subsys = getfullname(blkhdl);
lns = get_param(blkhdl, 'LineHandles');
%inport
iptblks = find_system(subsys, 'FollowLinks','on', 'LookUnderMasks', 'on', 'FindAll', 'on', 'SearchDepth',1, 'BlockType', 'Inport');
cntr = 0;
if isequal(optstr, '-')
    iptnum = numel(iptblks);
end
if iptnum>0 && side(1)
    for i=numel(iptblks):-1:1
        blkln = get_param(iptblks(i), 'LineHandles');
        ptidx = str2double(get_param(iptblks(i), 'Port'));
        if blkln.Outport<0 && lns.Inport(ptidx)<0
            cntr = cntr+1;
            delete_block(iptblks(i));
        end
        if cntr==iptnum
            break;
        end
    end
end
%outport
optblks = find_system(subsys, 'FollowLinks','on', 'LookUnderMasks', 'on', 'FindAll', 'on', 'SearchDepth',1, 'BlockType', 'Outport');
cntr = 0;
if isequal(optstr, '-')
    optnum = numel(optblks);
end
if optnum>0 && side(2)
    for i=numel(optblks):-1:1
        blkln = get_param(optblks(i), 'LineHandles');
        ptidx = str2double(get_param(optblks(i), 'Port'));
        if blkln.Inport<0 && lns.Outport(ptidx)<0
            cntr = cntr+1;
            delete_block(optblks(i));
        end
        if cntr==optnum
            break;
        end
    end
end
%function-call
if fc
    fcblk = find_system(subsys, 'FollowLinks','on', 'LookUnderMasks', 'on', 'FindAll', 'on', 'SearchDepth',1, 'BlockType', 'TriggerPort');
    if ~isempty(fcblk)
        delete_block(fcblk);
    end
end
%enable
if en
    enblk = find_system(subsys, 'FollowLinks','on', 'LookUnderMasks', 'on', 'FindAll', 'on', 'SearchDepth',1, 'BlockType', 'EnablePort');
    if ~isempty(enblk)
        delete_block(enblk);
    end
end
end



function [iptnum, optnum, fc, en] = parse_subsys(operandstr)
[mstr, iptnum] = regexp(operandstr, 'in?(\d*)', 'match','tokens','once'); % inport
if isempty(mstr)
    iptnum = 0;
else
    if~isempty(iptnum{1})
        iptnum = str2double(iptnum{1});
    else
        iptnum = 1;
    end
    operandstr=regexprep(operandstr, 'in?(\d*)', '','once');
end
[mstr, optnum] = regexp(operandstr, 'o(?:ut)?(\d*)', 'match','tokens','once'); % outport
if isempty(mstr)
    optnum = 0;
else
    if~isempty(optnum{1})
        optnum = str2double(optnum{1});
    else
        optnum = 1;
    end
    operandstr=regexprep(operandstr, 'o(?:ut)?(\d*)', '','once');
end
if ~isempty(strfind(operandstr, 'fc')) %function call
    fc = true;
    operandstr=regexprep(operandstr,'fc','','once');
else
    fc = false;
end
if ~isempty(strfind(operandstr, 'en')) %enable
    en = true;
    operandstr=regexprep(operandstr,'en','','once');
else
    en = false;
end
end