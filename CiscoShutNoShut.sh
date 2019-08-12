 #!/usr/bin/expect -f
####################
# This script reset a port from a switch
# ciscoShutNoshut 192.168.80.8 gi1/0/2 "SwitchPassword"
# History:
#-----------------------------
# 2019-06-21 - Gael Langlais - Creation
# 2019-08-12 - Gael Langlais - Fix First time login error
####################

# Set variables
set ip [lindex $argv 0]
set interface [lindex $argv 1]
set enablePassword [lindex $argv 2]
set timeout 10

spawn ssh Manager@$ip
expect {
"*connecting (yes/no)?"
    {
        send "yes\n"
        expect "*assword:"
        send "$enablePassword\n"
    }
"*assword:"
        {
                send "$enablePassword\n"
        }
}

# switch to enable mode
expect "*>"
send "en\n"
expect "*assword:"
send "$enablePassword\n"
expect "*#"

# Select the interface to reset
send "conf t\n"
expect "*(config)#"
send "int $interface\n"
expect "*(config-if)#"
send "shut\n"
expect "*#"
sleep 3
send "no shut\n"
expect "*#"
send "exit\r"
