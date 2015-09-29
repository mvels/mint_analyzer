function assemble_images
folder = '../extracted/';
% fname = 'C_04_FF_04_05_7310_';
fname = 'C_05_FF_06_05_5490_';
parts = {'edges', 'subtr', 'closed', 'heads', 'bodys', 'boxes'};

height = 360;
width = 640;
maxWidth = 3 * width;
maxHeight = 2 * height;
newIm = zeros(maxHeight, maxWidth, 3);

bRow = 1;
bCol = 1;

for i = 1:size(parts, 2)
    ifname = [folder fname char(parts(i)) '.png'];
    disp(ifname);
    tim = imread(ifname);
    if size(tim, 3) ~= 3
        tim = tim(:, :, [1 1 1]);
    end
    newIm(bRow:bRow + height - 1, bCol:bCol + width - 1, :) = tim;
    bCol = bCol + width;
    if bCol > maxWidth
        bCol = 1;
        bRow = bRow + height;
    end
end

newIm = uint8(newIm);
imshow(newIm);
imwrite(newIm, [folder fname 'assembled.png']);

end

