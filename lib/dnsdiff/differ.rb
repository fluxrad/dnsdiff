require 'dnsruby'
require 'colorize'

module DNSDiff
  class Differ
    include Logging

    attr_accessor :ns1, :ns2, :file, :record, :type

    def initialize(ns1, ns2)
      @resolvers = {
        :source => Dnsruby::Resolver.new(:nameserver => ns1),
        :dest   => Dnsruby::Resolver.new(:nameserver => ns2)
      }
    end

    def colors
      { :Pass => :green,
        :Fail => :red
      }
    end

    # Diff a list of records, in hash format.
    # [{ :name => 'returnpath.com', :type => 'A'}]
    def diff(query_list)
      logger.debug "diffing query list"
      logger.debug "#{query_list}"

      diff_result = true
      query_list.each do |query|
        result = diff_one(query)
        if result == false
          diff_result = result
        end
      end
      diff_result
    end

    # Diff a single record
    def diff_one(query)
      logger.debug "Diffing query: #{query}"
      responses = []
      @resolvers.each do |name, ns|
        response = ns.query(query[:name], Dnsruby::Types.send(query[:type]))

        query[:from] = response.answerfrom
        # When we get multiple records back, they may not be sorted. Sort them.
        query[:response] = response.answer.sort.map { |answer| answer.rdata_to_string }

        logger.debug "Got response:"
        logger.debug "#{query}"
        responses << query
      end
      print_diff(responses)
      diff_pass?(responses)
    end

    def diff_pass?(responses)
      responses[0][:response] == responses[1][:response]
    end

    def print_diff(responses)
      first_response = responses[0]
      second_response = responses[1]

      test_result = diff_pass?(responses) ? "Pass" : "Fail"

      print "QUERY: #{first_response[:name].upcase} #{first_response[:type]}\n".colorize(:white)
      print "RESULT: #{test_result.to_s}\n".colorize(colors[test_result.to_sym])
      print "\tNS1: #{first_response[:response]}\n"
      print "\tNS2: #{second_response[:response]}\n"
    end
  end
end

require_relative './logging'
