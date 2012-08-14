require 'nkf'
require_relative 'report/entry'
require_relative 'report/parser'
require_relative 'report/englishparser'
require_relative 'report/japanese_utf8_parser'
require_relative 'report/japanese_euc_parser'
require_relative 'report/japanese_windows31j_parser'
require_relative 'report/japanese_sjis_parser'

module OpenViewOperations

  class Report
    
    PARSERS = {
      NKF::ASCII => EnglishParser,
      NKF::UTF8 => Japanese_UTF8_Parser,
      NKF::EUC => Japanese_EUC_Parser,
      Encoding::WINDOWS_31J => Japanese_Windows31J_Parser,
      NKF::SJIS => Japanese_SJIS_Parser,    
    }.freeze

    class << self
      
      # @param [String] str
      # @return [Report]
      def parse(str)
        encoding = NKF.guess str
        PARSERS.fetch(encoding).new(str).parse
      end
      
      # @param [IO] io
      # @return [Report]
      def for_io(io)       
        parse io.read
      end
      
      # @param [String] path
      # @return [Report]
      def load_file(path)
        open path do |f|
          return for_io f
        end
      end
      
      alias_method :load, :load_file
      
    end

    attr_reader :entries, :time
    
    def initialize(entries, time)
      @entries, @time = entries, time
    end
  
  end

end