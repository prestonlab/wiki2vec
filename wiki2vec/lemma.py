"""Find lemma of nouns and verbs."""

from __future__ import unicode_literals

import nltk
from nltk.corpus import wordnet


class Splitter(object):
    def __init__(self):
        self.nltk_splitter = nltk.data.load('tokenizers/punkt/english.pickle')
        self.nltk_tokenizer = nltk.tokenize.TreebankWordTokenizer()

    def split(self, text):
        """
        input format: a paragraph of text
        output format: a list of lists of words.
            e.g.: [['this', 'is', 'a', 'sentence'],
                   ['this', 'is', 'another', 'one']]
        """
        sentences = self.nltk_splitter.tokenize(text)
        tokenized_sentences = [self.nltk_tokenizer.tokenize(sent) for sent in
                               sentences]
        return tokenized_sentences


class POSTagger(object):
    def __init__(self):
        pass

    def pos_tag(self, sentences):
        """
        input format: list of lists of words
            e.g.: [['this', 'is', 'a', 'sentence'],
                   ['this', 'is', 'another', 'one']]
        output format:
        
        """
        nounverbpostags = ['NN', 'NNP', 'NNPS', 'NNS', 'VB', 'VBD', 'VBG',
                           'VBN', 'VBP', 'VBZ']
        nouns_and_verbs = []
        for sentence in sentences:
            pos = nltk.pos_tag(sentence)
            # return pos

            for (word, postag) in pos:
                if postag in nounverbpostags:
                    nouns_and_verbs.append((word, postag))
        return nouns_and_verbs


class WordNetLemmatizer(object):
    """
    WordNet Lemmatizer

    Lemmatize using WordNet's built-in morphy function.
    Returns the input word unchanged if it cannot be found in WordNet.

        >>> from nltk.stem import WordNetLemmatizer
        >>> wnl = WordNetLemmatizer()
        >>> print(wnl.lemmatize('dogs'))
        dog
        >>> print(wnl.lemmatize('churches'))
        church
        >>> print(wnl.lemmatize('aardwolves'))
        aardwolf
        >>> print(wnl.lemmatize('abaci'))
        abacus
        >>> print(wnl.lemmatize('hardrock'))
        hardrock
    """

    def __init__(self):
        pass

    def lemmatize(self, word, pos):
        lemmas = wordnet._morphy(word, pos)
        return min(lemmas, key=len) if lemmas else word

    def __repr__(self):
        return '<WordNetLemmatizer>'
