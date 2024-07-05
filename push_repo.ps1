# push_repos.ps1

# Directory where your repositories are located
$reposDir = "C:\path\to\your\repos"

# Get all directories in the repositories directory
$repos = Get-ChildItem -Path $reposDir -Directory | ForEach-Object { $_.Name }

# Change to the repositories directory
cd $reposDir

# Push the latest changes for each repository
foreach ($repo in $repos) {
    cd $repo
    Write-Host "Pushing latest changes for $repo"
    git add .
    git commit -m "Auto commit on shutdown"
    git push https://username:password@repository/file.git --all
    cd ..
}
