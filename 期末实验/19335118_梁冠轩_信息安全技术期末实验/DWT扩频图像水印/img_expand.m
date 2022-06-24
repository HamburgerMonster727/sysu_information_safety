function img = img_expand(img, seed)
[row, col] = size(img);
%根据seed，获取随机矩阵
rng(seed);
ramdom_matrix = randi(1000, row, col);
%对图片的每一个像素进行扩频
for i = 1 : row
    for j = 1 : col
        tmp = img(i, j) * 10000
        tmp = num_expand(tmp);
        tmp = bitxor(tmp, ramdom_matrix(i, j));
        img(i, j) = tmp / 10000;
    end
end 
