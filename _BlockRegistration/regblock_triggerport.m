function sabt = regblock_triggerport
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('TriggerPort');

sabt.RoutinePattern = '^(trigger|trig|fc)';
sabt.RoutineMethod = @routine_trigger;

sabt.PropagateUpstreamStringMethod = @trigpropupstream;

sabt.BlockSize = [20, 20];
sabt.BlockPreferOption.ShowName = 'on';

sabt.AnnotationMethod = 'Upon enable: %<StatesWhenEnabling>';

sabt.DefaultParameters = {'TriggerType', 'function-call'};
end

function [actrec, success] = routine_trigger(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('TriggerPort');
cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);

if strcmp(cmdpsr.PatternStr, 'fc')
    if isempty(cmdpsr.OptionStr)
        pvpair = {'TriggerType', 'function-call', 'Name', 'Fcn'};
    else
        pvpair = {'TriggerType', 'function-call', 'Name', cmdpsr.OptionStr};
    end
elseif ~isempty(cmdpsr.OptionStr)
    switch cmdpsr.OptionStr
        case 'fc' %function-call
            pvpair = {'TriggerType', 'function-call', 'Name', 'Fcn'};
        case 'r' %rising
            pvpair = {'TriggerType', 'rising', 'Name', 'TrigRising'};
        case 'f' %falling
            pvpair = {'TriggerType', 'rising', 'Name', 'TrigFalling'};
        case 'e' %either
            pvpair = {'TriggerType', 'either', 'Name', 'TrigEither'};
        otherwise
            pvpair = {'TriggerType', 'function-call', 'Name', cmdpsr.OptionStr};
    end
else
    pvpair = {};
end
actrec + btobj.AddBlock(pvpair{:});
success = true;
end

function actrec = trigpropupstream(blkhdl, ~, console)
actrec = saRecorder;
parsys = get_param(blkhdl, 'Parent');
pts = get_param(parsys,'PortHandles');
thestr = console.GetUpstreamString(pts.Trigger);
actrec.SetParam(blkhdl, 'Name', thestr);
end