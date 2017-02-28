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
It open files for the given date. If the date is not provided, it will open files for the current day. Date can be provided in following formats:
- %d/%m/%y Ex: 7/10/15
- %d-%m-%y Ex. 7-10-15
- %d%b%y Ex: 7Oct15

In case any of day, month or year is not given, they are assumed to be the current one. For ex: `fb show 7` will open files corresponding to 07-2-2017 (if today's month is february and year is 2017) . `fb show` will open files for today.

### fb show -c <custom file address>
It will simply open a file at ~/.feedback/Custom/<custom file address>. This feature is a good replacement for cases when you need to store information for particular topics like for a project, a technology you are learning,  etc. As a reference, I have following custom files to name a few: ideas, movies, blogs/feedback, books/black-swan, etc.

Note that it comes with tab completion feature so that you don’t have to remember and type complete file address.

### fb find <keyword>
It will search for the given string in all the feedback files. For eg, to search for "bash", run: `fb find bash`

### fb revise
It will open files corresponding to the days you have to revise.

Features to add:
- [ ] Build a tagging system
