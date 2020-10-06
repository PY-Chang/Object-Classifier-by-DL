AllData = read_all_dataset('SingleList.txt');
%%
shuffledIdx = randperm(height(AllData));
idx = floor(0.8 * height(AllData));
trainingData = AllData(shuffledIdx(1:idx),:); 
testData = AllData(shuffledIdx(idx+1:end),:);
%%
options = trainingOptions('sgdm',...
          'InitialLearnRate',0.0001,...
          'MiniBatchSize',5,...
          'MaxEpochs',5,...
          'CheckpointPath',tempdir,...
          'ExecutionEnvironment','gpu');
      
%%
detector = trainFasterRCNNObjectDetector(trainingData, 'vgg19', options);
%%
%以下為測試部分，與訓練無關
fileName = testData.imageFilename{99};
display(fileName);
I = imread(fileName);

% Run the detector.
[bboxes,scores,labels] = detect(detector,I);

% Annotate detections in the image.
I = insertObjectAnnotation(I,'rectangle',bboxes,cellstr(labels));
imshow(I)