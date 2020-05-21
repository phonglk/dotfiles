#!/bin/bash
PROFILE=$1

if [ -z "$PROFILE" ]
then
  echo "please input PROFILE as first parameter"
  exit
fi

rootFiles=(vimrc bashrc bash_profile profile tmux.conf)
mkdir -p $PROFILE

echo "Sync to profile $PROFILE"
for file in "${rootFiles[@]}"; do
  echo "Copy .${file}"
  cp ~/.${file} ./$PROFILE/$file
done

echo "Copy vim configuration"
cp -r ~/.vim/*.vim ./$PROFILE/vim/
cp -r ~/.vim/autoload ./$PROFILE/vim/
cp -r ~/.vim/colors ./$PROFILE/vim/
cp -r ~/.vim/session ./$PROFILE/vim/

echo "Copy fish configuration"
mkdir -p ./$PROFILE/config/fish
cp -r ~/.config/fish/config.fish ./$PROFILE/config/fish/
cp -r ~/.config/fish/functions ./$PROFILE/config/fish/

echo "Copy tmux configuration"
mkdir -p ./$PROFILE/tmux
cp -r ~/.tmux/*.tmux ./$PROFILE/tmux/
