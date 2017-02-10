## Feedback
It’s a Linux shell based tool that I use to facilitate active learning and timed revision, and maintain an organised database of the things that I have learnt. It maintains a directory for each day and the whole directory structure is organised as “year/month/date/”. Directories corresponding to each day contains a few default files, which can be configured.

In short, it provides a quick and organised way to store and retrieve information, revise it, and quickly search in it if required.

## Installation Instructions
Download: `git clone https://github.com/luviiit/feedback.git`

You should place the output of this command in your .bashrc, bash_profile, .zshrc or other startup script
`echo "alias fb=\"bash $(pwd)/feedback/main.sh\""`

## Available Commands
- fb show <args>
- fb find <args>
- fb revise

### fb show <date>
Open files corresponding to `<date>`
It takes date in multiple formats:
- dd/mm/yy Ex. 07/10/15 or 7/10/15
- dd-mm-yy Ex. 07-10-15 or 7-10-15
- Ex. 07Oct15 or 7Oct15

In case any of dd, mm or yy is not given, they are assumed to be the current one. For ex: `fb show 7` will open files corresponding to 07-10-2016. `fb show` will open file corresponding to today.

Many times it happens that you want to maintain separate files for things like todos, books you want to read, movies you want to watch, etc. For that run:
`fb show -c <custom_name>` (Ex. `fb show -c todo`)

### fb find <keyword>
It takes any string and search for that in all your feedback files. For example: to search for "bash", run: `fb find bash`

### fb revise
run `fb revise` to do revision
To revise custom files, run `fb show -c <custom_name>`

For linux, I have added key bindings to get files in focus (faster access)

Key bindings for Linux users:
sudo apt install wmctrl
sudo apt install xdotool
install xbindkeys
xbindkeys -p # to refresh
xbindkeys -k # to check keycode for any combination
cp feedback/xbindkeyssrc ~/.xbindkeyssrc
nohup xbindkeys

Features to add:
- [ ] Add hotkeys for Mac
- [ ] Build a tagging system (for ex: write [todo](content) in a regular fb file and "content" would be added to your custom todo file)
