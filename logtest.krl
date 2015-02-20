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
    noop();
    always {
      log ">> Here's a again >> " + a
    }
  
  }
}