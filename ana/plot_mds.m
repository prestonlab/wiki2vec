function h = plot_mds(rdm, labels, varargin)
%PLOT_MDS   Make a multidimensional scaling plot with labels or pictures.
%
%  h = plot_mds(rdm, labels, ...)
%
%  INPUTS:
%  rdm - [items x items] numeric array
%      Matrix of dissimilarity values for each pair of items.
%
%  labels - [1 x items] cell array of strings OR pictures
%      Item labels or pictures. Must have the same order as rdm. Each
%      cell may contain a string to indicate text to display, or a
%      [width x height x 3] matrix indicating a picture to display
%      (for example, read in from an image file using imread). White
%      (255 in all RGB channels) will be made transparent when
%      plotting images.
%
%  OUTPUTS:
%  h - [figures x points] array of handles to text/pictures
%      Handles to all plotted points.
%
%  OPTIONS:
%  ind - [1 x items] vector - 1:length(rdm)
%      Indices indicating the items to plot.
%
%  category - [1 x items] vector - ones(1, length(rdm))
%      Number indicates category label. The numbers can be anything,
%      as long as items with the same category have the same
%      label. Color order is: 'r' 'g' 'b' 'c' 'm', with lower category
%      labels first. Default is to plot all labels in black.
%
%  method - char - 'mds'
%      Type of MDS to use. May specify e.g. 'mds6' to indicate that
%      the MDS solution should include 6 dimensions. Default number
%      of dimensions is 2.
%
%  scrub - boolean - true
%      If true, outliers with high dissimilarity will be excluded. A
%      warning will be printed if outliers are excluded.
%
%  scale - float - 0.75
%      Scale factor to apply to pictures in plot. The script will
%      attempt to set a sensible scaling based on the spacing
%      between pictures; this scale factor will increase or
%      decrease the scale relative to that.
%
%  alpha - [1 x items] cell array of image alpha data - {}
%      Matrix of alpha data for each image to be plotted. If not
%      specified, white pixels will be plotted as transparent.
%
%  EXAMPLES:
%  rdm = squareform(rand(1,10)); % random 5x5 RDM
%  mylabels = {'a' 'b' 'c' 'd' 'e'}; % item labels
%  indices = [1 2 4 5]; % items to include in plot
%  plot_mds(rdm, mylabels, 'ind', indices);
%
%  pic = imread('peppers.png'); % read sample image
%  plot_mds(rdm, repmat({pic}, 1, 5), 'scale', 2);

def.ind = 1:length(rdm);
def.category = ones(1, length(rdm));
def.method = 'mds';
def.scrub = true;
def.scale = 0.75;
def.alpha = {};
opt = propval(varargin, def);

% remove items with undefined similarity
include = sum(isnan(rdm(opt.ind,opt.ind))) < (nnz(opt.ind) - 1);

% remove items with perfect similarity to another item
dupe = squareform(squareform(rdm(opt.ind,opt.ind))<1e-10);
[~, exclude] = find(dupe);
if ~isempty(exclude)
    fprintf('Removing %d items with duplicates.\n', length(exclude));
    include(exclude) = false;
end

% remove outliers with high dissimilarity
if opt.scrub
    m = nanmean(rdm(opt.ind,opt.ind), 1);
    outlier = m > (mean(m) + 3 * std(m));
    if any(outlier)
        fprintf('Removing %d outliers with high dissimilarity.\n', ...
                nnz(outlier));
        include = include & ~outlier;
    end
end

ind = opt.ind(include);

% set point coloring
icat = opt.category(ind);
ucat = unique(icat);
if length(ucat) > 1
    colors = {'r' 'g' 'b' 'c' 'm'};
    set(gcf, 'Color', [0 0 0]);
else
    colors = repmat({'k'}, [1 5]);
end

% compute MDS solution
if strcmp(opt.method, 'mds')
    y = mdscale(rdm(ind,ind), 2);
    yc = {y};
elseif length(opt.method) >= 3 && strcmp(opt.method(1:3), 'mds')
    n = str2num(opt.method(4));
    y = mdscale(rdm(ind,ind), n);
    yc = {};
    for i = 1:2:n
        yc = [yc {y(:,i:(i+1))}];
    end
    f = factor(length(yc));
    if length(f) == 1
        nr = 1;
        nc = f;
    else
        nc = prod(f(2:end));
        nr = length(yc) / nc;
    end
else
    y = tsne_p(rdm(ind,ind), [], 2);
    yc = {y};
end
l = labels(ind);

% make MDS plot(s)
for i = 1:length(yc)
    y = yc{i};
    if length(yc) > 1
        figure(i)
    end
    if ~isempty(opt.alpha)
        plot_mds_core(y, l, opt.scale, opt.alpha(ind));
    else
        plot_mds_core(y, l, opt.scale, []);
    end
    
    a = gca;
    a.Position = [0 0 1 1];
    set(gcf, 'Color', 'white')
end
