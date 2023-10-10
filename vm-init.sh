# Update the package manager
sudo yum update -y

# Install Konsole
sudo yum install konsole -y

# Install Zsh and konsole
sudo yum install konsole zsh -y

# Set Zsh as the default shell
chsh -s $(which zsh)

# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install shades-of-purple theme
curl https://raw.githubusercontent.com/ahmadawais/shades-of-purple-iterm2/master/shades-of-purple.zsh-theme > ~/.oh-my-zsh/themes/shades-of-purple.zsh-theme

# Set the theme
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="shades-of-purple"/g' ~/.zshrc

# create konsole folder
mkdir -p ~/.local/share/konsole

# Download the shades-of-purple konsole scheme
curl https://raw.githubusercontent.com/ahmadawais/shades-of-purple-konsole/master/shades-of-purple.colorscheme > ~/.local/share/konsole/shades-of-purple.colorscheme

# Set the konsole scheme
echo "[Appearance]\n ColorScheme=shades-of-purple \n [General]\n Command=/bin/zsh \n Name=Shell \n Parent=FALLBACK/" >> ~/.local/share/konsole/Shell.profile
