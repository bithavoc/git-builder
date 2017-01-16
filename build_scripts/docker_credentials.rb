class DockerCredentials
  attr_reader :username, :password
  def initialize(username:, password:)
    @username = username
    @password = password
  end

  def self.environment
    new(username: ENV['DOCKER_USER'], password: ENV['DOCKER_PASS'])
  end

  def can_login?
    username && password
  end

  def login!
    abort("Failed to login with username #{username}") unless system("docker login -u #{username} -p #{password}")
  end
end
