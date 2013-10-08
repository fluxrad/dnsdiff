require 'colorize'
require 'dnsruby'

require_relative './logging'
require_relative './query'
require_relative './response'

module DNSDiff
  class Differ
    include Logging

    def initialize(ns1, ns2)
      @query_list = []
      @resolvers = {
        :source => Dnsruby::Resolver.new(:nameserver => ns1),
        :dest   => Dnsruby::Resolver.new(:nameserver => ns2)
      }
    end

    def resolvers
      @resolvers ||= {}
    end

    def add_query(query_hash)
      @query_list << Query.new(query_hash)
    end

    def execute
      @query_list.each do |query|
        query.execute(resolvers)
      end
    end

    def print_responses
      @query_list.each do |query|
       	query.print_response
      end
    end

  end
end

