require 'csv'
require 'logger'
require 'lettercase'
require 'lettercase/core_ext'
require_relative 'openviewoperations/report'

class Time

  remove_method :to_s
  
  def to_s
    strftime "%Y/%m/%d %H:%M:%S"
  end
  
  def to_path_suffix
    strftime "%Y-%m-%d_%H%M"
  end

end

module OVO_Report_Summarizer

  extend OpenViewOperations

  class << self
    
    def run
      title = Report::Entry.members.map(&:pascalcase)
      error_occured = false
      
      unless ARGV.length >= 1
        abort "usage: #{$PROGRAM_NAME} report [*reports]"
      end

      ARGV.each do |path|
        logger = Logger.new "#{path}.summurize.log"
        logger.progname = :'OVOReportSummarizer'

        begin
          report = Report.load path
          output = "#{path}.#{report.time.to_path_suffix}.summary.csv"
          CSV.open output, 'w', headers: title, write_headers: true do |csv|
            report.entries.each do |entry|
              csv << entry
            end
          end
        rescue Exception
          logger.fatal "Error occured\n#{$!.inspect}\n#{$!.backtrace.join("\n")}"
          error_occured = true
        else
          logger.info 'Complete'
        end
      end

      if error_occured
        $stderr.puts "Error Occured.\n--->Check logs.\n(push enter-key)"
      else
        $stderr.puts 'All Completed.'
      end
    end
    
  end

end