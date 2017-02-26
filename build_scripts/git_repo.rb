require_relative 'git_path'
require_relative 'ssh_key'
require_relative 'cloned_repo'

class GitRepo
  attr_accessor :ssh_key
  attr_reader :path

  def initialize(path:)
    @path = path
  end

  def clone!(to:)
    if path.ssh?
      ssh_key.install! if ssh_key&.found?
      SshKey.scan_public_key!(hostname: path.hostname)
    end
    abort('Unable to clone repo') unless system("git clone #{path.clone_param} #{to}")
    ClonedRepo.new(path: to)
  end

  def hostname
    uri.host
  end

  def protocol
    uri.scheme
  end

  def self.environment!
    git_repo = ENV['GIT_REPO']
    abort('GIT_REPO env missing') unless git_repo
    new(path: GitPath.new(git_repo))
  end
end
