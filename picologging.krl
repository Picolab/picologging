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
               .map(function(k,l){
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
           || not pci:get_logging(meta:eci()) => pci:set_logging(meta:eci())
	                                       | ent:logging_eci;
       				    
    }
    noop();
    always {
      set ent:logging_eci leci
    }
  
  }
}