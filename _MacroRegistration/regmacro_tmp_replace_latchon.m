function sam = regmacro_tmp_replace_latchon
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('srrep');
sam.Pattern = '^srrep';
sam.Callback = @replace_latchon;

end

function [actrec, success] =replace_latchon(cmdstr, console)
actrec=saRecorder;success = false;
load_system('legionlib');
actrec.ReplaceBlock(gcbh, sprintf('legionlib/Signals/S-R\nFlip-Flop'));
success = true;
end