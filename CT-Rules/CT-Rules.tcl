######################################################################################
# CT-Rules.tcl
######################################################################################
#Author    ComputerTech
#IRC       Irc.DareNet.Org  #ComputerTech
#Email     ComputerTech@DareNet.Org
#GitHub    https://github.com/computertech312
#Version   0.1
#Released  01/12/2020
######################################################################################
# 
# Description:   - A Script which uses DuckDuckGo's API key to Search.
#
# Commands:     - !rules
#
# Credits:      - Used users throttle code.
#
# History:
#
#               - 0.1: First release.
#
######################################################################################
# Start Of Configuration #
##########################
# Set trigger of the script. 
##
set ctrules(trig) "!"

###################
# Set flag for Commands.
##
# Owner     = n
# Master    = m
# Op        = o
# Voice     = v
# Friend    = f
# Everyone  = -
##
set ctrules(flag) "ofmn"

##################
# Set to use Notice Or Privmsg for Output of Commands
##
# 0 = Notice
# 1 = Privmsg
# 2 = Channel
##
set ctrules(msg) "2"

##################
# Set rules 
##
set ctrules(rules) {
"----------------------------------------------------"
"Rule 1"
"Rule 2"
"Rule 3"
"----------------------------------------------------"
}

##################
# Set throttle( in seconds)
##
set ctrules(sec) "30"


########################
# End Of Configuration #
######################################################################################

proc throttled {id seconds} {
   global throttle
   if {[info exists throttle($id)]&&$throttle($id)>[clock seconds]} {
      set id 1
   } {
      set throttle($id) [expr {[clock seconds]+$seconds}]
      set id 0
   }
}
bind time - ?0* throttledCleanup
proc throttledCleanup args {
   global throttle
   set now [clock seconds]
   foreach {id time} [array get throttle] {
      if {$time<=$now} {unset throttle($id)}
   }
} 
bind pub $ctrules(flag) $ctrules(trig)rules ct:rules

proc ct:rules {nick uhost hand chan text} {
global ctrules throttled
if {[throttled $uhost,$chan $ctrules(sec))]} {return}
switch -- $ctrules(msg) {
        "0" {set ctrules(output) "NOTICE $nick"}
        "1" {set ctrules(output) "PRIVMSG $nick"}
        "2" {set ctrules(output) "PRIVMSG $chan"}
     }
set lines {[foreach line $ctrules(rules)]} 
putserv "$ctrules(output) :$lines" 
}
######################################################################################