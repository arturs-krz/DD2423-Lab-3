function [segmentation, centers] = kmeans_segm(image, K, L, seed)
% image : (H,W,3)
[H,W,~] = size(image);

pixels = reshape(image, W*H, 3);
% disp(size(pixels));

rng(seed); % seed the random generator
%centers = randi([0,255], K, 3); % K random RGB centers
centers = pixels(randperm(W*H,K),:);

for i = 1:L
    distances = pdist2(pixels, centers); % (W*H, K)
    
    [dist, segmentation] = min(distances,[],2); % find smallest distance among columns (centers) in reach row (pixel)
%     disp(size(segmentation));
    
    % update each cluster
    for k = 1:K
        pixel_indices = find(segmentation == k); % indices of pixels belonging to cluster k
        cluster_mean = mean(pixels(pixel_indices,:)); % 1x3 (mean values for each channel)
        centers(k,:) = cluster_mean;
    end
end

segmentation = reshape(segmentation, H, W);
end