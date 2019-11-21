"""Module for extracting tokens to be used in LSA"""

import ast
import json

import nltk
from nltk.corpus.reader.wordnet import NOUN
from nltk.corpus.reader.wordnet import VERB
from nltk.data import load

from wiki2vec import lemma


def extract_entity_names(t):
    """
    Get named entity strings and other tokens from a tree.

    INPUTS:
    t:  Tree (e.g. a sentence or part of a sentence) to extract NEs from

    OUTPUTS:
    entity_names:  List of strings with entity names.
    other_tokens:  List of other words. 
    """

    entity_names = []
    other_tokens = []
    if hasattr(t, 'label') and t.label():
        if t.label() == 'NE':
            # get full name of named entity
            entity_names.append(' '.join([child[0] for child in t]))
        else:
            # some other chunk like sentence
            for child in t:
                entities, other = extract_entity_names(child)
                entity_names.extend(entities)
                other_tokens.extend(other)
    else:
        other_tokens.append(t)
    return entity_names, other_tokens


def extract_file(filepath):
    """Extract desired tokens and return their lemmas.

    Extracts all desired tokens (named entities, nouns, verbs, and
    adjectives) and finds the lemma of each.

    Uses extract_entity_names to retrieve named entities and selects
    nouns, verbs, and adjectives from other tokens list produced by
    extract_entity_names.

    INPUTS:
    filepath:  Filepath of documents to be read.

    OUTPUTS:
    entity_names:  List of strings with entity names and lemmatized
    nouns, verbs, and adjectives.
    """

    with open(filepath, 'r') as f:
        sample = f.read()

    sentences = nltk.sent_tokenize(sample)
    _POS_TAGGER = 'taggers/maxent_treebank_pos_tagger/english.pickle'
    tagger = load(_POS_TAGGER)
    regexp_tagger = nltk.tag.RegexpTagger([(r'\(|\)|\[|\]|{|}', '--')],
                                          backoff=tagger)
    tagged_sentences = [regexp_tagger.tag(nltk.word_tokenize(sentence)) for
                        sentence in sentences]
    chunked_sentences = nltk.ne_chunk_sents(tagged_sentences, binary=True)

    entity_names = []
    for tree in chunked_sentences:
        other_tokens = []
        try:
            entities, other = extract_entity_names(tree)
            entity_names.extend(entities)
            other_tokens.extend(other)
        except TypeError:
            nontype = ""
        nouns = ['NN', 'NNS', 'NNP', 'NNPS', 'NNS']
        verbs = ['VB', 'VBD', 'VBG', 'VBN', 'VBP', 'VBZ']
        adjectives = ['JJ', 'JJR', 'JJS']
        wnl = lemma.WordNetLemmatizer()
        for (word, postag) in other_tokens:
            if postag in nouns:
                noun = wnl.lemmatize(word, NOUN)
                entity_names.append(noun)
            if postag in verbs:
                verb = wnl.lemmatize(word, VERB)
                entity_names.append(verb)
            if postag in adjectives:
                adjective = word
                entity_names.append(adjective)
    return ast.literal_eval(json.dumps(entity_names))
