
pupdate () { case ":${PATH:=$1}:" in *:$1:*) ;; *) PATH="$1:$PATH" ;; esac; }
parent="$( cd "$( dirname "${BASH_SOURCE[0]}" )" & pwd )"

pupdate "$parent"/prep
pupdate "$parent"/word2vec
pupdate "$parent"/wikiextractor
export PYTHONPATH=$PYTHONPATH:$parent
