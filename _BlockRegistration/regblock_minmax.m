function sabt = regblock_minmax
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('MinMax');
sabt.RoutinePattern = '^mn|mx|min|max';
sabt.RoutineMethod = @routine_minmax;
sabt.RoutinePara.InportProperty = 'Inputs';

sabt.MajorProperty = 'Function';
sabt.ArrangePortMethod{1} = 1;
sabt.RollPropertyMethod = -1;

btlogic = regblock_logic;
sabt.Inherit(btlogic,...
    'BlockSize', 'AutoSizeMethod', 'LayoutSize', 'PlusMethod', 'MinusMethod','CleanMethod');

end


function [actrec, success] = routine_minmax(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('MinMax');
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);

switch cmdpsr.PatternStr
    case {'mn','min'}
        opsym = 'Min';
    case {'mx','max'}
        opsym = 'Max';
end

pvpair = {'Function', opsym};
actrec = Routines.dynamicinport(btobj, cmdpsr.OptionStr, '', ...
    'Function', opsym);
success = true;
end