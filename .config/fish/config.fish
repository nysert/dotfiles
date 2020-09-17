alias rgrep="rg"
alias heroku:admin="heroku browse:overview"
alias heroku:st="heroku browse:settings"
alias glog="git log --graph --abbrev-commit --decorate --date=relative --all"
alias glog0="git log --graph --abbrev-commit --decorate --date=relative --all"
alias glog1="git log --all --decorate --oneline --graph"

set pure_enable_git true
set pure_color_prompt_on_success green
set pure_color_git_dirty "#fff700"
set pure_color_git_branch "#ff9100"
set pure_color_git_unpulled_commits blue
set pure_color_git_unpushed_commits blue
set pure_color_ssh_user_root pure_color_white
set pure_color_ssh_user_root pure_color_light

bind \t accept-autosuggestion complete
