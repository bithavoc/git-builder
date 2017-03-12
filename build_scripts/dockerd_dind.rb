require_relative 'dockerd'
require 'thread'

class DockerdDind < Dockerd
  def initialize
    @mutex = Mutex.new
  end

  def check(wait_seconds: 60)
    puts 'Waiting for dockerd...'
    @dockerd_thread = Thread.new(&method(:boot))
    wait(seconds: wait_seconds)
  end

  private

  def boot
    success, output = IO.popen(['dockerd', '--insecure-registry', 'myregistrydomain.com:5000', '--experimental', err: [:child, :out]]) do |io|
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
end
