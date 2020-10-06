% change your function name to your group number
function G014(selpath)

    %load your trained neural network model
    pretrained = load('SingleDetector_vgg19.mat');
    detector = pretrained.detector; 
    
    %get all jpg images in selpath
    imageList = dir( strcat(selpath,"/*.jpg") );
    
    % change your group name
    groupName="G0014";
    
    % output file name
    outfile = strcat(selpath,"/G014",".txt");
    
    fid=fopen(outfile,'w');
    for i = 1:length(imageList)
        filename = fullfile(imageList(i).folder, imageList(i).name );
        I = imread( filename );
        
        % if you only do classfication on Single Database , use classfy
        % function
        [bboxes, scores, labels] = detect(detector, I, 'Threshold',0.5);
        [selectedBboxes,selectedScores,selectedLabels,index] = selectStrongestBboxMulticlass(bboxes,scores,labels, 'OverlapThreshold' , 0.1 );
        
        % print your pridict labels to file.
        fprintf( fid,"%s ",  imageList(i).name );
        for j = 1:length(selectedLabels)
            fprintf( fid,"%s ",selectedLabels(j) );
        end
        fprintf( fid,"\n" );
    end
    fclose(fid);
    
end