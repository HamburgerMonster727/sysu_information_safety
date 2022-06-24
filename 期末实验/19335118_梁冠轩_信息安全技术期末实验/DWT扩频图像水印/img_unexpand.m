function img = img_unexpand(img, seed)
[row, col] = size(img);
%根据seed，获取随机矩阵
rng(seed);
ramdom_matrix = randi(1000, row, col);
%对图片的每一个像素进行逆扩频
for i = 1 : row 
    for j = 1 : col
        tmp = img(i, j) * 10000;
        tmp = bitxor(int32(tmp), ramdom_matrix(i, j));
        tmp = num_unexpand(tmp);
        img(i, j) = tmp / 10000;
    end
end
