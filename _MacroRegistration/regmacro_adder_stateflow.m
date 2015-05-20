function sam = regmacro_adder_stateflow
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_stateflow');
sam.Pattern = '^(sf|stateflow)';
sam.Callback = @adder_stateflow;

end

function [actrec, success] =adder_stateflow(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('Stateflow');
srchdls = saFindSystem(gcs,'line_sender');
dsthdls = saFindSystem(gcs,'inport_unconnected');
%parse input command
optstr = regexprep(cmdstr, '^(sf|stateflow)\s*', '', 'once');
iptnum = regexp(optstr, 'in?(\d+)', 'tokens','once'); % inport
if ~isempty(iptnum)
    iptnum = str2double(iptnum{1});
    optstr=regexprep(optstr, 'in?(\d+)', '');
else
    if ~isempty(srchdls)
        iptnum = numel(srchdls);
    else
        iptnum = 1;
    end
end
optnum = regexp(optstr, 'o[ut]*(\d+)', 'tokens','once'); % outport
if ~isempty(optnum)
    optnum = str2double(optnum{1});
    optstr=regexprep(optstr, 'o[ut]*(\d+)', '','once');
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

tmp = strtrim(optstr);
if ~isempty(tmp)
    chartname = tmp;
else
    chartname = 'Chart';
end
% add stateflow block
rtsys = gcs;
if ~bdIsLoaded('sflib')
    load_system('sflib');
    open_system(rtsys); % restore current system
end
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