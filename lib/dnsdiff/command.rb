module DNSDiff
  class CommandException < Exception
  end

  class Command
    def self.diff(options)
      file   = options[:file]
      record = options[:record]
      type   = options[:type]

      differ = Differ.new(options[:primary_dns], options[:secondary_dns])

      if record && type
        differ.add_query(:record => record, :type => type)
      else
        parse_file(file).each do |q|
          differ.add_query(q)
        end
      end

      differ.execute
      differ.print_responses
    end

    def self.parse_file(file)
      query_list = []

      begin
        File.open(file, "r").each_line do |line|
          fields = line.split
          query_list << { :record => fields[0], :type => fields[1] }
        end
      rescue
        print "Error opening file: #{file}\n"
        raise
      end

      query_list
    end

  end
end

require_relative './differ'
require_relative './query'
require_relative './logging'
