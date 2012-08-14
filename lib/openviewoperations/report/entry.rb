require 'striuct'

module OpenViewOperations; class Report

  Entry = Striuct.define do
    member :dupulication, BOOLEAN?
    member :time, Time
    member :auto_action_status, Symbol
    member :operator_action_status, Symbol
    member :severity, Symbol
    member :group, Symbol
    member :node, Symbol
    member :source_type, Symbol
    member :text, String
    member :original_text, String
    member :generated_node, Symbol
    member :service, Symbol
    member :last_recieved, OR(Time, nil)
    member :description, OR(String, nil)
    member :annotation, OR(String, nil)
  end

end; end
