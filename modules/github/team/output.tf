output "team_ids" {
  value = { for k, v in github_team.this : k => v.id }
}

output "team_slugs" {
  value = { for k, v in github_team.this : k => v.slug }
}
