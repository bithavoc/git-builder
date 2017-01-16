require_relative 'dockerd_process'
require_relative 'docker_credentials'
require_relative 'ssh_key'
require_relative 'git_repo'
require_relative 'docker_tag'

REPO_DIR = 'repo'.freeze

$stdout.sync = true

dockerd = DockerdProcess.new
abort('dockerd failure') unless dockerd.start

repo = GitRepo.environment!
repo.ssh_key = SshKey.environment
repo.clone!(to: REPO_DIR)

tag = DockerTag.environment!
tag.registry_credentials = DockerCredentials.environment
tag.build!(from: REPO_DIR)
tag.push!
puts "#{tag.name} has been pushed successfully"
