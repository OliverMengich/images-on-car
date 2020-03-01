

[q,inf] = readimage(carTest,7857);
qgray = rgb2gray(q);
[h,v] = extractHOGFeatures(qgray,'CellSize',[4 4]); imshow(q); hold on; plot(v)

%%

net = load('yolov2VehicleDetector.mat');

lgraph = net.lgraph;
options = trainingOptions('sgdm',...
          'InitialLearnRate',0.0005,...
          'Verbose',true,...
          'MiniBatchSize',16,...
          'MaxEpochs',50,...
          'Shuffle','every-epoch',...
          'VerboseFrequency',30,...
          'CheckpointPath',tempdir);
 %%     
[detector,info] = trainYOLOv2ObjectDetector(trainingData,lgraph,options);
%%
[queryimage,information] = readimage(carimds,7590); imshow(queryimage)

[bboxes,scores] = detect(detector,queryimage);
imshow(insertObjectAnnotation(queryimage,'rectangle',bboxes,scores))
%%


videoreader = vision.VideoFileReader('cad1.mp4');
videoplayer = vision.DeployableVideoPlayer();
while ~isDone(videoreader)
    frame = step(videoreader);
    [bbox,scores] = detect(detector,frame);
    if ~isempty(bbox)
       J = insertObjectAnnotation(frame,'rectangle',bbox,scores); 
       step(videoplayer,J)
    else
        step(videoplayer,frame)
    end
end

