# Git Command Reference

## Basic Setup and Configuration

### Initialize a Git Repository

```bash
git init
```

Creates a new Git repository in the current directory, creating a `.git` subdirectory with all necessary metadata.

### Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Basic Workflow

### Stage Changes

```bash
git add <file>              # Add specific file
git add .                   # Add all changes in current directory
git add -A                  # Add all changes in repository
git add -p                  # Interactively stage chunks
```

### Commit Changes

```bash
git commit -m "Commit message"           # Commit with message
git commit -am "Message"                 # Add and commit tracked files
git commit --amend                       # Modify last commit
git commit --amend --no-edit             # Amend without changing message
```

### View Status and History

```bash
git status                  # Show working tree status
git log                     # Show commit history
git log --oneline           # Compact log view
git log --graph --oneline   # Visual branch graph
```

## Remote Repositories

### Connect to Remote

```bash
git remote add origin <url>              # Add remote repository
git remote -v                            # List remotes
git remote show origin                   # Show remote details
```

### Push Changes

```bash
git push origin <branch>                 # Push branch to remote
git push -u origin <branch>              # Push and set upstream
git push --all                           # Push all branches
git push --tags                          # Push all tags
git push --force                         # Force push (use carefully!)
git push --force-with-lease              # Safer force push
```

### Fetch from Remote

```bash
git fetch                                # Fetch from default remote
git fetch origin                         # Fetch from specific remote
git fetch --all                          # Fetch from all remotes
git fetch --prune                        # Remove deleted remote branches
```

**Important**: `git fetch` downloads the remote history into your local repository graph but **does not move your local branches**. Your local branches stay where they are, and remote-tracking branches (like `origin/main`) are updated to reflect the remote state.

### Pull Changes

```bash
git pull                                 # Fetch + merge
git pull --rebase                        # Fetch + rebase
git pull --ff-only                       # Only fast-forward merge
```

## Merging and Integration

### Merge Branches

```bash
git merge <branch>                       # Merge branch into current
git merge origin/main --ff-only          # Fast-forward only merge
git merge --no-ff <branch>               # Create merge commit
git merge --squash <branch>              # Squash commits before merge
```

**Fast-forward only (`--ff-only`)**: Only merge if your branch can be fast-forwarded (no divergent changes). This keeps history linear and fails if a real merge is needed.

### Rebase

```bash
git rebase <branch>                      # Rebase current branch onto another
git rebase origin/main                   # Rebase onto remote main
git rebase -i <commit>                   # Interactive rebase
git rebase -i HEAD~3                     # Rebase last 3 commits
git rebase --continue                    # Continue after resolving conflicts
git rebase --abort                       # Cancel rebase operation
git rebase --skip                        # Skip current commit
```

**Rebase** replays your commits on top of another branch, creating a linear history. Never rebase commits that have been pushed to a shared branch.

## Branching

### Create and Switch Branches

```bash
git branch <branch-name>                 # Create new branch
git checkout <branch-name>               # Switch to branch
git checkout -b <branch-name>            # Create and switch
git switch <branch-name>                 # Modern way to switch
git switch -c <branch-name>              # Create and switch (modern)
```

### Manage Branches

```bash
git branch                               # List local branches
git branch -a                            # List all branches
git branch -d <branch>                   # Delete merged branch
git branch -D <branch>                   # Force delete branch
git branch -m <old> <new>                # Rename branch
```

## Debugging and History

### Git Bisect

```bash
git bisect start                         # Start bisect session
git bisect bad                           # Mark current commit as bad
git bisect good <commit>                 # Mark commit as good
git bisect reset                         # End bisect session
git bisect run <script>                  # Automated bisect with script
git bisect skip                          # Skip current commit (e.g., won't compile)
```

**Bisect** helps find which commit introduced a bug using binary search. Git automatically checks out commits between good and bad, and you mark each as good or bad until the culprit is found.

**Example workflow**:
```bash
# Start bisect
git bisect start

# Mark current commit as bad (has the bug)
git bisect bad

# Mark a known good commit (doesn't have the bug)
git bisect good v1.0

# Git checks out a commit halfway between good and bad
# Test the commit...

git bisect good    # If bug is not present
# OR
git bisect bad     # If bug is present

# Repeat until Git finds the first bad commit
# Git will output the commit that introduced the bug

# End bisect session
git bisect reset
```

**Automated bisect with script**:
```bash
git bisect start HEAD v1.0
git bisect run ./test-script.sh    # Script should exit 0 for good, 1 for bad
git bisect reset
```

### Inspect Changes

```bash
git diff                                 # Show unstaged changes
git diff --staged                        # Show staged changes
git diff <branch1>..<branch2>            # Compare branches
git show <commit>                        # Show commit details
git blame <file>                         # Show who changed each line
```

### Search History

```bash
git log -S "search term"                 # Search for text in history
git log --grep "pattern"                 # Search commit messages
git log -- <file>                        # Show history of file
git log -p <file>                        # Show history with diffs
```

## Undoing Changes

### Unstage and Discard

```bash
git restore <file>                       # Discard working changes
git restore --staged <file>              # Unstage file
git reset HEAD <file>                    # Unstage file (old way)
git reset --soft HEAD~1                  # Undo commit, keep changes staged
git reset --mixed HEAD~1                 # Undo commit, keep changes unstaged
git reset --hard HEAD~1                  # Undo commit, discard changes
```

### Revert Commits

```bash
git revert <commit>                      # Create commit that undoes changes
git revert HEAD                          # Revert last commit
git revert <commit1>..<commit2>          # Revert range of commits
```

## Stashing

```bash
git stash                                # Stash current changes
git stash save "message"                 # Stash with description
git stash list                           # List all stashes
git stash pop                            # Apply and remove latest stash
git stash apply                          # Apply stash without removing
git stash drop                           # Delete latest stash
git stash clear                          # Remove all stashes
```

## Tags

```bash
git tag                                  # List tags
git tag <tag-name>                       # Create lightweight tag
git tag -a <tag-name> -m "message"       # Create annotated tag
git tag -d <tag-name>                    # Delete local tag
git push origin <tag-name>               # Push tag to remote
git push origin --tags                   # Push all tags
git push origin --delete <tag-name>      # Delete remote tag
```

## Advanced Operations

### Cherry-pick

```bash
git cherry-pick <commit>                 # Apply commit to current branch
git cherry-pick <commit1>..<commit2>     # Apply range of commits
```

### Reflog

```bash
git reflog                               # Show reference log
git reflog show <branch>                 # Show reflog for branch
git reset --hard <reflog-entry>          # Recover lost commits
```

### Clean

```bash
git clean -n                             # Show what would be deleted
git clean -f                             # Delete untracked files
git clean -fd                            # Delete untracked files and directories
git clean -fX                            # Delete ignored files
```

## Workflow Tips

### Typical Workflow After Fetch

```bash
# Fetch remote changes (updates origin/main without moving main)
git fetch origin

# Option 1: Fast-forward merge (only if no local commits)
git merge origin/main --ff-only

# Option 2: Rebase local commits on top of remote
git rebase origin/main

# Option 3: Regular merge (creates merge commit)
git merge origin/main
```

### Before Pushing

```bash
git fetch origin
git rebase origin/main
git push origin main
```

### Feature Branch Workflow

#### Case 1: Main has NO local changes (clean sync with origin/main)

```bash
git checkout -b feature/new-feature
# Make changes and commits

git fetch origin
git rebase origin/main                   # Put feature commits on top of origin/main
git checkout main
git merge origin/main --ff-only          # Fast-forward main to origin/main
git merge feature/new-feature --ff-only  # Fast-forward main to feature commits
git push origin main
```

#### Case 2: Main HAS local changes (ahead of origin/main)

```bash
git checkout -b feature/new-feature
# Make changes and commits

git fetch origin
git rebase origin/main                   # Put feature commits on top of origin/main

# First, update main branch with remote changes
git checkout main
git rebase origin/main                   # Rebase main's local commits on top of origin/main

# Now merge feature branch
git merge feature/new-feature --ff-only  # Fast-forward main to include feature commits
git push origin main
```

**Note**: In Case 2, if main has local commits, you need to rebase main first to put those commits on top of origin/main, then you can fast-forward merge your feature branch.
