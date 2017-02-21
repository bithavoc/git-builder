class DockerTag
  attr_reader :name
  attr_accessor :registry_credentials

  def initialize(name)
    @name = name
  end

  def build!(from:)
    install_credentials!
    abort('Failed to build image') unless system("docker build --force-rm --squash -t #{name} #{from}")
  end

  def push!
    install_credentials!
    abort('Failed to push image') unless system("docker push --disable-content-trust #{name}")
  end

  def self.environment!
    tag = ENV['IMAGE_TAG']
    abort('IMAGE_TAG env missing') unless tag
    new(tag)
  end

  private

  def install_credentials!
    @installed_credentials ||= registry_credentials.login! if registry_credentials.can_login?
  end
end
