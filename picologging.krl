ruleset picologging {
  meta {
    name "Pico Logging"
    description <<
Set up logging in a pico
>>
    author "PJW"
    logging off

    use module b16x24 alias system_credentials

    sharing on
    provides getLogs
     
  }

  global {

    getLogs = function() {
      logs = pci:get_logs(ent:logging_eci)
               .map(function(l){
	              lt = l{"log_text"};
		      l.delete(["log_text"])
		       .put(["log_items"], lt.split(re/\n/))
                    })
      	       ;
      logs
    }
    
  }

  rule start_logging {
    select when cloudos logging_reset
    pre {
      leci  = ent:logging_eci.isnull()
           || not pci:logging_enabled(meta:eci()) => pci:set_logging(meta:eci())
	                                           | ent:logging_eci;
      x = pci:flush_logs(leci)
    }
    noop();
    always {
      set ent:logging_eci leci.klog(">> using logging ECI ->> ");
    }
  
  }
}