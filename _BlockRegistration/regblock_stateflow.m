function sabt = regblock_stateflow
%REGBLK_STATEFLOW
% Registration of Stateflow block type in SimAssist

sabt = saBlock('sflib/Chart');

sabt.RoutinePattern = '^(sf|stateflow)';
sabt.RoutineMethod = @routine_stateflow;



ssproto = regprotoblock_subsystem;
sabt.UseProto(ssproto);
% override features
sabt.PropagateUpstreamStringMethod = @subsys_propagate_inport;
sabt.PropagateDownstreamStringMethod = @subsys_propagate_outport;
sabt.StrReplaceMethod = @strrep_stateflow;
sabt.DictRenameMethod = @dictrename_stateflow;

sabt.ArrangePortMethod = {@sf_arrange_inport, @sf_arrange_outport};
sabt.CleanMethod = @(blkhdl, console) stateflow_minus(blkhdl, '-', console); % equivalent to '--'
sabt.PlusMethod = @stateflow_plus;
sabt.MinusMethod = @stateflow_minus;
end



function actrec = subsys_propagate_inport(sshdl, strarr)
% sshdl: block handle
% strarr : cell of strings at inports
actrec = saRecorder;
inportblks=find_system(sshdl,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','BlockType','Inport');
if isstr(strarr)
    strarr = {strarr};
end
for i=1:numel(strarr)
    if isempty(strarr{i})
        continue;
    end
    actrec.StateflowSetParam(inportblks(i),'Name',strarr{i});
end
end


function actrec = subsys_propagate_outport(sshdl, strarr)
actrec = saRecorder;
outportblks=find_system(sshdl,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','BlockType','Outport');
for i=1:numel(strarr) %Try to trace forward a name for each port
    if isempty(strarr{i})
        continue;
    end
    actrec.StateflowSetParam(outportblks(i),'Name',strarr{i});
end
end

function actrec = strrep_stateflow(blkhdl, oldstr, newstr)
actrec = saRecorder;
object = get_param(blkhdl,'object');

sfobjs_name=object.find('-regexp','Name',oldstr);
sfobjs_lbstr=object.find('-regexp','LabelString',oldstr);
for k=1:numel(sfobjs_name) % Name
    strforrep = regexprep(sfobjs_name(k).Name,oldstr,newstr);
    actrec.StateflowSetParam(sfobjs_name(k), 'Name', strforrep);
end
for k=1:numel(sfobjs_lbstr) % LabelString
    strforrep = regexprep(sfobjs_lbstr(k).LabelString,oldstr,newstr);
    actrec.StateflowSetParam(sfobjs_lbstr(k),'LabelString',strforrep);
end
end


function actrec = dictrename_stateflow(blkhdl, dict)
actrec = saRecorder;
object = get_param(blkhdl,'object');
sfobjs_name=object.find('-regexp','Name','.+');
sfobjs_lbstr=object.find('-regexp','LabelString','.+');

for k=1:numel(sfobjs_name) % Name
    newvalstr=saDictRenameString(sfobjs_name(k).Name,dict);
    actrec.StateflowSetParam(sfobjs_name(k), 'Name', newvalstr);
end
for k=1:numel(sfobjs_lbstr) % LabelString
    newvalstr=saDictRenameString(sfobjs_lbstr(k).LabelString,dict);
    actrec.StateflowSetParam(sfobjs_lbstr(k), 'LabelString', newvalstr);
end
end

function actrec = sf_arrange_inport(blkhdl)
actrec = saRecorder;
sfobj = get_param(blkhdl, 'object');
chartobj = sfobj.find('-isa', 'Stateflow.Chart');
lns = get_param(blkhdl,'LineHandles');
indataobjs = chartobj.find('-isa','Stateflow.Data','Scope','Input');
srcinfo = [];
for i=1:numel(indataobjs)
    idx = indataobjs(i).Port;
    if lns.Inport(idx)>0
        tmplnpos = get_param(lns.Inport(idx), 'Points');
        srcinfo = [srcinfo; struct('Y', tmplnpos(1,2), 'sfObject', indataobjs(i))];
    end
end
if ~isempty(srcinfo)
    [tmp, yidx] = sort([srcinfo.Y]); % in Y order
    for i=1:numel(yidx)
        actrec.StateflowSetParam(srcinfo(yidx(i)).sfObject, 'Port', i);
    end
end
end

function actrec = sf_arrange_outport(blkhdl)
actrec = saRecorder;
sfobj = get_param(blkhdl, 'object');
chartobj = sfobj.find('-isa', 'Stateflow.Chart');
lns = get_param(blkhdl,'LineHandles');
outdataobjs = chartobj.find('-isa','Stateflow.Data','Scope','Output');
nodata = numel(outdataobjs);
outeventobjs = chartobj.find('-isa','Stateflow.Event','Scope','Output');
% arrange output data objects
dstinfo = [];
for i=1:nodata
    idx = outdataobjs(i).Port;
    if lns.Outport(idx)>0
        tmplnpos = get_param(lns.Outport(idx), 'Points');
        dstinfo = [dstinfo; struct('Y', tmplnpos(end,2), 'sfObject', outdataobjs(i))];
    end
end
if ~isempty(dstinfo)
    [tmp, yidx] = sort([dstinfo.Y]); % in Y order
    for i=1:numel(yidx)
        actrec.StateflowSetParam(dstinfo(yidx(i)).sfObject, 'Port', i);
    end
end
% arrange output event objects
dstinfo = [];
for i=1:numel(outeventobjs)
    idx = outeventobjs(i).Port;
    if lns.Outport(idx)>0
        tmplnpos = get_param(lns.Outport(idx), 'Points');
        dstinfo = [dstinfo; struct('Y', tmplnpos(end,2), 'sfObject', outeventobjs(i))];
    end
end
if ~isempty(dstinfo)
    [tmp, yidx] = sort([dstinfo.Y]); % in Y order
    for i=1:numel(yidx)
        actrec.StateflowSetParam(dstinfo(yidx(i)).sfObject, 'Port', nodata+i);
    end
end
end


function actrec = stateflow_plus(blkhdl, optstr, console)
actrec = saRecorder;  
actrec.Dummy;% use this trick to make actrec not empty (otherwise this action may be taken as unsuccessful)
% command parse
[iptnum, optnum, fc, eventnum] = parse_stateflow(optstr);
% execution
% add inport/outport/enable/function call
subsys = getfullname(blkhdl);
sfobj = get_param(blkhdl, 'object');
chartobj = sfobj.find('-isa', 'Stateflow.Chart');
%inport
if ~isempty(iptnum) && iptnum>0
    for i=1:iptnum
        tmpdata = Stateflow.Data(chartobj);
        tmpdata.Scope = 'Input';
        tmpdata.Name = ['In', int2str(i)];
        if isfield(console.SessionPara, 'DataType')
            tmpdata.DataType = console.SessionPara.DataType;
        end
    end
end
%outport
if ~isempty(optnum) && optnum>0
    for i=1:optnum
        tmpdata = Stateflow.Data(chartobj);
        tmpdata.Scope = 'Output';
        tmpdata.Name = ['Out', int2str(i)];
        if isfield(console.SessionPara, 'DataType')
            tmpdata.DataType = console.SessionPara.DataType;
        end
    end
end
%function-call
if fc
    tmpdata = Stateflow.Event(chartobj);
    tmpdata.Scope = 'Input';
    tmpdata.Trigger = 'Function call';
    tmpdata.Name = 'Fcn';
end
% output event trigger
if eventnum>0
    for i=1:eventnum
        tmpdata = Stateflow.Event(chartobj);
        tmpdata.Scope = 'Output';
        tmpdata.Name = ['trig', int2str(i)];
        tmpdata.Trigger = 'Function call';
    end
end
end

function actrec = stateflow_minus(blkhdl, optstr, console)
actrec = saRecorder;  
actrec.Dummy;% use this trick to make actrec not empty (otherwise this action may be taken as unsuccessful)
if nargin<3 || isempty(console)
    side = [true, true];
else
    side = console.SessionPara.ConnectSide;
end
[iptnum, optnum, fc, eventnum] = parse_stateflow(optstr);
subsys = getfullname(blkhdl);
ptcnt = get_param(blkhdl, 'Ports');
sfobj = get_param(blkhdl, 'object');
lns = get_param(blkhdl, 'LineHandles');
chartobj = sfobj.find('-isa', 'Stateflow.Chart');
%inport
tmpobjs = chartobj.find('-isa','Stateflow.Data','Scope','Input');
cntr = 0;
if isequal(optstr, '-')
    iptnum = numel(tmpobjs);
end
if ~isempty(iptnum)&&iptnum>0 && side(1)
    for i=numel(tmpobjs):-1:1
        if lns.Inport(tmpobjs(i).Port)<0
            delete(tmpobjs(i));
            cntr = cntr+1;
        end
        if cntr==iptnum
            break;
        end
    end
end
%outport
tmpobjs = chartobj.find('-isa', 'Stateflow.Data', 'Scope','Output');
cntr = 0;
if isequal(optstr, '-')
    optnum = numel(tmpobjs);
end
if ~isempty(optnum) && optnum>0 && side(2)
    for i=numel(tmpobjs):-1:1
        if lns.Outport(tmpobjs(i).Port)<0
            delete(tmpobjs(i));
            cntr = cntr+1;
        end
        if cntr==optnum
            break;
        end
    end
end
%output trigger
tmpobjs = chartobj.find('-isa', 'Stateflow.Event', 'Scope','Output');
cntr = 0;
if isequal(optstr, '-')
    eventnum = numel(tmpobjs);
end
if ~isempty(eventnum) && eventnum>0 && side(2)
    for i=numel(tmpobjs):-1:1
        if lns.Outport(tmpobjs(i).Port)<0
            delete(tmpobjs(i));
            cntr = cntr+1;
        end
        if cntr==eventnum
            break;
        end
    end
end
%function-call
if fc
    tmpobj = chartobj.find('-isa','Stateflow.Event','Scope','Input');
    delete(tmpobj);
end
end



function [iptnum, optnum, fc, eventnum, reststr] = parse_stateflow(operandstr)
[mstr, iptnum] = regexp(operandstr, 'in?(\d*)', 'match','tokens','once'); % inport
if isempty(mstr)
    iptnum = [];
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
    optnum = [];
else
    if~isempty(optnum{1})
        optnum = str2double(optnum{1});
    else
        optnum = 1;
    end
    operandstr=regexprep(operandstr, 'o(?:ut)?(\d*)', '','once');
end
[mstr, eventnum] = regexp(operandstr, 'e(?:vent)?(\d*)', 'match','tokens','once'); % outport
if isempty(mstr)
    eventnum = [];
else
    if~isempty(eventnum{1})
        eventnum = str2double(eventnum{1});
    else
        eventnum = 1;
    end
    operandstr=regexprep(operandstr, 'e(?:vent)?(\d*)', '','once');
end
if ~isempty(strfind(operandstr, 'fc')) %function call
    fc = true;
    operandstr=regexprep(operandstr,'fc','','once');
else
    fc = false;
end
reststr = strtrim(operandstr);
end


function [actrec, success] = routine_stateflow(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('Stateflow');
srchdls = saFindSystem(gcs,'line_sender');
dsthdls = saFindSystem(gcs,'inport_unconnected');
%parse input command
optstr = regexprep(cmdstr, '^(sf|stateflow)\s*', '', 'once');
[iptnum, optnum, fc, eventnum, sfname] = parse_stateflow(optstr);
if isempty(iptnum)
    iptnum = numel(srchdls);
end
if isempty(optnum)
    optnum = numel(dsthdls);
end
if ~isempty(sfname)
    chartname = sfname;
else
    chartname = 'Chart';
end
% add stateflow block
saLoadLib('sflib');
%
[actrec, block] = btobj.AddBlock(chartname);
sfssobj = get_param(block,'Object');
objchart = sfssobj.find('-isa', 'Stateflow.Chart');
% add inport
for i=1:iptnum
    tmpdata = Stateflow.Data(objchart);
    tmpdata.Scope = 'Input';
    tmpdata.Name = ['In', int2str(i)];
end
% add outport
for i=1:eventnum
    tmpdata = Stateflow.Event(objchart);
    tmpdata.Scope = 'Output';
    tmpdata.Name = ['trig', int2str(i)];
end
% add event output
for i=1:optnum
    tmpdata = Stateflow.Data(objchart);
    tmpdata.Scope = 'Output';
    tmpdata.Name = ['Out', int2str(i)];
end
% add function-call
if fc
    tmpdata = Stateflow.Event(objchart);
    tmpdata.Scope = 'Input';
    tmpdata.Trigger = 'Function call';
    tmpdata.Name = 'Fcn';
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