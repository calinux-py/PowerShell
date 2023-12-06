# Ask for GitHub username
$username = Read-Host -Prompt "Enter the GitHub username"

# Base GitHub API URL for user repositories
$apiUrl = "https://api.github.com/users/$username/repos"

# Output file
$outputFile = "GitHubRepos.txt"

# Function to fetch repositories and write to file
function Fetch-Repos {
    param (
        [string]$url
    )

    # Call GitHub API for repositories
    try {
        $response = Invoke-RestMethod -Uri $url -ErrorAction Stop
    } catch {
        if ($_.Exception.Response.StatusCode -eq 403) {
            $responseMessage = $_.Exception.Response.StatusDescription
            if ($responseMessage -match "Invoke-RestMethod") {
                Write-Host "GitHub has rate limited your IP address. Try switching IP addresses or waiting for a period."
                Read-Host -Prompt "Press Enter to continue"
                exit
            }
            else {
                Write-Host "An error occurred: $responseMessage"
                Write-Host "If GitHub has rate limited your IP address. Try switching IP addresses or waiting for a period."
                Read-Host -Prompt "Press Enter to continue"
                exit
            }
        }
        else {
            Write-Host "An error occurred: $($_.Exception.Message)"
            Write-Host "If GitHub has rate limited your IP address. Try switching IP addresses or waiting for a period."
            Read-Host -Prompt "Press Enter to continue"
            exit
        }
    }

    # Write each repo URL to the file and fetch its contents
    foreach ($repo in $response) {
        $repo.html_url | Out-File -Append -FilePath $outputFile

        # Fetch contents of the repository
        $contentsUrl = $repo.contents_url -replace '\{\+path\}', ''
        $repoContents = Invoke-RestMethod -Uri $contentsUrl

        # Append subdirectories, sub-repos, or files URLs
        foreach ($content in $repoContents) {
            if ($content.type -eq "dir") {
                "    ____ $($content.html_url)" | Out-File -Append -FilePath $outputFile
                # Additional check for nested contents within the directory
                Fetch-Content -url $content.url -prefix "______"
            }
            elseif ($content.type -eq "file") {
                "______ $($content.html_url)" | Out-File -Append -FilePath $outputFile
            }
        }
    }

    # Check for pagination (next page of results)
    if ($response.Headers.'Link' -match '<(https://api\.github\.com/user/repos\?page=\d+)>; rel="next"') {
        Fetch-Repos -url $matches[1]
    }
}

# Function to fetch nested directory contents
function Fetch-Content {
    param (
        [string]$url,
        [string]$prefix
    )

    $nestedContents = Invoke-RestMethod -Uri $url
    foreach ($nestedContent in $nestedContents) {
        "$prefix $($nestedContent.html_url)" | Out-File -Append -FilePath $outputFile
        if ($nestedContent.type -eq "dir") {
            # Recursively fetch contents of nested directory
            Fetch-Content -url $nestedContent.url -prefix "$prefix____"
        }
    }
}

# Start fetching repositories
Fetch-Repos -url $apiUrl

Write-Host "Repository links, their subdirectories, and files have been written to $outputFile"
