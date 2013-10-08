require 'colorize'
require 'dnsruby'

require_relative './logging'

module DNSDiff
  class Response
    include Logging

    attr_accessor :name, :answertext, :answerfrom, :record, :type

    def initialize(opts)
      @name       = opts[:name]
    end

    def parse_message(message)
      @answertext = message.answer.sort.map { |answer| answer.rdata_to_string }
      @record     = message.question[0].qname.to_s
      @type       = message.question[0].qtype.to_s
      @answerfrom = message.answerfrom
    end

    def short_answer
      "#{@name} => #{@answertext[0]}"
    end

    def to_s
      { :name       => @name,
        :answertext => @answertext,
        :answerfrom => @answerfrom,
        :record     => @record,
        :type       => @type
      }.to_s
    end

    #def print_response
    #  print "Query : #{@record.upcase} #{@type.upcase}\n"
    #  print "Result: ---\n"
    #  print @record
    #  print @answerfrom

    #  self
    #end

    def ==(other_response)
      logger.debug "Checking #{@answertext} against #{other_response.answertext}\n"
      @answertext == other_response.answertext
    end
  end
end
