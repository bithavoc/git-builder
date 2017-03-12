class DockerdSock < Dockerd
  def check
    puts 'Checking for dockerd sock...'
    abort('/var/run/docker.sock does not exists, make sure you mount git-builder with "-v /var/run/docker.sock:/var/run/docker.sock"') unless File.exist?('/var/run/docker.sock')
    abort('Docker is not running in your host') unless dockerd_running?
    true
  end
end
