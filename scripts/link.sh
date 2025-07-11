#!/bin/bash
echo "Creating symlinks..."
cd ~/.dotfiles

folders=("shell" "git")

for folder in "${folders[@]}"
do
  echo "Linking $folder..."
  stow -v "$folder"
done

echo "Done! Your dotfiles are now linked."
