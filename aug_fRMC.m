function aug_fRMC(input_matrix, max_iter, gamma1, gamma2) 
%% adding the address of the required toolboxes to the MATLAB directory and save them
addpath(genpath('tools'));
savepath
% creating the weak foreground model using fRMC method (see
% InfaceExtFrankWolfe.m
[background,~]= InfaceExtFrankWolfe(input_matrix, gamma1, gamma2, max_iter;




%% visualization
if(0) 
    for i=1:1:size(foreground, 3)
        imshow(foreground(:, :, i),[])
        pause(0.1)
    end
end
     
% load forest tree model trained on BSD dataset
model= load('models/forest/modelBsds.mat');
model = model.model;

% set edge detection parameters (can set after training)
model.opts.multiscale=1;          % for top accuracy set multiscale=1
model.opts.sharpen=2;             % for top speed set sharpen=0
model.opts.nTreesEval=4;          % for top speed set nTreesEval=1
model.opts.nThreads=6;            % max number threads for evaluation
model.opts.nms=1;                 % set to true to enable nms
%% set up opts for edgeBoxes
opts = edgeBoxes;
opts.alpha = .65;     % step size of sliding window search
opts.beta  = .9;     % nms threshold for object proposals
opts.minScore = .005;  % min score of boxes to detect
opts.maxBoxes = 10;  % max number of boxes to detect
opts.minBoxArea = 1500;  % minimum area of boxes to detect
opts.maxAspectRatio = 2.5;  % maximum aspect ratio of boxes to detect
%% detect Edge Box on the original images
% bbs = cell(NoF,1);
% cd ..
% parfor j=1:1:NoF
%     imName = fullfile(rawPicPath, strcat('gr',num2str(j, '%.6d'), '.png'));
%     I = imread(imName);
%     I = repmat(I, 1, 1, 3);
%     bbs{j}=edgeBoxes(I,model,opts);
% end 
%  %% detect Edge Box bounding box proposals (see edgeBoxes.m)
% % set the range in [0, 255]
% bbs = cell(size(foreground,3),1);
% tic
% parfor j=1:1:size(foreground, 3)
%     Minn = min(min(foreground(:, :, j)));
%     Maxx = max(max(foreground(:, :, j)));
%     Range = Maxx - Minn;
%     foreground(:, :, j) = (foreground(:, :, j)-Minn)*255/Range;
%     I = uint8(foreground(:, :, j));
%     I = repmat(I, 1, 1, 3);
%     bbs{j}=edgeBoxes(I,model,opts);
% end 
% toc
%% extracting the mask by thresholding inside the top score bbox
mask = zeros(size(foreground));
% top_bbs = cell2array(bbs);
% top_bbs = top_bbs(1, 1:4, :);
% top_bbs = reshape(top_bbs, [], NoF);
binMask = false(size(mask));
saveAdd = 'S:\Users\rezaei\My Papers\J-STSP2018\Result\CRIM13\030609_A25_Block11_BCfe1\Top\RMC';
for i=1:NoF
%     temp = top_bbs(1:4,i);
    x = temp(1); y = temp(2); w = temp(3); h = temp(4);
%     mask(max(1,y-15):min(height,y+h+15), max(1,x-15):min(width,x+w+15),i) = ...
%     foreground(max(1,y-15):min(height,y+h+15), max(1,x-15):min(width,x+w+15),i);
    mask(:, :, i) = foreground(:, :, i);
    Th = 0.18 * max(max(mask(:, : ,i)));
    binMask(:, :, i)= mask(:, :, i) > Th;
    binMask(:, :, i) = imopen(binMask(:, :, i), strel('disk', 2));
    binMask(:, :, i) = imclose(binMask(:, :, i), strel('disk', 6));
    binMask(:, :, i) = imfill(binMask(:, :, i), 'holes');
%     imwrite(binMask(:, :, i),fullfile(saveAdd, strcat('bin',num2str(i, '%.6d'), '.png')) )
end
if(0)
    for i = 524:NoF
        figure(1)
        imshow(mask(:, :, i),[]);
        figure(2);
        imshow(binMask(:, :, i),[]);
        disp(i)
        pause
    end
end
%% showing the top five bounding boxes
if(0)
    resAdd = 'S:\Users\rezaei\My Papers\J-STSP2018\Result\CRIM13\030609_A25_Block11_BCfe1\Side\EdgeBoxes';
    for j=1:1:NoF
        imName = fullfile(rawPicPath, strcat('gr',num2str(j, '%.6d'), '.png'));
        im = double(imread(imName));
        I = uint8(foreground(:, :, j));
        fr1 = getframe(figure(1)); 
%         subplot(1,2,1) 
        imshow(I, []); hold on;
%         title(strcat('Foregroung of frame number',' ',num2str(j,'%d')));
        pose = bbs{j};
        if ~isempty(pose)
          rectangle('position',pose(1,1:4), 'EdgeColor', [1/2, 0, 1/2], 'LineWidth', 2);
          text(double(pose(1,1)+20), double(pose(1,2)-10),strcat('\color[rgb]{0.5,0,0.5} ',num2str(pose(1,5))));
%           rectangle('position',pose(2,1:4), 'EdgeColor',[1, 1, 1] , 'LineWidth', 1.5);
%           text(double(pose(2,1)+60), double(pose(2,2)-10),strcat('\color[rgb]{1,1,1} ',num2str(pose(2,5))));
        %       rectangle('position',pose(3,1:4), 'EdgeColor', [1/3, 1/3, 0], 'LineWidth', 1);
        %       text(double(pose(3,1)+100), double(pose(3,2)-10),strcat('\color[rgb]{0.33,0.33,0} ',num2str(pose(3,5))));
        %   rectangle('position',pose(4,1:4), 'EdgeColor', [0, 1/4, 1/4], 'LineWidth', 0.5);
        %   rectangle('position',pose(5,1:4), 'EdgeColor', [1/2, 1/3, 1/4], 'LineWidth', 0.5);
        end
        hold off
%         imwrite(fr1.cdata,fullfile(resAdd, strcat('gr',num2str(j, '%.6d'), '.png')));
        fr2 = getframe(figure(2));
%         subplot(1,2,2), 
        imshow(im, []); hold on
%         title({'Original Video with Bounding Box', strcat('frame number',' ',num2str(2*j,'%d'))});
        if ~isempty(pose)
          rectangle('position',pose(1,1:4), 'EdgeColor', [1/2, 0, 1/2], 'LineWidth', 2);
          text(double(pose(1,1)+20), double(pose(1,2)-10),strcat('\color[rgb]{0.5,0,0.5} ',num2str(pose(1,5))));
        end
        hold off 
        imwrite(fr2.cdata, fullfile(resAdd, strcat('or',num2str(j, '%.6d'), '.png')));
%         pause
    end
end
%% performance evaluation
cd ..
format ='matlab';
[Re, Sp, FPR, FNR, PWC, Pr, F_measure] = Performance_eval_CRMI13(gtPath, format, binMask, savePath);
end