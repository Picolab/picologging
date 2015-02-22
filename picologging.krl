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
      logs = pci:get_logs(ent:logging_eci.klog(">> using logging ECI ->> "))
               .map(function(l){
	              lt = l{"log_text"};
		      eid = l{"eid"};
		      l.delete(["log_text"])
		       .put(["log_items"], lt.split(re/\n/))
		       			     .filter(function(ln){ln.match("re/^\d+\s+#{eid}/".as("regexp"))
                    })
      	       ;
      logs
    }
    
  }

  rule start_logging {
    select when cloudos logging_reset
    pre {
       // leci  = ent:logging_eci.isnull()
       //      || not pci:logging_enabled(meta:eci()) => pci:set_logging(meta:eci())
       // 	                                           | ent:logging_eci;
      clear_flag = pci:clear_logging(meta:eci());
      leci = pci:set_logging(meta:eci());
      x = pci:flush_logs(leci);
    }
    noop();
    always {
      set ent:logging_eci leci.klog(">> storing logging ECI ->> ");
    }
  
  }
}