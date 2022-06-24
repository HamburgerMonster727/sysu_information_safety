function result = num_expand(num)
bin_num = dec2bin(num);
%将一位扩展为两位
for i = 1 : length(bin_num)
    if bin_num(i) == '1'
        str((i - 1) * 2 + 1) = '1';
        str((i - 1) * 2 + 2) = '1';
    else
        str((i - 1) * 2 + 1) = '0';
        str((i - 1) * 2 + 2) = '0';  
    end
end
result = bin2dec(str);
