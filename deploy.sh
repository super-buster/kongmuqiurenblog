#!/bin/sh

#ref1:http://www.ruanyifeng.com/blog/2020/08/rsync.html
#ref2:https://gohugo.io/hosting-and-deployment/deployment-with-rsync/

USER=root
HOST=108.160.143.157
DIR=blog/kongmuqiuren/content
LOCAL=/home/kaori/kongmuqiurenblog/
if [ ! -n "$1" ]; then
    echo "incremental deployment"
    #-a:archive -v:verbose -z:zip
    rsync -avz $LOCAL"/"content/ $LOCAL"/"static/ ${USER}@${HOST}:~/${DIR} --exclude=".#*"
    exit 0
fi

while getopts "a:d"  opt;do
    case $opt in
        a)
            det=$OPTARG
            read -r -p "Are You Sure? This Option may Destroy Your Workshop [Y/n] " input
            case $input in
                [yY][eE][sS]|[yY])
		            if [ OPTARG=="root" ];then
                        rsync -avz  $LOCAL  ${USER}@${HOST}:~/blog/kongmuqiuren --exclude=".#*"
                    fi
                    if [ OPTARG=="static" ];then
                        rsync -avz  $LOCAL"/"static  ${USER}@${HOST}:~/blog/kongmuqiuren/static --exclude=".#*"
                    fi
                    if [ OPTARG=="themes" ];then
                        rsync -avz  $LOCAL"/"themes  ${USER}@${HOST}:~/blog/kongmuqiuren/themes --exclude=".#*"
                    fi
                    if [ OPTARG=="config" ];then
                        rsync -avz  $LOCAL"/"config.toml  ${USER}@${HOST}:~/blog/kongmuqiuren/config.toml --exclude=".#*"
                    fi
		            ;;
                [nN][oO]|[nN])
		            echo "Nothing"
                    exit 0
       	                    ;;
                        *)
		                    echo "Invalid input..."
		                    exit 1
		                    ;;
            esac
            ;;
        d)
            read -r -p "Are You Sure? [Y/n] " input
            case $input in
                [yY][eE][sS]|[yY])
		            echo "delete extraneous files from dest dirs"
                    rsync -avz --delete  $LOCAL"/"content/ ${USER}@${HOST}:~/${DIR} --exclude=".#*"
		            ;;
                [nN][oO]|[nN])
		            echo "Nothing"
                    exit 0
       	            ;;
                *)
		            echo "Invalid input..."
		            exit 1
		            ;;
            esac
              ;;
              \?)
                  exit 1
                  ;;
    esac
done
