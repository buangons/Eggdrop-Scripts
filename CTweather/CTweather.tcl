###########################################################
# CT-Weather                                              #
###########################################################
# Author:  ComputerTech                                   #
# Email:   ComputerTech312@Gmail.com                      #
# Github:  https://github.com/computertech312             #
# Version: 0.1                                            #
# Release: 06/04/2021                                     #
###########################################################
# Description:                                            #
#                                                         #
#              - A Weather script which uses the          #
#                OpenWeathermap API Key.                  #
#              - https://openweathermap.org/api           #
#                                                         #
# History:                                                #
#                                                         #
#               - 0.1: First release.                     #
#                                                         #
###########################################################
namespace eval ctweather {
   ##########################
   # Start of configuration #
   ##########################

   ##########################
   # Trigger
   ###
   variable ::trig "!w"


   ##########################
   # Flags
   ###
   # Owner     = n
   # Master    = m
   # Op        = o
   # Voice     = v
   # Friend    = f
   # Everyone  = -
   ##
   variable ::flag "-"


   ##########################
   # API Key
   ###
   variable ::api "Your-API-Key"

   variable ::met "0"

   package require json
   package require tls
   package require http

   bind PUB $::flag $::trig [namespace current]::weather:call

   proc weather:call {nick host hand chan text} {
      http::register https 443 [list ::tls::socket]
      switch -- $::met {
         "0" {variable metr "metric"
            variable met2 "C"
            variable met3 "mph"}
         "1" {variable metr "imperial"
            variable met2 "F"
            variable met3 "kmph"}
      }

if { [string length [lindex [split $text] end]] == 2 } {

      set text [regsub { ([^ ]+)$} $text {,\1}]
}
variable url "http://api.openweathermap.org/data/2.5/weather"
variable params [::http::formatQuery q $text units metric APPID $::api]
putlog "$url?$params"
variable data [http::data [http::geturl "$url?$params" -timeout 10000]]
      http::cleanup $data
      http::unregister https
      variable data2 [::json::json2dict $data]
      variable cod [dict get $data2 "cod"]

      if {$cod == "404"} {
         putserv "PRIVMSG $chan \00304Page not found, be more specific\003"
      }
      if {$cod == "200"} {
         variable name [dict get $data2 "name"]
         variable sys [dict get $data2 "sys"]
         variable country [dict get $sys "country"]
         variable main [dict get $data2 "main"]
         variable temp [dict get $main "temp"]
         variable humidity [dict get $main "humidity"]
         variable wind [dict get $data2 "wind"]
         variable speed [dict get $wind "speed"]
         variable weather2 [dict get $data2 "weather"]
         variable current [dict get [lindex [dict get $data2 weather] 0] description]
         variable name   [encoding convertfrom utf-8 $name]
         putserv "PRIVMSG $chan :\[\00309Weather\003\] ${name}, $country | ${temp}$met2 | ${speed}$met3 | $current | ${humidity}%"
      }
   }
}

###########################################################
