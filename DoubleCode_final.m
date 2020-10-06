AllData = read_all_dataset('DoubleList.txt');
%%
shuffledIdx = randperm(height(AllData));
idx = floor(0.95 * height(AllData));
trainingData = AllData(shuffledIdx(1:idx),:); 
testData = AllData(shuffledIdx(idx+1:end),:);
%%
options = trainingOptions('sgdm',...
          'InitialLearnRate',0.0001,...
          'Verbose',true,...
          'MiniBatchSize',5,...
          'MaxEpochs',8,...
          'Shuffle','every-epoch',...
          'VerboseFrequency',30,...
          'CheckpointPath',tempdir,...
          'ExecutionEnvironment','gpu');
%%
detector = trainFasterRCNNObjectDetector(trainingData, 'resnet50' , options);
%%
%以下為測試部分，與訓練無關
fileName = testData.imageFilename{270};
display(fileName);
I = imread(fileName);

% Run the detector.
[bboxes,scores,labels] = detect(detector,I);

% Annotate detections in the image.
I = insertObjectAnnotation(I,'rectangle',bboxes,cellstr(labels));
imshow(I)