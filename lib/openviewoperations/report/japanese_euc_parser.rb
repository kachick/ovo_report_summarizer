# coding: EUC-JP

require_relative 'parser'

module OpenViewOperations; class Report

  class Japanese_EUC_Parser < Parser

    PAGE_HEADER_PATTERN = %r!����(?:����)?��å����� �ܺ� +�ڡ���: *(\d+)\n\n��ʣ  ����/����         Auto���� Oper���� Sev\. ��å�����Grp    �Ρ���̾\n[- ]+\n\n!
    
    REPORT_HEADER_PATTERN = %r!\# ��ݡ�����: (#{DATE_FORMAT})                                  ��ݡ��Ȼ���: (#{TIME_FORMAT})\n!o
    

    PARAMETER_DESCRIPTION_PATTERN = /^�إå�������:.+?\n{3}/m
    
    ENTRIY_BODIES = {
      source_type: :'��������������',
      text: :'��å�����',
      original_text: :'���ꥸ�ʥ�',
      generated_node: :'Msg.�����Ρ���',
      service: :'�����ӥ�̾',
      last_recieved: :'�ǽ���������',
      annotation: :'���',
      description: :'�ؼ�'
    }.freeze

    def parse_datetime(date_str, time_str)
      year, mon, day = *date_str.split('/')
      year, mon, day = "20#{year}".to_i, mon.to_i, day.to_i
      hour, min, sec = *time_str.split(':').map(&:to_i)
      Time.local year, mon, day, hour, min, sec
    end
    
    def parse_entry_body(entry)
      entry.source_type = parse_entry_body_source_type
      trim_blank
      
      %w[text original_text generated_node
         service last_recieved description annotation].each do |name|
        entry[name] = __send__(:"parse_entry_body_#{name}")
      end
    end

  end

end; end
