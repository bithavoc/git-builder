require 'uri'

class GitPath
  attr_reader :uri
  def initialize(path)
    try_parse_uri(path)
  end

  def clone_param
    uri.to_s
  end

  def ssh?
    uri.scheme == 'ssh'
  end

  def hostname
    uri.host
  end

  private

  def try_parse_uri(path)
    @uri = URI(path)
  rescue URI::InvalidURIError
    @uri = convert_scp_to_ssh_uri(path)
  end

  def convert_scp_to_ssh_uri(path)
    URI("ssh://#{path.sub(':', '/')}")
  end
end
