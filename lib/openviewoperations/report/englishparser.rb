require_relative 'parser'

module OpenViewOperations; class Report

  class EnglishParser < Parser

    PAGE_HEADER_PATTERN = %r!Selected (active|history) +Page: *(\d+)\n\nDup\.  Date/Time +Auto St\. Oper St\. Sev\. Message Group +Node Name\n[- ]+\n\n!
    
    REPORT_HEADER_PATTERN = %r!\# Report Date: (#{DATE_FORMAT}) +Report Time: (#{TIME_FORMAT})\n!o
    

    PARAMETER_DESCRIPTION_PATTERN = /^Legend of used head lines:.+?\n{3}/m
    
    ENTRIY_BODIES = {
      text: :'Message Text',
    }.freeze

    def parse_datetime(date_str, time_str)
      mon, day, year = *date_str.split('/')
      year, mon, day = "20#{year}".to_i, mon.to_i, day.to_i
      hour, min, sec = *time_str.split(':').map(&:to_i)
      Time.local year, mon, day, hour, min, sec
    end
    
    def parse_entry_body(entry)
      trim_blank
      
      %w[text].each do |name|
        entry[name] = __send__(:"parse_entry_body_#{name}")
      end
    end

  end

end; end
