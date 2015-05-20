function AddMacro(obj, sam)
sam.Console = obj;
macros_tmp = [obj.Macros; sam];
[tmp, iprio] = sort([macros_tmp.Priority]);
macros_tmp = macros_tmp(iprio);
obj.Macros = macros_tmp;
end