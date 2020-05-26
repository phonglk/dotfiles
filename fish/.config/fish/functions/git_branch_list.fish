# Defined in - @ line 0
function git_branch_list --description alias\ git_branch_list=git\ branch\ --sort=-committerdate\ --format=\'\%\(HEAD\)\ \%\(color:yellow\)\%\(refname:short\)\%\(color:reset\)\ -\ \%\(color:red\)\%\(objectname:short\)\%\(color:reset\)\ -\ \%\(contents:subject\)\ -\ \%\(authorname\)\ \(\%\(color:green\)\%\(committerdate:relative\)\%\(color:reset\)\)\'
	git branch --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))' $argv;
end
