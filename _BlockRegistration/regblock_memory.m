function sabt = regblock_memory
%This function is automatically generated to represent the saBlock object that describes the behaviour of the block type
sabt = saBlock('Memory');
sabt.RoutinePattern = '^memory|mem';
sabt.RoutinePriority = 20;
sabt.RoutineMethod = 'majorprop_value';
sabt.BlockPreferOption.ShowName = 'off';
sabt.BlockPreferOption.Selected = 'off';


% CUSTOMIZE FUNCTIONS, SEE PROGRAMING REFERENCE DOCUMENT FOR DETAIL
%sabt.PropagateUpstreamStringMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.PropagateDownstreamStringMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.OutportStringMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.InportStringMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.SetPropertyMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.RollPropertyMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.AnnotationMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.RefineMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.DictRenameMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.StrReplaceMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.AutoSizeMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.AlignMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.ColorMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.CleanMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.DataTypeMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.ArrangePortMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.PlusMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
%sabt.MinusMethod = @SUBFUNCTION/INTEGER/STRING/CELL...;
end



%function actrec = SUBFUNCTION1(blkhdl, varargin)
% % blkhdl: Handle of block to be dealt with
% % actrec: saRecorder object that records the actions for undo and redo, optional
%end

%function actrec = SUBFUNCTION2(blkhdl, varargin)
% % blkhdl: Handle of block to be dealt with
% % actrec: saRecorder object that records the actions for undo and redo, optional
%end

