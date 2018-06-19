#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/..
OUTMAN_HOME=`pwd`
ENV_NAME=outman_py
alias python=$OUTMAN_HOME/py_env/outman_py/bin/python
alias pip=$OUTMAN_HOME/py_env/outman_py/bin/pip
source $OUTMAN_HOME/py_env/$ENV_NAME/bin/activate
