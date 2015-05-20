function block = ReplaceBlock(obj,varargin)
sa = saAction('replace_block',varargin{1:2});
obj.PushItem(sa);
block = sa.Handle;
end