add_upstream() {
  local repository_name
  repository_name=$(basename "$(pwd)")
  local remote_url="git@github.com:Pioneer-Valley-Books/${repository_name}.git"
  git remote add upstream "$remote_url"
  echo "Added remote 'upstream' with URL: $remote_url"
}

alias gupstream="add_upstream"

clean_gone_branches() {
  git fetch --prune
  current_branch=$(git branch --show-current)
  for branch in $(git branch | sed 's/^[* ] //'); do
    if [ "$branch" != "$current_branch" ] && [ "$branch" != "main" ] && [ "$branch" != "master" ]; then
      if ! git show-ref --verify --quiet refs/remotes/origin/"$branch"; then
        git branch -D "$branch"
        echo "Deleted local branch: $branch"
      fi
    fi
  done
}

alias gclean="clean_gone_branches"