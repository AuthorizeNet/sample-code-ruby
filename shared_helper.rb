module SharedHelper
  def config
    $credentials ||= YAML.load_file(__dir__ + "/credentials.yml")
  rescue Errno::ENOENT
    warn "WARNING: Running w/o valid AuthorizeNet sandbox credentials. Create spec/credentials.yml."
  end
end