---
name: linear
description: Manage Linear issues during development. Use when the task involves creating an issue from the current context, starting work on an issue, syncing branch or PR status back to Linear, viewing the current issue, or checking active Linear-linked work.
argument-hint: create [request] | start <issue-id> | done | view | status
---

# Linear Issue Workflow

One Linear issue = one Mission Task. The agent creates sub-tasks naturally during work; Linear only updates at key milestones.

> For CLI reference, see the **linear-cli** skill.

## Prerequisites

```bash
npx @schpet/linear-cli --version
npx @schpet/linear-cli auth login
```

Check `.linear.toml` exists at repo root (see **linear-cli** skill → config).

## Mental Model

```
Linear issue   = mission brief (created at /linear create, loaded at /linear start)
Agent Tasks    = execution scratchpad (session-local, ephemeral, never sync to Linear)
Linear updates = milestone markers (/linear create → Backlog, /linear start → In Progress, /linear done → sync PR context and close when appropriate)
```

The two layers connect at `create`, `start`, and `done`, plus any meaningful milestone during execution.

Write Linear updates for collaborators, not for your local machine. Share decisions, scope changes, implementation progress, validation outcomes, risks, and next steps. Do not include local-only paths, local database record details, raw dumps, or other low-signal evidence.

`/linear start` replays recent comments back into the Mission Task, so everything you write here becomes context for the next session — treat good comment hygiene as feeding your future self.

Linear uses Chinese as its working language — write issue titles, descriptions, and comments in Chinese.

When referencing other Linear issues in descriptions or comments, paste the full URL (`https://linear.app/{workspace}/issue/L-1567`) rather than the bare `L-1567` identifier. Linear reliably renders full URLs as inline reference cards with title and status; bare IDs often fail to auto-link, especially when followed directly by Chinese text.

## Issue ID Detection

Auto-detect from branch name when no explicit ID is given:
- `jalen0x/l-1550-some-title` → `L-1550`
- Pattern: extract `{TEAM}-{number}` segment, uppercase

Explicit argument always takes priority.

## Commands

Use `--json` only for reads that feed agent decisions. Keep writes on normal flags/file inputs; use `linear api` only when JSON input is truly needed.

### /linear create [request]

- Create a new Linear issue from the current context.
- Infer parent issue from the active Mission Task or current branch when confidence is high.
- If parent inference is uncertain, create a normal issue without `--parent`.
- Reuse current issue context for team/project/cycle/labels when applicable.
- Always write the description to a temp file and use `npx @schpet/linear-cli issue create "Title" --description-file <temp-file>`.

### /linear start <issue-id>

Load the issue context, mark it In Progress, create a Mission Task, and output branch commands.

1. **Fetch issue:**
   - `npx @schpet/linear-cli issue view <issue-id> --json` — returns title, description, and recent comments in a single call

2. **Mark as In Progress and self-assign:**
   - `npx @schpet/linear-cli issue update <issue-id> --state "In Progress" --assignee self`
   - If the issue is already `In Review`, `Done`, or `Canceled`, skip the state update and tell the user the current state — don't regress it. This typically means `/linear start` is being re-run to dogfood, inspect context, or pick up review-feedback work; the user confirms whether to transition back to `In Progress`.

3. **Create Mission Task:**
   - `TaskCreate`:
     - `subject`: `[L-1550] Issue title`
     - `description`: issue description (condense if long), followed by a `## Recent updates` section containing the most recent collaborator comments (see composition rules below)
     - `metadata.linear_id`: issue identifier
   - Immediately set status: `in_progress`
   - Recent updates composition:
     - Use up to 5 most recent entries from `comments.nodes[]`, ordered oldest → newest so the latest update sits at the bottom
     - Format each entry as `### {user.displayName} — {YYYY-MM-DD}` followed by the comment body (condense if long)
     - Skip comments where `externalUser` is non-null (GitHub / integration sync noise) or the body is obviously auto-generated (attachment uploads, "opened a PR" webhook posts)
     - Omit the section entirely if no qualifying comments remain

4. **Output branch commands:**
   - `gh api user --jq .login` — get GitHub username
   - Branch: `{github-username}/{lowercase-id}-{sanitized-title}` — branch names must use English, stay readable, and make sure the derived worktree folder name stays within 50 characters
   - Two commands for user to copy:
     - `git checkout main && git pull && git checkout -b {branch-name}`
     - Worktree:
       - `wt_name` = `{base}--{branch-name with / replaced by -}`
       - `git worktree add -b {branch-name} ../{wt_name} && cd ../{wt_name} && cp ../${base}/config/master.key config/master.key && yarn install`

### Progress sync during work

- When there is a meaningful milestone, add a Linear comment immediately instead of waiting for `/linear done`.
- Good examples: scope changes, upstream docs sync, a completed implementation slice, validation results, or rollout notes.
- Summarize what changed, why it matters, and any decision, risk, or next step.
- Do not include local-only paths, local database details such as internal task IDs or billing fields, or raw evidence dumps.

### /linear done

Sync the current work back to Linear, add branch and PR context, link the PR, and close the issue only when appropriate.

1. **Detect issue ID** from branch name or current Mission Task's `metadata.linear_id`

2. **Collect git info:**
   - `git branch --show-current`
   - `gh pr view --json url,state,isDraft,mergedAt -q ...` (if PR exists)

3. **Update Linear:**
   - Write the sync note to a temp file and use `npx @schpet/linear-cli issue comment add <issue-id> --body-file <temp-file>` — summarize the completed work and include branch and PR URL
   - If PR exists: `npx @schpet/linear-cli issue link <issue-id> <pr-url>`
   - Mark the issue done only if the PR is merged or the work is clearly complete
   - Keep the issue open when the PR is still open or draft
   - Do not close the issue just because a PR exists

4. **Complete Mission Task:**
   - Set `TaskUpdate` status to `completed` when the current coding task is done, even if the Linear issue stays open for review or merge

### /linear view

Show the current issue details.

1. **Detect issue ID** from branch name or current Mission Task's `metadata.linear_id`
2. `npx @schpet/linear-cli issue view <issue-id> --json`

### /linear status

Show active Mission Tasks.

1. `TaskList` — filter tasks that have `metadata.linear_id`
2. Display: issue ID, title, current status

## Tips

- Sub-tasks the agent creates during work are session-local — they don't sync to Linear
- For faster startup, install globally: `npm install -g @schpet/linear-cli`. The `linear` command starts in ~0.2s vs ~1.5s with `npx`.
