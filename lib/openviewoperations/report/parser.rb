require 'forwardable'
require 'strscan'

module OpenViewOperations; class Report

  class Parser

    extend Forwardable
    private_class_method(*Forwardable.instance_methods(false))
    
    class MalformedSourceError < StandardError; end

    DATE_FORMAT = %r!\d{2}/\d{2}/\d{2}!.freeze
    TIME_FORMAT = '\d{2}:\d{2}:\d{2}'.freeze
    ENTRY_INDENT = (' ' * 15).freeze
    
    private_constant :MalformedSourceError, :DATE_FORMAT, :TIME_FORMAT,
                     :ENTRY_INDENT
    
    def initialize(str)
      @scanner = StringScanner.new(trim_page_headers(str))
      @entries, @time = [], nil
    end
    
    # @return [Report]
    def parse
      parse_report_header
      trim_parameter_description
      trim_blank
      parse_entries
      trim_blank
      eos? ? Report.new(@entries, @time) : error('Rest is.')
    end
    
    # @return [String]
    def inspect
      [ "Scanner: #{@scanner.inspect}",
        "Rest: \n#{rest[0..400].inspect}",
      ].join("\n")
    end

    delegate_methods_to_scanner = [:scan, :scan_until, :eos?, :rest, :terminate]
    def_delegators :@scanner, *delegate_methods_to_scanner
    private(*delegate_methods_to_scanner)

    private
    
    def trim_blank
      scan(/\n+/)
    end
    
    def trim_page_headers(str)
      str.gsub(self.class::PAGE_HEADER_PATTERN){''}
    end

    def parse_report_header
      trim_ignore_line = ->{scan(/^#.*\n/) || error}
      3.times{trim_ignore_line.call}
      scan(self.class::REPORT_HEADER_PATTERN) || error
      @time = parse_datetime @scanner[1], @scanner[2]
      6.times{trim_ignore_line.call}  
      scan(/\n/)
    end

    def trim_parameter_description
      scan(self.class::PARAMETER_DESCRIPTION_PATTERN) || error
    end

    def parse_entries
      while entry = parse_entry
        @entries << entry
        trim_blank
      end
    end

    def parse_entry
      entry = Entry.new
      parse_entry_header(entry) && entry.tap{|e|parse_entry_body(e)}
    end
    
    def parse_entry_header(entry)
      if scan(%r!^(?: *(\w+))? +(#{DATE_FORMAT}) (#{TIME_FORMAT}) +(\S+) +(\S+) +(\S+) +(\S+) +(\S+)\n(\S+)?!o)
        entry.dupulication = @scanner[1] ? true : false
        time = parse_datetime @scanner[2], @scanner[3]
        entry.time = time
        entry.auto_action_status = @scanner[4].to_sym
        entry.operator_action_status = @scanner[5].to_sym
        entry.severity = @scanner[6].to_sym
        entry.group = @scanner[7].to_sym
        entry.node = (@scanner[8] + @scanner[9].to_s).to_sym
      end
    end
    
    def parse_entry_body_field(name, must=true)
      if scan(/^#{ENTRY_INDENT}#{name} *: (.*)\n/)
        @scanner[1].tap {|r|
          r << "\n" if @scanner[1].length == 54

          while scan(/^#{ENTRY_INDENT * 2}(?:(.{1,54}) ?)?\n/)
            if @scanner[1]
              r << @scanner[1]
              r << "\n" if @scanner[1].length == 54
            end
          end
        }
      else
        error if must
      end
    end
    
    def entry_body_symbol_for(method_name)
      suffix = method_name.slice(/\Aparse_entry_body_(.+)/, 1).to_sym
      self.class::ENTRIY_BODIES.fetch(suffix)
    end
    
    def parse_entry_body_source_type
      r = parse_entry_body_field(entry_body_symbol_for __callee__).to_sym
      trim_blank
      r
    end
    
    def parse_entry_body_text
      parse_entry_body_field(entry_body_symbol_for __callee__)
    end
    
    def parse_entry_body_original_text
      parse_entry_body_field(entry_body_symbol_for __callee__)
    end

    def parse_entry_body_generated_node
      parse_entry_body_field(entry_body_symbol_for __callee__).to_sym
    end

    def parse_entry_body_service
      r = parse_entry_body_field(entry_body_symbol_for __callee__).to_sym
      scan(/^#{ENTRY_INDENT * 2}\n/)
      r
    end

    def parse_entry_body_last_recieved
      parse_entry_body_field(entry_body_symbol_for(__callee__), false)
    end

    def parse_entry_body_annotation
      parse_entry_body_field(entry_body_symbol_for(__callee__), false)
    end

    def parse_entry_body_description
      parse_entry_body_field(entry_body_symbol_for(__callee__), false)
    end
    
    def error(message=nil)
      raise MalformedSourceError, "#{message}\n#{inspect}", (caller.shift; caller)
    end

  end

end; end