require 'dnsruby'
require 'colorize'

require_relative './logging'

module DNSDiff
  class Query
    include Logging

    attr_accessor :record, :type

    def initialize(opts)
      @record = opts[:record]
      @type   = opts[:type]
    end

    def colors
      { :Pass => :green, :Fail => :red }
    end

    def responses_equal?
      @responses.all? { |x| x == @responses[0] }
    end

    def print_response
      @result = self.responses_equal? ? :Pass : :Fail

      print "QUERY: #{@record.upcase} #{@type.upcase}\n"
      print "STATUS: #{@result}\n".colorize(colors[@result])
      @responses.each do |response|
        print "  "
        print "#{response.short_answer}"
        print "\n"
      end
      print "==========================================\n"

      self
    end

    # execute requires an associated resolver so we're not constantly
    # opening and closing dns connections.
    def execute(resolvers)
      @responses = []

      resolvers.each do |name, resolver|
        response = Response.new(:name => name)
        begin
          message = resolver.query(@record, Dnsruby::Types.send(@type))
      	  response.parse_message(message)
        rescue Dnsruby::NXDomain
          response.answertext = "NXDOMAIN"
        end
        @responses << response
      end
    end

    def to_s
      # something clever here
    end
  end
end

