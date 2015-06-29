function sabt = regblock_busselector
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('BusSelector');

sabt.RoutineMethod = @routine_buscreator;
sabt.RoutinePattern = '^(bs|busselector)';

sabt.OutportStringMethod = @getportstring_busselector; % pass through the 3rd inport
sabt.PropagateDownstreamStringMethod = @propagate_downstream_busselector;
sabt.PropagateUpstreamStringMethod = @(blkhdl)operator_plus(blkhdl, '+'); % equivalent to '++'

sabt.BlockSize = [5, 70];

sabt.LayoutSize.PortSpacing = 30;

sabt.PlusMethod = @operator_plus;
sabt.MinusMethod = @operator_minus;

sabt.ArrangePortMethod{2} = @arrange_outport;
sabt.CleanMethod = @clean;
sabt.AutoSizeMethod = -1;

end

function actrec = arrange_outport(blkhdl)
actrec = saRecorder;
rtsys = get_param(blkhdl,'Parent');
pthdls=get_param(blkhdl,'PortHandles');
lnhdls=get_param(blkhdl,'LineHandles');lnhdls = lnhdls.Outport;
reroutelines = [];
outsigs=regexp(get_param(blkhdl,'OutputSignals'),',','split');
for l=1:numel(lnhdls)
    if lnhdls(l)<0
        tmpline.LineInfo = [];
        tmpline.EndPoint = [0, inf];
        tmpline.Signal = outsigs{l};
        tmpline.Name = '';
    else
        lnpoint = get_param(lnhdls(l),'Points');
        tmpline.LineInfo = backup_lineinfo(lnhdls(l));
        tmpline.EndPoint = lnpoint(end,:);
        tmpline.Signal = outsigs{l};
        tmpline.Name = get_param(lnhdls(l), 'Name');
        actrec.DeleteLine(lnhdls(l));
    end
    reroutelines = [reroutelines; tmpline];
end
% sort by start point position
ydst = [reroutelines.EndPoint]; ydst = ydst(2:2:end);
[tmp, iorder] = sort(ydst);
reroutelines = reroutelines(iorder);
% reorder output signals
outsigstr = sprintf('%s,',reroutelines.Signal); outsigstr(end)='';
actrec.SetParam(blkhdl, 'OutputSignals', outsigstr);
% redraw lines
for l=1:numel(reroutelines)
    if ~isempty(reroutelines(l).LineInfo)
        actrec.AddLine(rtsys, pthdls.Outport(l), reroutelines(l).EndPoint, reroutelines(l).Name);
        actrec + redraw_lines(rtsys, reroutelines(l).LineInfo.LineChildren);
    end
end
end

function lninfo = backup_lineinfo(ln)
lninfo.Points = get_param(ln, 'Points');
lnchilds = get_param(ln, 'LineChildren');
if isempty(lnchilds)
    lninfo.LineChildren = [];
else
    for i=1:numel(lnchilds)
        lninfo.LineChildren(i) = backup_lineinfo(lnchilds(i));
    end
end
end

function actrec = redraw_lines(parsys, lninfo)
actrec = saRecorder;
for k=1:numel(lninfo)
    actrec.AddLine(parsys, lninfo(k).Points);
    if ~isempty(lninfo(k).LineChildren)
        actrec + redraw_lines(parsys, lninfo(k).LineChildren);
    end
end
end


function actrec = clean(blkhdl)
actrec = saRecorder;
outsigs=regexprep(get_param(gcbh,'OutputSignalNames'),'^<|>$','');
lns = get_param(blkhdl, 'LineHandles');
outsigs(lns.Outport<0) = [];
outsigstr = sprintf('%s,',outsigs{:}); outsigstr(end)='';
actrec.SetParam(blkhdl, 'OutputSignals', outsigstr);
end


function actrec = operator_plus(blkhdl, operand)
actrec = saRecorder;
if isequal(operand, '+') % '++' means select all
    rtbussig = get_param(blkhdl,'InputSignals');
    if isempty(rtbussig)
        return;
    end
    outsigstr_c = busselector_gen_names(rtbussig);
    outsigstr = sprintf('%s,',outsigstr_c{:}); outsigstr(end)='';
    actrec.SetParam(blkhdl, 'OutputSignals', outsigstr);
else
    if isempty(operand) % default add/minus 1
        operand = 1;
    else
        operand = str2double(operand);
    end
    if isnan(operand) || isempty(operand)
        return;
    else
        outsigstr = get_param(blkhdl, 'OutputSignals');
        for k=1:operand
            outsigstr=[outsigstr, ',signal', int2str(k)];
        end
        actrec.SetParam(blkhdl, 'OutputSignals', outsigstr);
    end
end
end

function actrec = operator_minus(blkhdl, operand)
actrec = saRecorder;
if isempty(operand) % default add/minus 1
    operand = 1;
else
    operand = str2double(operand);
end
if isnan(operand) || isempty(operand)
    return;
else
    outsigstr = get_param(blkhdl, 'OutputSignals');
    for k=1:operand
        idxlast = find(outsigstr==',',1,'last');
        outsigstr(idxlast:end) = '';
    end
    actrec.SetParam(blkhdl, 'OutputSignals', outsigstr);
end
end


function clist = busselector_gen_names(rtcell)
clist={};
for i=1:numel(rtcell)
    if isstr(rtcell{i})
        clist = [clist;rtcell(i)];
    else
        clist = [clist; strcat(rtcell{i}{1}, '.', busselector_gen_names(rtcell{i}{2}))];
    end
end
end


function thestr = getportstring_busselector(pthdl)
ptnum = get_param(pthdl, 'PortNumber');
parblk = get_param(pthdl, 'Parent');
pttyp = get_param(pthdl, 'PortType');
outsigs=regexp(get_param(parblk,'OutputSignals'),',','split');
tmp = regexp(outsigs{ptnum},'\.','split');
thestr = tmp{end};
end

function actrec = propagate_downstream_busselector(blkhdl, sigoutstrs)
actrec = saRecorder;
oldnamestr=get_param(blkhdl,'OutputSignals');
newnames=regexp(oldnamestr,',','split');
sigoutstrs=cellstr(sigoutstrs);
for kk=1:numel(sigoutstrs)
    if numel(newnames)<kk
        tmpname = 'tmp';
    else
        tmpname=newnames{kk};
    end
    nameparts=regexp(tmpname,'\.','split'); %split
    if ~isempty(sigoutstrs{kk})
        nameparts{end}=sigoutstrs{kk};
    else
        nameparts{end}=['signal', int2str(kk)];
    end
    tmpname=sprintf('%s.',nameparts{:});tmpname(end)=''; %recreate string
    newnames{kk}=tmpname;
end
newnamestr=sprintf('%s,',newnames{:});newnamestr(end)='';
actrec.SetParam(blkhdl, 'OutputSignals', newnamestr);
end

function [actrec, success] = routine_busselector(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('BusSelector');
%parse input command
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
[numopt, bclean] = cmdpsr.ParseInteger;
%
if ~bclean
    [actrec, success] = deal(saRecorder, false);return;
end
if isempty(numopt)
    dsthdls = saFindSystem(gcs,'line_receiver');
    if ~isempty(dsthdls)
        pvpair = {'OutputSignals', create_outputsig_string(numel(dsthdls))};
        autoline = true;
    else
        pvpair = {};
        autoline = false;
    end
    [actrec2, blkhdl] = btobj.AddBlock(pvpair{:}); actrec + actrec2;
    if autoline
        actrec.MultiAutoLine(blkhdl, dsthdls);
        actrec + btobj.PropagateDownstreamString(blkhdl);
    end
    srchdl = saFindSystem(gcs,'line_sender');
    if numel(srchdl)==1
        actrec.AutoLine(srchdl, blkhdl);
    end
    success = true;
else
    outsigstr = create_outputsig_string(numopt);
    actrec + btobj.AddBlock('OutputSignals', outsigstr);
    success = true;
end
end

function outsigstr = create_outputsig_string(ptnum)
outsigstr = 'signal1';
for k=2:ptnum
    outsigstr=[outsigstr, ',signal', int2str(k)];
end
end