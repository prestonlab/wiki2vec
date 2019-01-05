function [vectors, items] = read_vectors(vector_file, ndim)
%READ_VECTORS   Read a text file with items and vectors.
%
%  [vectors, items] = read_vectors(vector_file, ndim)
%
%  INPUTS
%  vector_file : str
%      Path to file with vectors.
%
%  ndim : int
%      Number of dimensions in each vector.
%
%  OUTPUTS
%  vectors : [items x dims] numeric array
%      Array of vector representations for all items.
%
%  items : cell array of strings
%      String corresponding to each item.

fid = fopen(vector_file, 'r');
c = textscan(fid, ['%s' repmat('%f', 1, ndim)], ...
             'CollectOutput', true, 'Delimiter', ' ');
fclose(fid);
vectors = c{2};

% spaces are stored as underscores in vector files; reverse this
items = strrep(c{1}, '_', ' ');
