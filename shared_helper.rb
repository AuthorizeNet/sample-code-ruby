require 'logger'
require 'yaml'

module SharedHelper
  def config
    $credentials ||= YAML.load_file(__dir__ + "/credentials.yml")
  rescue Errno::ENOENT
    warn "WARNING: Running w/o valid AuthorizeNet sandbox credentials. Create spec/credentials.yml."
  end

  def logger
    @logger ||= Logger.new(STDOUT).tap { |logger| logger.level = Logger.const_get(ENV['LOGLEVEL'] || 'INFO') }
  end
end

include SharedHelper
