function sam = regmacro_adder_busselector
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_busselector');
sam.Pattern = '^(bs|busselector)';
sam.Callback = @adder_busselector;

end

function [actrec, success] =adder_busselector(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('BusSelector');
%parse input command
optstr = regexprep(cmdstr, '^(bs|busselector)\s*', '', 'once');
if isempty(optstr)
    dsthdls = saFindSystem(gcs,'line_receiver');
    if ~isempty(dsthdls)
        pvpair = {'OutputSignals', create_outputsig_string(numel(dsthdls))};
        autoline = true;
    else
        pvpair = {};
        autoline = false;
    end
    [actrec2, blkhdl] = btobj.AddBlock(pvpair{:});
    actrec + actrec2;
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
    ptnum = str2double(optstr);
    if ~isnan(ptnum)
        outsigstr = create_outputsig_string(ptnum);
        actrec + btobj.AddBlock('OutputSignals', outsigstr);
        success = true;
    end
end
end

function outsigstr = create_outputsig_string(ptnum)
outsigstr = 'signal1';
for k=2:ptnum
    outsigstr=[outsigstr, ',signal', int2str(k)];
end
end