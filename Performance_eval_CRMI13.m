function [Re, Sp, FPR, FNR, PWC, Pr, F_measure] = Performance_eval_CRMI13(gt_folder,format, mask, save_dir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% format is a string variable showing the foemat of the input
% it can be either 'video' or 'matlab'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
% reading the sequence file containing the mask frmae indices in the video
fileID = fopen(fullfile(gt_folder,'sequence.txt'), 'r');
sizeInd = [1, inf];
maskInd = fscanf(fileID, '%d', sizeInd);
fclose(fileID);
% reading the mask images 
truthArray = [];
for m = 1:1:length(maskInd)
    imAddress = fullfile(gt_folder,strcat('bin',num2str(maskInd(m),'%.6d'),'.png'));
    imMat = imread(imAddress);
    truthArray = cat(3,truthArray,imMat(:,:,1));
end
%% choosing the output video of the algorithm
if isempty(mask) 
    StrPath = fullfile('C:', 'Users', 'ece', 'Google Drive_NEU', 'AC_Lab', 'Codes');
    if format == 'video'
        [FileName,PathName] = uigetfile('*.avi','Select Video File',StrPath,'MultiSelect','off');
        address = strcat(PathName,FileName);
        vidID = VideoReader(address);
        NoF = vidID.NumberOfFrames;
        height = vidID.Height;
        width = vidID.Width;
        video = zeros(height, width, NoF);
        k=1;
        vidID = VideoReader(address);
        while hasFrame(vidID)
            video(:,:,k) = readFrame(vidID);
            k = k+1;
        end
    elseif format == 'matlab'
        [FileName,PathName] = uigetfile('*.mat','Select Video File',StrPath,'MultiSelect','off');
        address = strcat(PathName,FileName);
        video = load(address);
        video = video.foreground;
        [height, width, NoF] = size(video);
	elseif format =='image'
		
    end
else
    video = 255*uint8(mask);
end
%% computing False positive, False Negative, True Positive, False Negative
FP = 0; %reset the value of false positive 
FN = 0; % reset the value of fulse negative
TP = 0; % reset the value of true positive
TN = 0; % reset the value of true negative
for i = 1:1:length(maskInd)
    im = video(:,:,maskInd(i));
%     imFineName = 
    imwrite(im,fullfile(save_dir, strcat(num2str(maskInd(i), '%.6d'), '.png')));
    figure(1);
    subplot(2, 1, 1)
    imshow(video(:, :, maskInd(i)));
    subplot(2,1,2)
    imshow(truthArray(:, : , i));
    title(num2str(maskInd(i)))
    pause(1/18)
    posInd = find(truthArray(:,:,i)==255);
    for j=1:1:length(posInd)
        if im(posInd(j)) ==255
            TP = TP + 1;
        else
            FN = FN + 1;
        end
    end
    negInd = find(truthArray(:,:,i)== 0);
    for j=1:1:length(negInd)
        if im(negInd(j)) ==0
            TN = TN + 1;
        else
            FP = FP + 1;
        end
    end
end
%% calculating the scores
Re = TP /(TP + FN) % recall
Sp = TN / (TN + FP) % specificity
FPR = FP / (FP + TN)   % false positive rate
FNR = FN / (TN + FP)   % false negative rate
PWC = 100 * (FN + FP) / (TP + FN + FP + TN)    % percentage of wrong classifications
Pr = TP / (TP + FP)    % precision
F_measure =  2 * (Pr * Re) / (Pr + Re)


    
