Splatmoji
=========

Quickly look up and input emoji and/or emoticons/kaomoji on your GNU/Linux desktop via pop-up menu (uses rofi, a la dmenu).

(ノ・∀・)ノ 😃

<img src="splatmoji.gif" width="400">

# Install

Requirements:

* Bash
* [rofi]
* xdotool (for typing your selection in for you)
* xsel (for putting your selection into the clipboard)

```sh
# sudo apt-get install rofi xdotool xsel || sudo yum install rofi xdotool xsel
git clone https://github.com/cspeterson/splatmoji.git
```

# Usage

```sh
# Call with default emoji and emoticon data files, copy result to clipboard
./splatmoji copy

# Call with default emoji and emoticon data files, type out result
./splatmoji type

# Call with a specific custom data file, copy result to clipboard
./splatmoji copy /path/to/data/file1 /path/to/data/file2
```

You probably would want to bind this to some key combination in your window manager/desktop enviroment.

### i3wm

[i3wm] is my preferred window manager.

```sh
# This would go into your .config/i3/config to bind to Super+slash
bindsym $mod+slash exec "/path/to/the/script type"
```

### Gnome

[This Gnome.org help page] seems to outline how to do this in the popular Gnome desktop environment.

# Configuration

Configuration options can be changed in `splatmoji.config`.

## Xsel

You can alter the arguments sent to xsel to change, say, which "selection" your text goes into. By default it will go to the "CLIPBOARD" selection, which is the one you would usually get when doing Ctrl+c/v.

For further options, check the xsel manpage.

## Xdotool

You can alter the arguments send to xdotool for typing out your selection, if for instance you need to adjust the timing delays to work more smoothly on your machine.

## Rofi
You can alter the rofi pop-up's behaviour by configuring its command line either in `<project_dir>/splatmoji.config` or by overriding the in-project config file with `${HOME}/.config/splatmoji/splatmoji.config`.

Example:

```ini
# These default arguments will pop up the menu over the currently active window
rofi_command=rofi -dmenu -p : -i -monitor -2
# Alternatively, it could pop up in the middle of the current monitor with the prompt 'Search:'
rofi_command=rofi -dmenu -p 'Search:' -i -monitor -1
# Or you could specify a theme
rofi_command=rofi -dmenu -p : -i -monitor -2 -theme /path/to/themefile
```

For *many* other options, see `man rofi`.

# Updating emoji/emoticons

Most simply, pull from this repo:

```sh
cd <install dir>
git pull
```

You can also update the emoji/emoticon sets from the same source manually if you find that this repo is not keeping up fast enough for you:

```sh
#how to pull the sets from the remote files and transform to tsv
curl 'https://raw.githubusercontent.com/muan/emojilib/master/emojis.json' | importers/emojilib2tsv - > data/splatmoji.emoji.tsv
curl 'https://raw.githubusercontent.com/w33ble/emoticon-data/master/emoticons.json' | importers/w33ble2tsv - > data/splatmoji.emoticons.tsv
```

# Custom Configuration and Custom Emoji/Emoticons

This repo uses emoji.json from [muan/emojilib] for emoji and emoticons.json from [w33ble/emoticon-data], but you can use your own files for sure if you find these sets lacking.

The emoji/emoticons should be stored in tsv like so:
```
emoji<tab>name<tab>keywords etc
```

And then you can call the utlity with your preferred data files as per [Usage](#usage) above.

Please let me know what better source you wind up using, and maybe the command(s) you use to convert it into the above format, and I'll probably work it into the repo. 🙂

# FAQ

* Why do some of the emoji come out as multiple characters?
* These are called ZWJ (zero-width joiner) Sequences. Some combinations of multiple different emoji can be combined in sequence with a special zero-width character as a joiner, and if the platform supports it a single meaningful symbol will be displayed. On platforms that *don't* support it though, no worries: it just displays the seperate emoji in sequence. 🙂

# Contributing

Taking pull requests [here].

# Credits

By [Christopher Peterson] ([@cspete])

# License

The MIT License (MIT). Please see [LICENSE](LICENSE) for more information.

[@cspete]: https://www.twitter.com/cspete
[Christopher Peterson]: https://chrispeterson.info
[This Gnome.org help page]: https://help.gnome.org/users/gnome-help/stable/keyboard-shortcuts-set.html.en
[here]: https://github.com/cspeterson/splatmoji.git
[i3wm]: https://i3wm.org/
[muan/emojilib]: https://github.com/muan/emojilib
[rofi]: https://github.com/DaveDavenport/rofi
[w33ble/emoticon-data]: https://github.com/w33ble/emoticon-data
