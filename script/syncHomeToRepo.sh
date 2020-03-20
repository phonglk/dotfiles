#!/bin/bash
PROFILE=$1

echo "Sync to profile $PROFILE"
cp ~/.vimrc ./$PROFILE/vimrc
cp -r ~/.vim/*.vim ./$PROFILE/vim/
cp -r ~/.vim/autoload ./$PROFILE/vim/autoload
cp -r ~/.vim/colors ./$PROFILE/vim/colors
cp -r ~/.vim/session ./$PROFILE/vim/session