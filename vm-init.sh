# Update the package manager per OS

if [ -f /etc/debian_version ]; then
    sudo apt-get update
elif [ -f /etc/redhat-release ]; then
    sudo yum update
elif [ -f /etc/arch-release ]; then
    sudo pacman -Syu
else
    echo "Unsupported OS"
    exit 1;
fi

# Install Konsole, Zsh and Git
if [ -f /etc/debian_version ]; then
    sudo apt-get install konsole zsh git -y || { echo "Failed to install packages. Exiting."; exit 1; }
elif [ -f /etc/redhat-release ]; then
    sudo yum install konsole zsh git -y || { echo "Failed to install packages. Exiting."; exit 1; }
elif [ -f /etc/arch-release ]; then
    sudo pacman -S konsole zsh git -y || { echo "Failed to install packages. Exiting."; exit 1; }
else
    echo "Unsupported OS"
    exit 1;
fi

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

# Install tailscale
curl -fsSL https://tailscale.com/install.sh | sh
