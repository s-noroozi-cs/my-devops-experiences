#	define string data group
#	string is bic and value is cn and certificate serial number - hex format
#	for example:
#	1. 
#		string: OwnerA
#		value: CN=owner-a.system.org,serialNumber=be:6b:f4:16:59:55:1f:f9:04:3e:c7:ad:2c:58:93:34:e6
#	2.
#		String: OwnerB
#		value: CN=owner-b.policy.com,serialNumber=be:dc:a7:45:67:c7:c4:80:fa:bb:f5:f1:fa:e3:32:70:67
#



# Local Log Level:
#	Level			Description															Verbosity
#	emerg			Emergency system panic messages										Minimum
#	alert			Serious errors that require administrator intervention				Low
#	crit			Critical errors, including hardware and filesystem failures			Low
#	err				Non-critical, but possibly very important, error messages			Low
#	warning			Warning messages that should at least be logged for review			Medium
#	notice			Messages that contain useful information, but may be ignored		Medium
#	info			Messages that contain useful information, but may be ignored		High
#	debug			Messages that are only necessary for troubleshooting				Maximum





when CLIENTSSL_CLIENTCERT {
    
    # Check if client provided a cert
    if {[SSL::cert 0] eq ""}{
        # Reset the connection
        log local0.warning "Client did not provide Certificate, it rejected."
        reject

    } else {

        set subject_dn [X509::subject [SSL::cert 0]]
        set serialNumber [X509::serial_number [SSL::cert 0]]
        
        regexp {CN=([^,]+)} [X509::subject [SSL::cert 0]] cn
        regexp {O=([^,]+)} [X509::subject [SSL::cert 0]] o
        log local0.debug "Client Certificate fields: $cn, $o, serialNumber=$serialNumber"
      
        set match_cert 0
        
        foreach kv [class get my_cn_list] {
            
            regexp {CN=([^,]+)} [lindex $kv 1] reg_cn
            regexp {serialNumber=([^,]+)} [lindex $kv 1] reg_serial
            
            log local0.debug "registered certificate metadata of [lindex $kv 0] is $reg_cn, $reg_serial"
            
            if { $o contains [lindex $kv 0] } {
                if { $cn equals $reg_cn and "serialNumber=$serialNumber" equals $reg_serial } {
                    set match_cert 1
                    break
                }
            }
            
        }
      
      
        if { $match_cert equals 1 } {
            log local0.notice "accept client certificate"
        } else {
            log local0.warning "No Matching Client Certificate Was Found"
            reject
        }
    }
}
