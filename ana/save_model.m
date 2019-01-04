function save_model(vectors, items, model_dir, model_name, distance)
%SAVE_MODEL   Save representational dissimilarity model in standard format.
%
%  save_model(vectors, items, model_dir, model_name, distance)

if nargin < 5
    distance = 'correlation';
end

if strcmp(distance, 'exact')
    distance = @(x,y) ~all(x==y, 2);
end

rdm = squareform(pdist(vectors, distance));

save(fullfile(model_dir, model_name), 'rdm', 'vectors', 'items');
