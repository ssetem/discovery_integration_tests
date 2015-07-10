var discovery = require('ot-discovery');
var uuid = require("node-uuid");

if (process.argv.length < 3) {
  console.error("Need discovery server hostname; expected invokation: `node demo.js <DISCO_HOST>`");
  process.exit(1);
}

var disco_url = process.argv.slice(2)[0];
var service_type = uuid.v4();
var service_url = "fake://" + uuid.v4();

console.log("Demo nodejs service address: " + service_url);
console.log("Using discovery service at '" + disco_url + "'");
console.log("Using service type '" + service_type + "'");
console.log("Using service URL '" + service_url + "'");

var disco = new discovery(disco_url, {
  logger: {
    log: function(log){ console.log(log); },
    error: function(error){ console.log(error); },
  }
});
disco.onError(function(error) {
  console.warn(error);
});
disco.onUpdate(function(update) {
  console.log(update);
});
disco.connect(function(error, host, servers) {
  console.log("Discovery environment '" + host + "' has servers: " + servers);
  disco.announce({
    serviceType: service_type,
    serviceUri: service_url,
  }, function (error, lease) {
    if (error) {
      console.error(error);
      return;
    }
    console.log("Announced as: " + JSON.stringify(lease));
    setTimeout(function() {
      console.log("Unannouncing " + lease.announcementId);
      disco.unannounce(lease);
      setTimeout(process.exit, 2000);
    }, 20000);
  });
});

function find_self_demo() {
  console.log("Demo service at: " + disco.find(service_type));
}

setInterval(find_self_demo, 5000);


