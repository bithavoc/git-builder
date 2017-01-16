require 'thread'

class DockerdProcess
  def initialize
    @mutex = Mutex.new
  end

  def start(wait_seconds: 60)
    puts 'Waiting for dockerd...'
    @dockerd_thread = Thread.new(&method(:boot_dockerd))
    wait(seconds: wait_seconds)
  end

  private

  def boot_dockerd
    success, output = IO.popen(['dockerd', err: [:child, :out]]) do |io|
      output = io.read
      io.close
      [$?.success?, output]
    end
    if success
      puts 'Dockerd finished'
    else
      puts "Dockerd failed to boot: #{output}"
    end
    self.booting_stopped = true
  end

  def booting_stopped?
    @mutex.synchronize do
      @booting_stopped
    end
  end

  def booting_stopped=(flag)
    @mutex.synchronize do
      @booting_stopped = flag
    end
  end

  def wait(seconds:)
    n = 0
    while !booting_stopped? && n < seconds
      return true if is_dockerd_running?
      sleep 1
      n += 1
    end
    false
  end

  def is_dockerd_running?
    IO.popen(['docker', 'ps', err: [:child, :out]]) do |io|
      io.read
      io.close
      $?.success?
    end
  end
end
