ruleset picologging {
  meta {
    name "Pico Logging"
    description <<
Set up logging in a pico
>>
    author "PJW"
    logging off

    use module b16x24 alias system_credentials

    provides getLogs, loggingStatus, getLog
    sharing on
     
  }

  global {

    getLogs = function(eids) { // takes an optianal array of eids to return a filtered list of logs matching the provided eids
      ids = ( eids.isnull() || eids.typeof() eq "array" ) => eids | eids.split(re/;/); 
      logs = pci:get_logs(ent:logging_eci.klog(">> using logging ECI ->> "));
      return = ids.isnull()  => logs | logs.filter( function (log){ (ids.index(log{"eid"}) != -1) ; });
      return;
    }
    // function for testing while keeping a working function
    getLog = function(eids) { // takes an optianal array of eids to return a filtered list of logs matching the provided eids
      ids = ( eids.isnull() || eids.typeof() eq "array" ) => eids | eids.split(re/;/); 
      logs = pci:get_logs(ent:logging_eci.klog(">> using logging ECI ->> "));
      return = ids.isnull()  => logs | logs.filter( function (log){ (ids.index(log{"eid"}) != -1) ; });
      { 'eids': eids,
        'ids': ids,
       'logs':logs,
       'return': return
      }
    }

    loggingStatus = function() {
      status = pci:logging_enabled(meta:eci());
      status => "true" | "false"
    }
    
  }

  rule start_logging {
    select when picolog reset
             or picolog active
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
    select when picolog inactive
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