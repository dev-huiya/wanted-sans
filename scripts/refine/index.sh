#!/bin/zsh
set -e

script_dir="$(cd "$(dirname "$0")" && pwd)"
temp_path="$script_dir/temp"
package_path="$script_dir/../../packages"
wanted_sans_path="$package_path/wanted-sans/fonts"
wanted_sans_std_path="$package_path/wanted-sans-std/fonts"

echo "Converting Variable to ttx..."
for fonts_file in "$temp_path"/*VF.ttf; do
    ttx "$fonts_file"
    rm "$fonts_file"
done

echo "Adding Suffix from Variable..."
python3 "$script_dir/rename.py"

echo "Converting Variable to ttf..."
for fonts_file in "$temp_path"/*VF.ttx; do
    ttx "$fonts_file"
    rm "$fonts_file"
done

echo "Fixing Variable file name..."
for fonts_file in "$temp_path"/*VF.ttf; do
    mv "$fonts_file" "${fonts_file/VF/Variable}"
done

echo "Moving files to appropriate directories..."
for fonts_file in "$temp_path"/*; do
    if [[ $fonts_file != *"Std"* ]]; then
        if [[ $fonts_file == *.otf ]]; then
            target_path="$wanted_sans_path/otf"
        elif [[ $fonts_file == *.ttf && $fonts_file != *"Variable"* ]]; then
            target_path="$wanted_sans_path/ttf"
        elif [[ $fonts_file == *.ttf && $fonts_file == *"Variable"* ]]; then
            target_path="$wanted_sans_path/variable"
        fi
    elif [[ $fonts_file == *"Std"* ]]; then
        if [[ $fonts_file == *.otf ]]; then
            target_path="$wanted_sans_std_path/otf"
        elif [[ $fonts_file == *.ttf && $fonts_file != *"Variable"* ]]; then
            target_path="$wanted_sans_std_path/ttf"
        elif [[ $fonts_file == *.ttf && $fonts_file == *"Variable"* ]]; then
            target_path="$wanted_sans_std_path/variable"
        fi
    fi

    mv "$fonts_file" "$target_path"
done

echo "Done!"