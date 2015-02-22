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
    provides getLogs, loggingStatus
     
  }

  global {

    getLogs = function() {
      logs = pci:get_logs(ent:logging_eci.klog(">> using logging ECI ->> "))
	     ;
      logs
    }

    loggingStatus = function() {
      status = (pci:logging_enabled(meta:eci()) == 1).klog(">> logging status >>");
      status
    }
    
  }

  rule start_logging {
    select when cloudos logging_reset
             or cloudos logging_on
    pre {
      clear_flag = pci:clear_logging(meta:eci());
      leci = pci:set_logging(meta:eci());
      x = pci:flush_logs(leci);
    }
    noop();
    always {
      set ent:logging_eci leci.klog(">> storing logging ECI ->> ");
    }
  }

  rule clear_logging {
    select when cloudos logging_off
    pre {
      clear_flag = pci:clear_logging(meta:eci());
      x = pci:flush_logs(leci);
    }
    noop();
    always {
      clear ent:logging_eci;
    }
  }



}