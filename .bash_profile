# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.2-3

# ~/.bash_profile: executed by bash(1) for login shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bash_profile

# Modifying /etc/skel/.bash_profile directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bash_profile) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bash_profile file

# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
source "${HOME}/.bashrc"
fi

# Set PATH so it includes user's private bin if it exists
# if [ -d "${HOME}/bin" ] ; then
#   PATH="${HOME}/bin:${PATH}"
# fi

# Set MANPATH so it includes users' private man if it exists
# if [ -d "${HOME}/man" ]; then
#   MANPATH="${HOME}/man:${MANPATH}"
# fi

# Set INFOPATH so it includes users' private info if it exists
# if [ -d "${HOME}/info" ]; then
#   INFOPATH="${HOME}/info:${INFOPATH}"
# fi
#functions for showing git repo status on the command line

# * uncommitted changes
# ^ stashed changes
# > ahead of origin
# < behind origin
# ↕ diverged from origin
# R rebasing

function parse_git_dirty() {
	regex="working (directory|tree) clean"
		if [[ $1 =~ $regex ]]
			then
				echo ""
		else
			echo "*"
				fi
}

function parse_git_rebasing() {
	regex="currently rebasing"
		if [[ $1 =~ $regex ]]
			then
				echo "R"
		else
			echo ""
				fi
}

function parse_git_stash (){
	stash=`git stash list 2> /dev/null | wc -l | tr -d ' '`

		[[ $stash != 0 ]] && echo "^$stash"
}

function parse_git_ahead() {
	regex="Your branch is ahead of [a-z'/]+ by ([0-9]+)"
		if [[ $1 =~ $regex ]]
			then
				n=${BASH_REMATCH[1]}
	echo ">$n"
		fi
}

function parse_git_behind() {
	regex="Your branch is behind [a-z'/]+ by ([0-9]+)"
		if [[ $1 =~ $regex ]]
			then
				n=${BASH_REMATCH[1]}
	echo "<$n"
		fi
}

function parse_git_diverge() {
	regex="([0-9]+) and ([0-9]+) different commits"
		if [[ $1 =~ $regex ]]
			then
				your=${BASH_REMATCH[1]}
	source=${BASH_REMATCH[2]}
	symbol="↕"
		echo "$your$symbol$source"
		fi
}

function current_git_branch() {
	git rev-parse --abbrev-ref HEAD 2> /dev/null
}

function current_git_branch_with_markers {
	current=`current_git_branch`
		if [[ $current ]]
			then
				git_status=`git status 2> /dev/null`
				stash=`parse_git_stash`
				ahead=`parse_git_ahead "$git_status"`
				behind=`parse_git_behind "$git_status"`
				diverge=`parse_git_diverge "$git_status"`
				dirty=`parse_git_dirty "$git_status"`
				rebasing=`parse_git_rebasing "$git_status"`
				echo $current | sed -e "s/\(.*\)/ \[\1$ahead$behind$diverge$dirty$rebasing$stash\]/"
				fi
}

function set_prompt {
	local BLACK="\[\033[0;38m\]"
		local RED="\[\033[0;31m\]"
		local RED_BOLD="\[\033[01;31m\]"
		local BLUE="\[\033[01;34m\]"
		local GREEN="\[\033[0;32m\]"
		PS1="$RED\h $GREEN\w $RED_BOLD\$(current_git_branch_with_markers) $BLACK\$ "
}

alias g='git'

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
	. /etc/bash_completion
fi

function_exists() {
	declare -f -F $1 > /dev/null
	return $?
}

for al in `__git_aliases`; do
	alias g$al="git $al"
	
	complete_func=_git_$(__git_aliased_command $al)
	function_exists $complete_fnc && __git_complete g$al $complete_func
done

function up()
{
	git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | grep -v "\*" | grep -v "master" | grep -v "develop" | xargs -r git branch -D
}

# Diff the nth modified file of the status list
function gd()
{
	git status | grep modified: | cut -c 14- | sed -n "${1}p" | xargs -r git diff
}

set_prompt
