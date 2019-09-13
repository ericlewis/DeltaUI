import Danger
let danger = Danger()


let linesAdded = danger.github.pullRequest.additions ?? 0
let linesRemoved = danger.github.pullRequest.deletions ?? 0
let filesChanged = danger.github.pullRequest.changedFiles ?? 0
let files = danger.git.modifiedFiles + danger.git.createdFiles

// Compliment removal of code over adding code
if linesRemoved > linesAdded {
    message("Nice work removing more code than you added!")
}

// PRs shouldn't be more than 500 lines or 15 files
var bigPRThreshold = 500;
if linesAdded + linesRemoved > bigPRThreshold || filesChanged > 15 {
    warn("Pull Request size seems large. If this Pull Request contains multiple changes, please split each into separate PRs, this will enable faster & easier review.");
}

// We do not include copyright headers in source
let swiftFilesWithCopyright = files.filter {
    $0.contains("Copyright") && ($0.fileType == .swift)
}
for file in swiftFilesWithCopyright {
    fail(message: "Please remove this copyright header", file: file, line: 0)
}

// PRs must have an assignee
if danger.github.pullRequest.assignee == nil {
    warn("Please assign yourself to the PR.");
}

// PRs must have only 1 assignee
if (danger.github.pullRequest.assignees?.count ?? 0) > 1 {
    warn("Please assign only yourself to the PR.");
}

// PR's must include a description
if (danger.github.pullRequest.body?.count ?? 0) <= 0 {
    warn("Please write a description for this PR.")
}
