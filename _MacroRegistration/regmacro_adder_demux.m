function sam = regmacro_adder_demux
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_demux');
sam.Pattern = '^demux';
sam.Callback = @adder_demux;

end

function [actrec, success] =adder_demux(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('Demux');
optstr = regexprep(cmdstr, '^demux\s*', '','once');
pvpair = {};
if ~isempty(optstr)
    pvpair = [pvpair, 'Outputs', optstr];
    actrec + btobj.AddBlock(pvpair{:});
else
    dsthdls = saFindSystem(gcs,'line_receiver');
    if ~isempty(dsthdls)
        pvpair = {'Outputs', int2str(numel(dsthdls))};
        autoline = true;
    else
        pvpair = {};
        autoline = false;
    end
    [actrec2, blkhdl] = btobj.AddBlock(pvpair{:});
    actrec + actrec2;
    if autoline
        actrec.MultiAutoLine(blkhdl, dsthdls);
    end
end
success = true;
end