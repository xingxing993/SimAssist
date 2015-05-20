function sabt = regblock_product
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Product');

parsabt = regblock_sum;
sabt.Inherit(parsabt);

end


