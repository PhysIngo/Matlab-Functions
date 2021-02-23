function out = ZoomImage(img, factor, varargin)
% ZoomImage by Ingo Hermann, 2020-02-16
% This functions zooms into the image
% --------------------------------
% This scripts needs the user functions:
% - none -
%
% Exp.: out = ZoomImage(img, factor, varargin)
%
% 'img' ... input image to be zoomed
% 'factor ... multiplication factor to be zoomed
%
% -- optional arguments -- 
% ZoomImage(..., varargin)
% 'rect' ... makes the zoomed image rectangular with the smaller of both
% dimensions
%
    
sz = size(img);
mid = round((sz+1)/2);
dim = round(sz./factor);

[logic, ~] = max(strcmp(varargin,'rect'));
if logic
    dim(1) = min(dim(1:2));
    dim(2) = min(dim(1:2));
end

oldImg = img;
if length(sz)>2
%     newOut = zeros(dim(1)-1,dim(2)-1,sz(3));
    looper = sz(3);
    if looper == 1
        img = squeeze(img);
    end
else
    looper = 1;
end
for j=1:1:looper
    if length(sz)>2
        img = oldImg(:,:,j);
    end
    out = zeros(dim(1)-1,dim(2)-1);
    sz_out = size(out);

    l_out = round((sz_out-1)/2);
    rng_1 = [-l_out(1):l_out(1)-1];
    rng_2 = [-l_out(2):l_out(2)-1];

    if factor >= 1
        out = img(rng_1+mid(1),rng_2+mid(2));
    else
        rng_out_1 = [-dim(1):dim(1)-1];
        rng_out_2 = [-dim(2):dim(2)-1];
        mid_out = round((sz_out+1)/2);
        out(mid_out(1)+rng_out_1,mid_out(2)+rng_out_2) = img;
    end
    
    
    if length(sz)>2
        newOut(:,:,j) = out;
    end
end

if length(sz)>2
	out = newOut;
end    

end