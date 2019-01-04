function plot_stim_matrix(pictures, dim, bg)
%PLOT_STIM_MATRIX   Plot a set of stimulus pictures in a grid.
%
%  Given a set of pictures, plots them in a grid. Useful for creating
%  a summary display of all stimuli in an experiment. Can also be used
%  as labels for an RDM. Images will be padded so that they all
%  have the same dimensions.
%
%  plot_stim_matrix(pictures, dim, bg)
%
%  INPUTS:
%  pictures - [1 x items] cell array of pictures
%      Each cell must contain a [width x height] or [width x height x 3]
%      matrix indicating grayscale or RGB values to display. For
%      example, images imported using imread are in this format.
%
%  dim - [1 x 2] numeric array
%      Dimensions of the grid to plot, in [rows x columns].
%
%  bg - numeric scalar between 0 and 255 (255)
%      Background color to use for images that need to be padded
%      (default is white).

if nargin < 3
    bg = 255;
end

% determine padding
nr = max(cellfun(@(x) size(x, 1), pictures));
nc = max(cellfun(@(x) size(x, 2), pictures));

mat = [];
n = 0;
for i = 1:dim(1)
    row = [];
    for j = 1:dim(2)
        n = n + 1;
        pic = pictures{n};
        [s1, s2, s3] = size(pic);
        
        % if grayscale, make RGB
        if s3 == 1
            pic = repmat(pic, [1 1 3]);
        end
        
        % pad top and bottom of image
        if s1 < nr
            ntop = floor((nr - s1)/2);
            nbottom = ceil((nr - s1)/2);
            pic = [repmat(bg, [ntop s2 3])
                   pic
                   repmat(bg, [nbottom s2 3])];
        end
        
        % pad sides of image
        if s2 < nc
            nleft = floor((nc - s2)/2);
            nright = ceil((nc - s2)/2);
            pic = [repmat(bg, [nr nleft 3]) ...
                   pic ...
                   repmat(bg, [nr nright 3])];
        end
        
        row = [row pic];
    end
    mat = [mat; row];
end

% display whole grid
imshow(mat);

% make the axis take up the whole figure window
a = gca;
a.Position = [0 0 1 1];

f = gcf;
s = size(mat);
f.PaperPosition = [0 0 4 4*(s(1)/s(2))];
