function peopleDetector
peopleDetector = vision.PeopleDetector;
I = imread('~/Desktop/people.png');
[bboxes, scores] = step(peopleDetector, I);
disp(bboxes);
shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[255 255 0]);
scoreInserter = vision.TextInserter('Text',' %f','Color', [0 80 255],'LocationSource','Input port','FontSize',16);
 I = step(shapeInserter, I, int32(bboxes));
 I = step(scoreInserter, I, scores, int32(bboxes(:,1:2))); 

figure, imshow(I)
title('Detected people and detection scores'); 
end