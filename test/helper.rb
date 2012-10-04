require 'stringio'
require 'declare/autorun'

$VERBOSE = true

require_relative '../lib/ovo_report_summarizer'

TEST_STRING = <<'EOD'
#                        OVO Report
#                        --- ------
#
# Report Date: 12/31/99                                  Report Time: 11:23:45
#
# Report Definition:
#
#        Report Name    : Selected active 
#        Report Script  : 
#

Legend of used head lines:
   Auto St.:      Status of an automatic action which belongs to the message
   Oper St.:      Status of an operator initiated action
   Sev.:          Severity of the Message
   Message Group: Message Group of the Message
   Node Name:     The Node that message comes from
   Message Text:  Message text of the message



Selected active                                                   Page:      1

Dup.  Date/Time         Auto St. Oper St. Sev. Message Group    Node Name
----- ----------------- -------- -------- ---- ---------------- -------------------

    2 12/31/99 01:02:03 started  undef    crit MG               www.foooooooo.example.co
m
               Message Text : foooooooooooooooooooooooooooooooooooooooooooooooooo
                              bar.
                              

   10 12/31/99 11:22:33 finished undef    norm FOOOOO           www.bar.example.com
               Message Text : fooooooooooooooooooooooooooooooooooooooooooooo
                              barrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
                              hoge.
EOD

TEST_IO = StringIO.new TEST_STRING