require 'dnsdiff/logging'
require 'dnsdiff/differ'
require 'colorize'

module DNSDiff
  class CommandException < Exception
  end

  class Command
    def self.diff(options)
      file = options[:file]
      record = options[:record]
      type = options[:type]

      differ = DNSDiff::Differ.new(options[:primary_dns], options[:secondary_dns])
      if record && type
      	differ.diff([{ :name => record, :type => type }])
      else
      	differ.diff(file_to_query_list(file))
      end
    end

    def self.file_to_query_list(file)
      query_list = []
      File.open(file, "r").each_line do |line|
        query_fields = line.split
      	query_list << { :name => query_fields[0], :type => query_fields[1] }
      end
      query_list
    end
  end
end
