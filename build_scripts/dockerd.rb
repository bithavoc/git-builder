class Dockerd
  def dockerd_running?
    IO.popen(['docker', 'ps', err: [:child, :out]]) do |io|
      io.read
      io.close
      $?.success?
    end
  end

  def booting_stopped?
    false
  end

  def wait(seconds:)
    n = 0
    while !booting_stopped? && n < seconds
      return true if dockerd_running?
      sleep 1
      n += 1
    end
    false
  end
end
