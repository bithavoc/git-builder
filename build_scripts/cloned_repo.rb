class ClonedRepo
  attr_reader :path
  def initialize(path:)
    @path = path
  end

  def checkout!(ref:)
    abort("Unable to switch to #{ref}") unless system("cd #{path} && git checkout #{ref}")
  end
end
