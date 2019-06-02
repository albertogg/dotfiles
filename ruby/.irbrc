require "irb/completion"
require "pp"

# history file
IRB.conf[:EVAL_HISTORY] = 1000
IRB.conf[:SAVE_HISTORY] = 1000

# auto indent code
IRB.conf[:AUTO_INDENT]=true
