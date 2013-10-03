module DNSDiff
  module Logging
    def logger
      Logging.logger
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
      @logger.level = Logger::WARN
      @logger
    end
  end
end
