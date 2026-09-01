## Git Commit Convention

### Title line

The first line is the commit title. It carries no prefix and describes, in a few
words, the purpose of the commit.

### Body

After a blank line, list the detailed changes with one prefix per line:

- **[+]** addition
- **[-]** removal
- **[&]** change, refactor, update
- **[!]** bug fix

One change per line, minimal words. List as many entries as needed — do not omit
changes to keep the message short.

**Example**:

```
Bulk trade operations

[+] BulkAcceptTrades and BulkRejectTrades endpoints
[+] POST /wallets/pending-trades/bulk-accept
[+] BulkTradeResult type with per-trade error handling
[+] 6 unit tests for bulk operations
```

### Rules

- **One logical change per commit.** A commit that both fixes a bug and renames
  a module is two commits.
- **Never commit a broken state on purpose.** Each commit should build.
- **No footers** — no "Generated with", no "Co-Authored-By". Keep commits clean.
- **Never `git add -A` blindly.** Stage the files the change touches, so a stray
  local file, a build artifact or a `.env` cannot ride along.
- **Never amend or force-push a branch someone else may have checked out.**
