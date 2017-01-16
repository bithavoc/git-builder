class DockerCredentials
  attr_reader :username, :password, :endpoint
  def initialize(username:, password:, endpoint: nil)
    @username = username
    @password = password
    @endpoint = endpoint
  end

  def self.environment
    new(username: ENV['DOCKER_USER'], password: ENV['DOCKER_PASS'], endpoint: ENV['DOCKER_ENDPOINT'])
  end

  def can_login?
    username && password
  end

  def login!
    abort("Failed to login with username #{username}") unless system("docker login -u #{username} -p #{password} #{endpoint}")
  end
end
