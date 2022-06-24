function DWT(img, watermark, seed)
%��ȡͼ�񣬶�ͼ�����������
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

%��ȡˮӡ
watermark1 = imread(watermark);
watermark1 = double(watermark1) / 255;
%��ˮӡ������Ƶ����
watermark1 = img_expand(watermark1, seed);
new_watermark = zeros(width, width);
new_watermark(1 : 101, 1 : 101) = watermark1;

%%ˮӡǶ��
%��ͼ�����С���ֽ⣬��ȡ��Ƶϵ��
[C, S] = wavedec2(new_img, 9, 'db6');
CA = appcoef2(C, S, 'db6', 9);
%��ˮӡ����С���ֽ⣬��ȡ��Ƶϵ��
[C1, S1] = wavedec2(new_watermark, 9, 'db6');
CA1 = appcoef2(C1, S1, 'db6', 9);
%��ͼ���ˮӡ�ĵ�Ƶϵ�����е�ֵ�ֽ�
[U, sigma, V] = svd(CA);        
[U1, sigma1, V1] = svd(CA1); 

%��ˮӡǶ�뵽ͼ���У�������С���ֽ�ʵ���ع�
CA_tilda = reshape(U1 * sigma * V1, 1, S(1, 1) * S(1, 2));
C(1, 1 : S(1, 1) * S(1, 2)) = CA_tilda;
watermarkImg = waverec2(C, S, 'db6');
watermarkImg(:, :, 1) = watermarkImg(1 : row, 1 : col);
imwrite(watermarkImg, 'watermarkImg.bmp');

%%��ȡˮӡ
%��Ƕ��ͼ�����С���ֽ⣬��ȡ��Ƶϵ��
[C, S] = wavedec2(watermarkImg, 9, 'db6');
CA = appcoef2(C, S, 'db6', 9);
%�Ե�Ƶϵ����ֵ�ֽ�
[U, sigma, V] = svd(CA);

%��Ƕ��ͼ������ȡˮӡ������ع�
CA_tilda = reshape(U * sigma1 * V, 1, S1(1, 1) * S1(1, 2));
C1(1, 1 : S1(1, 1) * S1(1, 2)) = CA_tilda;
extract_watermark = waverec2(C1, S1, 'db6');
extract_watermark = img_unexpand(abs(extract_watermark), seed);
extract_watermark = extract_watermark(1 : 101, 1 : 101);
imwrite(extract_watermark, 'extract_watermark.bmp');

%��ʾͼ��
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

%������ȡˮӡ������
extract_watermark = imread('extract_watermark.bmp');
extract_watermark = double(extract_watermark);
watermark = double(watermark);
mistake = abs(extract_watermark - watermark);
total = sum(sum(watermark));
mistake_total = sum(sum(mistake));
rates = mistake_total / total;
disp("error rates: " + rates);