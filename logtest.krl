ruleset logtest {
  meta {
    name "Test Logging"
    description <<
Test the logging feature
>>
    author "PJW"
    logging off

    sharing on
    provides getLogs
     
  }

  global {

    
  }

  rule make_log_1 {
    select when test log_a
    pre {
      a = {
        "foo": 1,
	"bar": [
	  {"flip": "dog",
	   "flop": "fish"
	  },
	  20
	]
      }.klog(">> value for a >> ");
    }
    send_directive("log1");
    always {
      log ">> Here's a again >> " + a.encode();
      log a;
    }
  
  }

  rule make_log_2 {
    select when test log_a log re/true/
    pre {
      "a value to log".klog(">> Another value >> ");
    }
    send_directive("log2")
    always {
      log "Log 2 ran as well"
    }
  }


}