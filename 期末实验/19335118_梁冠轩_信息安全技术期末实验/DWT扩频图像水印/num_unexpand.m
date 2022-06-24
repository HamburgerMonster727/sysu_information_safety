function result = num_unexpand(num)
bin_num = dec2bin(num);
%将两位提取为一位
for i = 1 : floor(length(bin_num) / 2)
    if bin_num(2 * i - 1) == '1' && bin_num(2 * i) == '1'
        str(i) = '1';
    elseif bin_num(2 * i - 1) == '1' && bin_num(2 * i) == '0'
        str(i) = '1';
    elseif bin_num(2 * i - 1) == '0' && bin_num(2 * i) == '1'
        str(i) = '0';
    elseif bin_num(2 * i - 1) == '0' && bin_num(2 * i) == '0'
        str(i) = '0';
    end
end
result = bin2dec(str);
