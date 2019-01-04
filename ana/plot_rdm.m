function h = plot_rdm(rdm, varargin)
%PLOT_RDM   Plot a representational dissimilarity matrix.
%
%  h = plot_rdm(rdm, ...)
%
%  INPUTS:
%  rdm - [items x items] numeric matrix
%      Dissimilarity between each pair of items in a set of items.
%
%  OUTPUTS:
%  h - image handle
%      Handle for the dissimilarity matrix image in the plot.
%
%  OPTIONS:
%  labels - [1 x items] cell array of strings OR pictures - {}
%      Item labels or pictures. Must have the same order as rdm. Each
%      cell may contain a string to indicate text to display, or a
%      [width x height x 3] matrix indicating a picture to display
%      (for example, read in from an image file using imread).
%
%  ind - array of indices - []
%      Indices indicating the items to plot.
%
%  issym - boolean - true
%      True if the matrix is symmetric.
%
%  invert - boolean - false
%      If true, the matrix will be inverted (i.e. will plot 1 -
%      rdm).
%
%  prctile_range - [1 x 2] numeric array - [1 99]
%      Lower and upper percentile ranges for the color scale.
%
%  EXAMPLE:
%  rdm = squareform(rand(1,6)); % random 4x4 RDM
%  mylabels = {'a' 'b' 'c' 'd'}; % item labels
%  indices = [1 2 4]; % items to include in plot
%  h = plot_rdm(rdm, 'labels', mylabels, 'ind', indices);

def.labels = {};
def.ind = [];
def.issym = true;
def.invert = false;
def.prctile_range = [1 99];
opt = propval(varargin, def);

if isempty(opt.ind)
    opt.ind = 1:length(rdm);
end

% image
if opt.issym
    cmin = prctile(squareform(rdm(opt.ind,opt.ind)), opt.prctile_range(1));
    cmax = prctile(squareform(rdm(opt.ind,opt.ind)), opt.prctile_range(2));
else
    submat = rdm(opt.ind,opt.ind);
    cmin = prctile(submat(:), opt.prctile_range(1));
    cmax = prctile(submat(:), opt.prctile_range(2));
end

if opt.invert
    h = imagesc(1 - rdm(opt.ind,opt.ind), [1-cmax 1-cmin]);
else
    submat = rdm(opt.ind,opt.ind);
    h = imagesc(submat, [cmin cmax]);
end
colorbar
axis ij
axis image

% turn off ticks
set(gca, 'TickLength', [0 0])

% set the tick labels
if ~isempty(opt.labels)
    aind = 1:length(opt.ind);
    set(gca, 'YTick', aind, 'YTickLabel', opt.labels(opt.ind));
    set(gca, 'XTick', aind, 'XTickLabel', opt.labels(opt.ind));
    
    % if newer graphics, rotate xtick label to accomodate long
    % names in dense plots
    if isprop(gca, 'XTickLabelRotation')
        set(gca, 'XTickLabelRotation', 90);
    end
else
    axis off
    set(gca, 'XTick', [], 'YTick', [])
end
