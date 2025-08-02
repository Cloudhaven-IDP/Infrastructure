resource "github_team" "this" {
  for_each = { for team in var.teams : team.name => team }

  name           = each.value.name
  description    = each.value.description
  privacy        = each.value.privacy
  parent_team_id = each.value.parent_team_id
}
