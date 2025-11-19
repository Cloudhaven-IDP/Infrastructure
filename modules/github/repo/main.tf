resource "github_repository" "this" {
  name                   = var.name
  description            = var.description
  visibility             = var.visibility
  auto_init              = true
  delete_branch_on_merge = true

  lifecycle {
    ignore_changes = [
      auto_init,
      homepage_url,
      description,
      has_issues,
      has_downloads,
      has_discussions,
      has_wiki,
      has_projects,
      topics,
      vulnerability_alerts,
      pages,
      template,
    ]
  }
}

resource "github_branch" "this" {
  repository = github_repository.this.name
  branch     = var.default_branch

  depends_on = [github_repository.this]
}

resource "github_branch_default" "this" {
  count      = var.default_branch == "main" ? 1 : 0
  repository = github_repository.this.name
  branch     = var.default_branch

  depends_on = [github_branch.this]
}

resource "github_repository_file" "codeowners" {
  count               = var.create_codeowners ? 1 : 0
  repository          = github_repository.this.name
  file                = ".github/CODEOWNERS"
  branch              = var.default_branch
  overwrite_on_create = true

  content = templatefile("${path.module}/codeowners.tmpl", {
    reviewer_teams = var.reviewer_teams
  })

  commit_message = "Add CODEOWNERS file"

  lifecycle {
    ignore_changes = [content]
  }

  depends_on = [github_repository.this]
}

resource "github_team_repository" "team_access" {
  for_each   = { for t in var.teams : t.id => t }
  team_id    = each.value.id
  repository = github_repository.this.name
  permission = each.value.permission

  depends_on = [github_repository.this]
}
