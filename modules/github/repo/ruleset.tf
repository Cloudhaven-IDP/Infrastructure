resource "github_repository_ruleset" "main_branch_protection" {
  name        = "Main Branch Protection"
  repository  = github_repository.this.name
  target      = "branch"
  enforcement = "active"

  dynamic "bypass_actors" {
    for_each = var.bypass_actors

    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = "always"
    }
  }

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    pull_request {
      required_approving_review_count = 1
      dismiss_stale_reviews_on_push   = true
      require_code_owner_review       = true
      require_last_push_approval      = true
    }
  }

  depends_on = [github_repository.this, github_repository_file.codeowners]
}
