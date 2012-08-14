# coding: shift_jis

require_relative 'parser'

module OpenViewOperations; class Report

  class Japanese_SJIS_Parser < Parser

    PAGE_HEADER_PATTERN = %r!�I��(?:����)?���b�Z�[�W �ڍ� +�y�[�W: *(\d+)\n\n�d��  ���t/����         Auto��� Oper��� Sev\. ���b�Z�[�WGrp    �m�[�h��\n[- ]+\n\n!
    
    REPORT_HEADER_PATTERN = %r!\# ���|�[�g��: (#{DATE_FORMAT})                                  ���|�[�g����: (#{TIME_FORMAT})\n!o
    

    PARAMETER_DESCRIPTION_PATTERN = /^�w�b�_�̐���:.+?\n{3}/m
    
    ENTRIY_BODIES = {
      source_type: :'�\�[�X�E�^�C�v',
      text: :'���b�Z�[�W',
      original_text: :'�I���W�i��',
      generated_node: :'Msg.�����m�[�h',
      service: :'�T�[�r�X��',
      last_recieved: :'�ŏI��M����',
      annotation: :'����',
      description: :'�w��'
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
