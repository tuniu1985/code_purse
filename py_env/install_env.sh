#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/..
OUTMAN_HOME=`pwd`
ENV_NAME=outman_py

##更新低版本pip,负责可能没有--trusted-host选项
function pip_update(){
	PIP_VERSION=`pip --version | awk '{print $2}' | awk -F '.' '{print $1}'`
	if [ $PIP_VERSION -lt 6 ]; then	
		echo "pip need updated...."
		pip install -U pip
	fi
}

function install_ez_install(){
	cd $OUTMAN_HOME/py_env
	tar xzf ez_setup-0.9.tar.gz
	cd ez_setup-0.9
	#sed -i 's/pypi.python.org/mirrors.aliyun.com/g' ez_setup.py 
	#$OUTMAN_HOME/env/python-2.7/bin/python ez_setup.py	
}

function install_pip(){
	cd $OUTMAN_HOME/py_env
	tar xzf pip-7.1.2.tar.gz
	cd pip-7.1.2
	$OUTMAN_HOME/py_env/python-2.7/bin/python setup.py install
	#alias的优先级比source高,alias如设置则不会调用virtualenv的包 fix by tuniu.hb
	alias pip=$OUTMAN_HOME/py_env/outman_py/bin/pip
}
##安装pip
function pip_prepare(){
:<<!
	type pip
	if [ $? -eq 0 ];then
		pip_update
	else
		type easy_install
		if [ $? -ne 0 ];then
			install_ez_install			
		fi		
		install_pip
	fi
!
	install_ez_install			
	install_pip
}

##创建virtualenv，更新环境变量并修改用户profile
function create_virtualenv(){
	cd $OUTMAN_HOME/py_env
	rm -rf $ENV_NAME
	$OUTMAN_HOME/env/python-2.7/bin/virtualenv $ENV_NAME
	source $OUTMAN_HOME/env/$ENV_NAME/bin/activate
}

##修改用户profile
function update_profile(){

    if [ "$1"  == "no_profile" ] ;then
        return
    fi
 
	if [ "`whoami`" == "admin" ] ;then
		return
	fi


	read -p "add initillize command to user profile('~/.bash_profile')? [Y/N] " YN
	if [ $YN == "y" ] || [ $YN == "Y" ]; then
		COUNT=`grep "source $OUTMAN_HOME/env/$ENV_NAME/bin/activate" ~/.bash_profile | wc -l `	
		if [ $COUNT -eq 0 ];then
			echo "source $OUTMAN_HOME/env/$ENV_NAME/bin/activate" >> ~/.bash_profile	
		fi
	fi
}



function install_python(){
        cd $OUTMAN_HOME/py_env
	rm -rf ez_setup-0.9
	rm -rf pip-7.1.2
	rm -rf python-2.7
	tar -xzf python-2.7.tgz
	#alias的优先级比source高,alias如设置则不会调用virtualenv的包 fix by tuniu.hb
	alias python=$OUTMAN_HOME/py_env/outman_py/bin/python
}



function main(){
	install_python
	pip_prepare
	$OUTMAN_HOME/py_env/python-2.7/bin/pip install virtualenv -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
	create_virtualenv
	update_profile $1
}

# no_profile: do not add outman py to user profile
export PIP_DEFAULT_TIMEOUT=60
main $1 
source $OUTMAN_HOME/env/$ENV_NAME/bin/activate



