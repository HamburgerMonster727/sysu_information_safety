function DWT(img, watermark, seed)
%读取图像，对图像进行正方化
img1 = imread(img);
img1 = double(img1) / 255;
img1 = img1(:, :, 1);
[row, col] = size(img1);
width = max(row, col);
new_img = zeros(width, width);
if row <= col
   new_img(1 : row, :) = img1;
else
   new_img(:, 1 : col) = img1;
end   

%读取水印
watermark1 = imread(watermark);
watermark1 = double(watermark1) / 255;
%对水印进行扩频处理
watermark1 = img_expand(watermark1, seed);
new_watermark = zeros(width, width);
new_watermark(1 : 101, 1 : 101) = watermark1;

%%水印嵌入
%对图像进行小波分解，提取低频系数
[C, S] = wavedec2(new_img, 9, 'db6');
CA = appcoef2(C, S, 'db6', 9);
%对水印进行小波分解，提取低频系数
[C1, S1] = wavedec2(new_watermark, 9, 'db6');
CA1 = appcoef2(C1, S1, 'db6', 9);
%对图像和水印的低频系数进行单值分解
[U, sigma, V] = svd(CA);        
[U1, sigma1, V1] = svd(CA1); 

%将水印嵌入到图像中，利用逆小波分解实现重构
CA_tilda = reshape(U1 * sigma * V1, 1, S(1, 1) * S(1, 2));
C(1, 1 : S(1, 1) * S(1, 2)) = CA_tilda;
watermarkImg = waverec2(C, S, 'db6');
watermarkImg(:, :, 1) = watermarkImg(1 : row, 1 : col);
imwrite(watermarkImg, 'watermarkImg.bmp');

%%提取水印
%对嵌入图像进行小波分解，提取低频系数
[C, S] = wavedec2(watermarkImg, 9, 'db6');
CA = appcoef2(C, S, 'db6', 9);
%对低频系数单值分解
[U, sigma, V] = svd(CA);

%从嵌入图像中提取水印，完成重构
CA_tilda = reshape(U * sigma1 * V, 1, S1(1, 1) * S1(1, 2));
C1(1, 1 : S1(1, 1) * S1(1, 2)) = CA_tilda;
extract_watermark = waverec2(C1, S1, 'db6');
extract_watermark = img_unexpand(abs(extract_watermark), seed);
extract_watermark = extract_watermark(1 : 101, 1 : 101);
imwrite(extract_watermark, 'extract_watermark.bmp');

%显示图像
figure;
img = imread(img)
subplot(2,2,1),subimage(img);
title('img');
watermark = imread(watermark)
subplot(2,2,2),subimage(watermark);
title('watermark');
subplot(2,2,3),subimage(watermarkImg);
title('watermarkImg');
subplot(2,2,4),subimage(extract_watermark);
title('extract_watermark');

%计算提取水印错误率
extract_watermark = imread('extract_watermark.bmp');
extract_watermark = double(extract_watermark);
watermark = double(watermark);
mistake = abs(extract_watermark - watermark);
total = sum(sum(watermark));
mistake_total = sum(sum(mistake));
rates = mistake_total / total;
disp("error rates: " + rates);