import { danger, fail, message, warn } from "danger";

const linesAdded = danger.github.pr.additions || 0;
const linesRemoved = danger.github.pr.deletions || 0;
const filesChanged = danger.github.pr.changedFiles || 0;
const files = danger.git.modifiedFiles + danger.git.createdFiles;

if (linesRemoved > linesAdded) {
  message("Nice work removing more code than you added!");
}

// PRs shouldn't be more than 500 lines or 15 files
const bigPRThreshold = 500;
if (linesAdded + linesRemoved > bigPRThreshold || filesChanged > 15) {
  warn(
    "Pull Request size seems large. If this Pull Request contains multiple changes, please split each into separate PRs, this will enable faster & easier review."
  );
}

// We do not include copyright headers in source
const swiftFilesWithCopyright = files.filter(path => {
  if (path.endsWith(".swift")) {
    content = fs.readFileSync(path);
    return !content.includes("Copyright");
  }

  return true;
});

for (path in swiftFilesWithCopyright) {
  fail("Please remove copyright header", file, "0");
}

// PRs must have an assignee
if (!danger.github.pr.assignee) {
  warn("Please assign yourself to the PR.");
}

// PRs must have only 1 assignee
if (danger.github.pr.assignees.length > 1) {
  warn("Please assign only yourself to the PR.");
}

// PR's must include a description
if (danger.github.pr.body.length <= 0) {
  warn("Please write a description for this PR.");
}
