# coding: EUC-JP

require_relative 'parser'

module OpenViewOperations; class Report

  class Japanese_EUC_Parser < Parser

    PAGE_HEADER_PATTERN = %r!選択(?:履歴)?メッセージ 詳細 +ページ: *(\d+)\n\n重複  日付/時刻         Auto状態 Oper状態 Sev\. メッセージGrp    ノード名\n[- ]+\n\n!
    
    REPORT_HEADER_PATTERN = %r!\# レポート日: (#{DATE_FORMAT})                                  レポート時刻: (#{TIME_FORMAT})\n!o
    

    PARAMETER_DESCRIPTION_PATTERN = /^ヘッダの説明:.+?\n{3}/m
    
    ENTRIY_BODIES = {
      source_type: :'ソース・タイプ',
      text: :'メッセージ',
      original_text: :'オリジナル',
      generated_node: :'Msg.生成ノード',
      service: :'サービス名',
      last_recieved: :'最終受信時刻',
      annotation: :'注釈',
      description: :'指示'
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
