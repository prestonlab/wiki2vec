function create_models()

% load pool for confirmation of correct order
load ~/experiments/nemesis/exp/bender/stim/pool_main.mat

model_dir = '~/work/bender/batch/models3';
if ~exist(model_dir, 'dir')
    mkdir(model_dir)
end

% pictures with alpha
dummy = cell(size(pool));
[pool.crop] = dummy{:};
[pool.alpha] = dummy{:};
alpha_dir = '~/experiments/nemesis/pools/main_180_alpha';
for i = 1:length(pool)
    [~, filename, ~] = fileparts(pool(i).filepath);
    png_file = fullfile(alpha_dir, pool(i).subtype, [filename '.png']);
    if exist(png_file, 'file')
        [a, map, alpha] = imread(png_file);
        pool(i).crop = a;
        pool(i).alpha = alpha;
    else
        pool(i).crop = pool(i).picture;
    end
end

pool_file = '~/work/wikisim/wiki/pool_bender.mat';
save(pool_file, 'pool');

%% category

% order is: faces, scenes
labels = zeros(120, 2);
labels(1:60,1) = 1;
labels(61:120,2) = 1;
save_model(labels, {pool(1:120).name}', model_dir, 'mat_cat', 'exact');


%% subcategory

% use standard order (female, male, manmade, natural)
labels = zeros(120, 4);
labels(1:30,1) = 1;
labels(31:60,2) = 1;
labels(61:90,3) = 1;
labels(91:120,4) = 1;
save_model(labels, {pool(1:120).name}', model_dir, 'mat_subcat', 'exact');


%% combined

labels = zeros(120, 6);
labels(1:30,[1 5]) = 1;
labels(31:60,[2 5]) = 1;
labels(61:90,[3 6]) = 1;
labels(91:120,[4 6]) = 1;
save_model(labels, {pool(1:120).name}', model_dir, 'mat_combined');


%% wiki

% use bags-of-words created by shell scripts
items_file = '~/work/wikisim/pool_items_famous.txt';
bag_dir = '~/work/wikisim/wiki/famous/itemtext_bag';
[word_count, items, words] = init_wordmat(items_file, bag_dir);
assert(isequal({pool(1:120).name}', items), 'stimuli do not match.');

% normalize, but don't do any dimensionality reduction (doesn't
% seem to help with these data)
wc_norm = wiki_vectors(word_count, 'svd', false);
save_model(wc_norm, items, model_dir, 'mat_wiki');


%% wiki word2vec

% write words to look up (included here for completeness, but
% should already have been run)
words_dir = '~/work/wikisim/word2vec/famous_words';
if ~exist(words_dir, 'dir')
    mkdir(words_dir);
end
orig_file = fullfile(words_dir, 'items_orig.txt');
w2v_file = fullfile(words_dir, 'items_w2v.txt');
if ~exist(orig_file, 'file')
  f1 = fopen(orig_file, 'w');
  f2 = fopen(w2v_file, 'w');
  for i = 1:length(words)
    fprintf(f1, '%s\n', words{i});
    fprintf(f2, '%s\n', strrep(words{i}, ' ', '_'));
  end
  fclose(f1);
  fclose(f2);
end

% look up vectors for all words (run through shell script; should
% have already been run)

% load word2vec vectors for all terms; remove missing vectors
vec_file = '~/work/wikisim/word2vec/famous_words/items_vec.txt';
[w2v_vectors, terms] = read_vectors(vec_file, 300);
include = ~isnan(w2v_vectors(:,1));

% calculate vector for each document by adding all document
% vectors, weighted by frequency
wiki_w2v = word_count(:,include) * w2v_vectors(include,:);
save_model(wiki_w2v, items, model_dir, 'mat_wiki_w2v');


%% item word2vec

% shell scripts used to get vectors from w2v dump
vec_file = '~/work/wikisim/word2vec/famous/items_vec.txt';
[vectors, items] = read_vectors(vec_file, 300);
assert(isequal({pool(1:120).name}', items), 'stimuli do not match.')
save_model(vectors, items, model_dir, 'mat_item_w2v');


%% HMAX

% just load results from existing HMAX run (was run on LS4)
s = load('~/work/bender/batch/models/mat_visual_hmax.mat');
assert(isequal({pool(1:120).name}, s.names), 'stimuli do not match.')
save_model(s.vectors, s.names, model_dir, 'mat_hmax');


%% Gist

% run the model, which is quick
vectors = gist_vectors(pool(1:120));
save_model(vectors, {pool(1:120).name}, model_dir, 'mat_gist');


%% latitude and longitude

fid = fopen('~/work/wikisim/wiki/famous/items_coord.txt', 'r');
c = textscan(fid, '%s%s', 'Delimiter', '=');
fclose(fid);

coord = NaN(120, 2);
names = {pool(1:120).name};
for i = 1:length(c{1})
    ind = find(strcmp(c{1}{i}, names));
    if length(ind) ~= 1
        error('Zero or multiple matches in coords file');
    end
    s = regexp(c{2}{i}, ',', 'split');
    coord(ind,1) = str2num(s{1});
    coord(ind,2) = str2num(s{2});
end
%geoshow('landareas.shp', 'FaceColor', [0.5 1.0 0.5]);
%geoshow(coord(61:120,1), coord(61:120,2), 'DisplayType', 'point', 'Marker', 'o', 'MarkerFaceColor', 'r')

f = @(x,y) lldistkm(x,y);
save_model(coord, {pool(1:120).name}, model_dir, 'mat_geo', f);
