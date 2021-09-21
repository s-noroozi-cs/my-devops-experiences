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
        log local0.warning "Client did not provide Certificate, it rejected, Client IP: [IP::client_addr]"
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
            log local0.notice "Accept client certificate, Client IP: [IP::client_addr]"
        } else {
            log local0.warning "No Matching Client Certificate Was Found, Client IP: [IP::client_addr]"
            reject
        }
    }
}

#For troubleshooting uncommented following lines to log more events and data
# More SSL events and more logs

#when CLIENTSSL_CLIENTHELLO {
#	log local0.debug "CLIENTSSL_CLIENTHELLO, Client IP: [IP::client_addr]"
#}

#when CLIENTSSL_HANDSHAKE {
#	log local0.debug "CLIENTSSL_HANDSHAKE, Client IP: [IP::client_addr]"
#	SSL::collect
#}

#when CLIENTSSL_DATA {
#    log local0.debug "CLIENTSSL_DATA"
#    log local0.debug "Payload [SSL::payload], Client IP: [IP::client_addr]"
#    SSL::release
#}


# If You need some attributes of client certificate in your rest api, following event provided it.
# Also I added original client ip address as "x-forward-for" header, because 
# BIG-IP make new request for each client request. 
# Then value of remote address attribute in your http request handler is IP address of "BIG-IP", it is not your original client IP address.
# We added it as standard header ("x-forward-for) for next analyzing and processing.

when HTTP_REQUEST {

    #For security reason before add custom header, remove any old existed value

    HTTP::header remove X-Forwarded-For
    HTTP::header insert X-Forwarded-For [IP::remote_addr]
	
    regexp {CN=([^,]+)} [X509::subject [SSL::cert 0]] cn
    regexp {O=([^,]+)} [X509::subject [SSL::cert 0]] o
    set sn [X509::serial_number [SSL::cert 0]]
    
    HTTP::header remove x-client-certificate-cn
    HTTP::header insert x-client-certificate-cn $cn
    
    HTTP::header remove x-client-certificate-o
    HTTP::header insert x-client-certificate-o $o
    
    HTTP::header remove x-client-certificate-sn
    HTTP::header insert x-client-certificate-sn $sn
}
