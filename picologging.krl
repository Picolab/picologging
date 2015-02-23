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
      logs = pci:get_logs(ent:logging_eci.klog(">> using logging ECI ->> "));
      logs
    }

    loggingStatus = function() {
      status = pci:logging_enabled(meta:eci());
      status => "true" | "false"
    }
    
  }

  rule start_logging {
    select when picolog reset
             or picolog on
    pre {
      clear_flag = pci:clear_logging(meta:eci()); // reset it if already set
      leci = pci:set_logging(meta:eci());
      x = pci:flush_logs(leci);
    }
    noop();
    always {
      set ent:logging_eci leci.klog(">> storing logging ECI ->> ");
    }
  }

  rule stop_logging {
    select when picolog off
    pre {
      clear_flag = pci:clear_logging(meta:eci());
      x = pci:flush_logs(ent:logging_eci);
    }
    noop();
    always {
      clear ent:logging_eci;
    }
  }

  rule flush_logs {
    select when picolog flush
    pre {
      x = pci:flush_logs(ent:logging_eci);
    }
    noop();
  }



}