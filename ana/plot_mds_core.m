function h = plot_mds_core(y, l, scale, alpha, category, colors)
%PLOT_MDS_CORE   Plot multidimensional scaling results.
%
%  h = plot_mds_core(y, l, scale, alpha)

if nargin < 4
    alpha = cell(size(l));
end

% set scale of pictures being plotted
xo = range(y(:,1)) * .1;
yo = range(y(:,2)) * .1;
limits = [min(y(:,1))-xo max(y(:,1))+xo min(y(:,2))-yo max(y(:,2))+yo];
mindist = min([xo yo]) * scale;
width = mindist;
height = mindist;

% plot all images/labels
for i = 1:length(y)
    if ischar(l{i})
        h(i) = text(y(i,1), y(i,2), l{i});
        set(h(i), 'Color', colors{category(i)});
    else
        if ~isempty(alpha)
            if ~isempty(alpha{i})
                adata = alpha{i};
            else
                adata = ones([size(l{i},1) size(l{i},2)]);
            end
        else
            adata = all(l{i} < 255, 3);
        end
        if ndims(l{i}) == 2
            colormap(gray)
            args = {'CDataMapping', 'scaled'};
        else
            args = {};
        end
        h(i) = image('CData', l{i}, ...
                     'XData', [y(i,1)-width/2 y(i,1)+width/2], ...
                     'YData', [y(i,2)+width/2 y(i,2)-width/2], ...
                     'AlphaData', adata, args{:});
    end
end
axis(limits)
axis off

% if images, need aspect ratio set to avoid stretching
if ~ischar(l{i})
    axis image
end

set(gcf, 'Color', 'white')
