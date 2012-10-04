require_relative 'helper'

TEST_IO.rewind

The OpenViewOperations::Report.for_io(TEST_IO) do |report|

  a OpenViewOperations::Report
  
  The report.time do
    is Time.local(2099, 12, 31, 11, 23, 45)
  end
  
  The report.entries do |entries|
    
    a Array
    
    The entries.length do
      is 2
    end
    
    The entries[0] do |e1|

      a OpenViewOperations::Report::Entry
      
      The e1.dupulication do
        EQUAL true
      end
      
      The e1.time do
        is Time.local(2099, 12, 31, 1, 2, 3)
      end
      
      The e1.auto_action_status do
        is :started
      end
      
      The e1.operator_action_status do
        is :undef
      end
      
      The e1.severity do
        is :crit
      end
      
      The e1.group do
        is :MG
      end
      
      The e1.node do
        is :'www.foooooooo.example.com'
      end
      
      The e1.text do
        is 'foooooooooooooooooooooooooooooooooooooooooooooooooobar.'
      end
      
    end
    
    The entries[1] do |e2|

      a OpenViewOperations::Report::Entry
      
      The e2.dupulication do
        EQUAL true
      end
      
      The e2.time do
        is Time.local(2099, 12, 31, 11, 22, 33)
      end
      
      The e2.auto_action_status do
        is :finished
      end
      
      The e2.operator_action_status do
        is :undef
      end
      
      The e2.severity do
        is :norm
      end
      
      The e2.group do
        is :FOOOOO
      end
      
      The e2.node do
        is :'www.bar.example.com'
      end
      
      The e2.text do
        is 'fooooooooooooooooooooooooooooooooooooooooooooobarrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrhoge.'
      end
      
    end
  
  end

end