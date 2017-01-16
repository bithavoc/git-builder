require 'base64'

class SshKey
  attr_reader :key
  def initialize(encoded_key:)
    @key = encoded_key
    @key = Base64.decode64(@key) if found?
  end

  def found?
    key
  end

  def install!
    return unless found?
    self.class.ensure_home_path!
    write_key_file(path: self.class.id_rsa_path, content: key)
  end

  def self.environment
    encoded_key = ENV['SSH_KEY']
    return new(encoded_key: encoded_key)
  end

  def self.home_path
    File.join(ENV['HOME'], '.ssh')
  end

  def self.scan_public_key!(hostname:)
    abort("Unable to add public ssh key for #{hostname}") unless system("ssh-keyscan -t rsa #{hostname} >> #{known_hosts_path}")
  end

  def self.ensure_home_path!
    abort('Unable to initialize home ssh dir') unless system("mkdir -p #{home_path}")
  end


  def self.id_rsa_path
    File.join(home_path, 'id_rsa')
  end

  def self.known_hosts_path
    File.join(home_path, 'known_hosts')
  end

  private

  def write_key_file(path:, content:)
    File.open(path, 'w') do |f|
      f.write(content)
      f.flush
      f.chmod(0400)
    end
  end
end
