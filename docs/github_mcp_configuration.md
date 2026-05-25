# GitHub MCP Server Configuration

## Overview

This project uses the **official GitHub MCP Server** (`github/github-mcp-server`) via Docker to enable AI-assisted GitHub operations, including repository management, issue tracking, pull requests, and **GitHub Projects**.

## Why the Official Server?

The legacy npm package `@modelcontextprotocol/server-github` was discontinued in April 2025 and only exposed 26 basic tools. The official Docker image exposes **87+ tools** including:

- **Projects**: `projects_list`, `projects_get`, `projects_write`
- **Actions**: `actions_get`, `actions_list`, `actions_run_trigger`
- **Discussions**: `get_discussion`, `list_discussions`
- **Gists**: `create_gist`, `list_gists`, `update_gist`
- **Notifications**: `list_notifications`, `mark_all_notifications_read`
- **Security**: `list_code_scanning_alerts`, `list_dependabot_alerts`

## Prerequisites

1. **Docker Desktop** installed and running
2. **GitHub Personal Access Token (PAT)** with the following scopes:
   - `repo` — Repository operations
   - `project` — GitHub Projects access
   - `read:org` — Organization team access
   - `read:packages` — Docker image access (if needed)

## Configuration

### File Location

```
C:\Users\Andres\AppData\Roaming\Qoder\SharedClientCache\mcp.json
```

### Recommended Configuration

```json
{
  "mcpServers": {
    "github-epsa-acunarro": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "GITHUB_PERSONAL_ACCESS_TOKEN",
        "-e",
        "GITHUB_TOOLSETS=all",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<YOUR_EPSA_PAT_HERE>",
        "GITHUB_TOOLSETS": "all"
      }
    },
    "github-datouy-acunarro": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "GITHUB_PERSONAL_ACCESS_TOKEN",
        "-e",
        "GITHUB_TOOLSETS=all",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<YOUR_DATOUY_PAT_HERE>",
        "GITHUB_TOOLSETS": "all"
      }
    }
  }
}
```

### Critical: Docker Args Syntax

Each environment variable passed to Docker **must** be preceded by `-e`:

```json
// Correct
"-e", "GITHUB_PERSONAL_ACCESS_TOKEN",
"-e", "GITHUB_TOOLSETS=all",

// Incorrect — Docker will fail to start
"GITHUB_TOOLSETS=all",
```

## Toolsets

By default, the GitHub MCP Server only exposes basic toolsets (`repos`, `issues`, `pull_requests`, `users`, `code_security`, `experiments`). To access **Projects**, **Actions**, **Discussions**, and other advanced features, you **must** set:

```json
"GITHUB_TOOLSETS": "all"
```

Available toolset values:
- `repos` — Repository operations
- `issues` — Issue management
- `pull_requests` — PR operations
- `users` — User-related queries
- `code_security` — Security alerts and scanning
- `experiments` — Experimental features
- `all` — **Enable everything** (recommended)

## Updating the Server

When GitHub releases a new version:

```bash
docker pull ghcr.io/github/github-mcp-server:latest
```

Then reload Qoder. No changes to `mcp.json` are required.

## Verifying the Connection

After reloading Qoder, the `github-epsa-acunarro` server should expose **87 tools**. Test with:

```json
{
  "method": "list_projects",
  "owner": "acunarro-epsa"
}
```

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| Server not appearing in Qoder | Missing `-e` before env var in Docker args | Add `-e` before each environment variable |
| Only 40 tools exposed (no Projects) | `GITHUB_TOOLSETS=all` not set | Add the environment variable and reload |
| Docker pull fails | Docker Desktop not running | Start Docker Desktop |
| "missing required parameter: method" | Projects tools require a `method` field | Pass `"method": "list_projects"` (or `list_project_fields`, `list_project_items`) |

## Related Documentation

- [Official GitHub MCP Server](https://github.com/github/github-mcp-server)
- [GitHub Projects API](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
