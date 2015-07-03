function sabt = regblock_subsystem
%REGBLK_SUBSYSTEM
% Registration of SubSystem block type in SimAssist

sabt = saBlock('SubSystem');

sabt.RoutinePattern = '^(ss|subsys|subsystem)';
sabt.RoutineMethod = @routine_subsystem;

ssproto = regprotoblock_subsystem;
sabt.UseProto(ssproto);
end

function [actrec, success] = routine_subsystem(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('SubSystem');
srchdls = saFindSystem(gcs,'line_sender');
dsthdls = saFindSystem(gcs,'inport_unconnected');
%parse input command
optstr = regexprep(cmdstr, '^(ss|subsys|subsystem)', '', 'once');
iptnum = regexp(optstr, 'in?(\d+)', 'tokens','once'); % inport
if ~isempty(iptnum)
    iptnum = str2double(iptnum{1});
    optstr=regexprep(optstr, 'in?(\d+)', '','once');
else
    if ~isempty(srchdls)
        iptnum = numel(srchdls);
    else
        iptnum = 1;
    end
end
optnum = regexp(optstr, 'o(?:ut)?*(\d+)', 'tokens','once'); % outport
if ~isempty(optnum)
    optnum = str2double(optnum{1});
    optstr=regexprep(optstr, 'o(?:ut)?*(\d+)', '','once');
else
    if ~isempty(dsthdls)
        optnum = numel(dsthdls);
    else
        optnum = 1;
    end
end
if ~isempty(strfind(optstr, 'fc')) %function call
    fc = true;
    optstr=regexprep(optstr,'fc','','once');
else
    fc = false;
end
if ~isempty(strfind(optstr, 'en')) %enable
    en = true;
    optstr=regexprep(optstr,'en','','once');
else
    en = false;
end
if ~isempty(regexp(optstr, 'atomic|atom|atm|atmc','once')) %enable
    atomic = 'on';
    optstr=regexprep(optstr,'atomic|atom|atm|atmc','','once');
else
    atomic = 'off';
end
tmp = strtrim(optstr);
if ~isempty(tmp)
    subsysname = tmp;
else
    subsysname = 'SubSystem';
end

% add subsystem block
[actrec2, block] = btobj.AddBlock(subsysname,...
    'TreatAsAtomicUnit',atomic);
actrec + actrec2;

% add inport/outport/enable/function call
subsys = getfullname(block);
%inport
pos1 = [110   103]; % default first inport position
inportbt = console.MapTo('Inport');
inportbt.AddBlockArray(pos1, iptnum, [subsys,'/In']);
%outport
pos2 = [360   103]; % default first outport position
outportbt = console.MapTo('Outport');
outportbt.AddBlockArray(pos2, optnum, [subsys,'/Out']);
%function-call
if fc
    trigbt = console.MapTo('TriggerPort');
    ltpos = [150 30]; blkpos = [ltpos, ltpos+trigbt.BlockSize];
    trigbt.AddBlock([subsys,'/Trigger'],blkpos);
end
%enable
if en
    enablebt = console.MapTo('EnablePort');
    ltpos = [200 30]; blkpos = [ltpos, ltpos+enablebt.BlockSize];
    enablebt.AddBlock([subsys,'/Enable'],blkpos);
end

btobj.AutoSize(block);
if ~isempty(srchdls)
    actrec.MultiAutoLine(srchdls, block);
    actrec + btobj.PropagateUpstreamString(block);
end
if ~isempty(dsthdls)
    actrec.MultiAutoLine(block, dsthdls);
    actrec + btobj.PropagateDownstreamString(block);
end
success = true;
end