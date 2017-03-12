require_relative 'dockerd_dind'
require_relative 'dockerd_sock'

class DockerdSelector
  MODE_DIND = 'dind'.freeze
  MODE_SOCK = 'sock'.freeze
  DEFAULT_DOCKERD_MODE = MODE_DIND
  def check
    backend_class = modes_backends[env_mode]
    abort("Invalid DOCKERD_MODE #{env_mode}, options are: #{modes_backends.keys.join(', ')}") unless backend_class
    instance = backend_class.new
    instance.check
  end

  private

  def modes_backends
    {
      MODE_DIND => DockerdDind,
      MODE_SOCK => DockerdSock
    }
  end

  def env_mode
    ENV['DOCKERD_MODE'] || DEFAULT_DOCKERD_MODE
  end
end
