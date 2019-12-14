# setup
# source - http://news.ycombinator.com/item?id=11070797

git clone --bare git@github.com:drojas/.files.git $HOME/.files
alias dot='git --git-dir=$HOME/.files/ --work-tree=$HOME'

dot checkout
dot config status.showUntrackedFiles no
