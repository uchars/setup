if [ -d "$HOME/.local/bin/nvim/bin" ]; then
	PATH="$HOME/.local/bin/nvim/bin:$PATH"
fi

if [ -d "$HOME/.local/bin/fd/" ]; then
	PATH="$HOME/.local/bin/fd/:$PATH"
fi

if [ -d "$HOME/.local/bin/jdt/bin" ]; then
	PATH="$HOME/.local/bin/jdt/bin/:$PATH"
fi

if [ -d "$HOME/.local/bin/" ]; then
	PATH="$HOME/.local/bin/:$PATH"
fi

if [ -d "$HOME/.cargo/bin/" ]; then
	PATH="$HOME/.cargo/bin/:$PATH"
fi


if [ -d "$HOME/.local/bin/dwmblocks/" ]; then
	PATH="$HOME/.local/bin/dwmblocks/:$PATH"
fi

if [ -d "$HOME/.config/emacs/bin" ]; then
	PATH="$HOME/.config/emacs/bin:$PATH"
fi

if [ -d "/usr/lib64/GNUstep/Applications/WPrefs.app" ]; then
	PATH="/usr/lib64/GNUstep/Applications/WPrefs.app/:$PATH"
fi

if [ -d "$HOME/.ghcup/bin" ]; then
	PATH="$HOME/.ghcup/bin:$PATH"
fi

if [ -d "$HOME/Downloads/zig-linux-x86_64-0.14.0" ]; then
	PATH="$HOME/Downloads/zig-linux-x86_64-0.14.0:$PATH"
fi

export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH
export PATH=$HOME/.pub-cache/bin:$PATH
export PATH="$PATH":"$HOME/fvm/default/bin"
export PATH="$PATH":"$HOME/fvm/bin"

