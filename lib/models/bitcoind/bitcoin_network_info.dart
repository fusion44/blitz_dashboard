class BitcoinNetworkInfo {
  int version;
  String subversion;
  int protocolVersion;
  String localServices;
  List<String> localServicesNames;
  bool localRelay;
  int timeOffset;
  bool networkActive;
  int connections;
  List<BitcoinNetwork> networks;
  double relayFee;
  double incrementalFee;
  List<LocalAddress> localAddresses;
  String warnings;

  BitcoinNetworkInfo({
    this.version,
    this.subversion,
    this.protocolVersion,
    this.localServices,
    this.localServicesNames,
    this.localRelay,
    this.timeOffset,
    this.networkActive,
    this.connections,
    this.networks,
    this.relayFee,
    this.incrementalFee,
    this.localAddresses,
    this.warnings,
  });

  BitcoinNetworkInfo.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    subversion = json['subversion'];
    protocolVersion = json['protocolversion'];
    localServices = json['localservices'];
    localServicesNames = json['localservicesnames'].cast<String>();
    localRelay = json['localrelay'];
    timeOffset = json['timeoffset'];
    networkActive = json['networkactive'];
    connections = json['connections'];
    if (json['networks'] != null) {
      networks = <BitcoinNetwork>[];
      json['networks'].forEach((v) {
        networks.add(BitcoinNetwork.fromJson(v));
      });
    }
    relayFee = json['relayfee'];
    incrementalFee = json['incrementalfee'];
    if (json['localaddresses'] != null) {
      localAddresses = <LocalAddress>[];
      json['localaddresses'].forEach((v) {
        localAddresses.add(LocalAddress.fromJson(v));
      });
    }
    warnings = json['warnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['version'] = this.version;
    data['subversion'] = this.subversion;
    data['protocolversion'] = this.protocolVersion;
    data['localservices'] = this.localServices;
    data['localservicesnames'] = this.localServicesNames;
    data['localrelay'] = this.localRelay;
    data['timeoffset'] = this.timeOffset;
    data['networkactive'] = this.networkActive;
    data['connections'] = this.connections;
    if (this.networks != null) {
      data['networks'] = this.networks.map((v) => v.toJson()).toList();
    }
    data['relayfee'] = this.relayFee;
    data['incrementalfee'] = this.incrementalFee;
    if (this.localAddresses != null) {
      data['localaddresses'] =
          this.localAddresses.map((v) => v.toJson()).toList();
    }
    data['warnings'] = this.warnings;
    return data;
  }
}

class BitcoinNetwork {
  String name;
  bool limited;
  bool reachable;
  String proxy;
  bool proxyRandomizeCredentials;

  BitcoinNetwork(
      {this.name,
      this.limited,
      this.reachable,
      this.proxy,
      this.proxyRandomizeCredentials});

  BitcoinNetwork.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    limited = json['limited'];
    reachable = json['reachable'];
    proxy = json['proxy'];
    proxyRandomizeCredentials = json['proxy_randomize_credentials'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['limited'] = this.limited;
    data['reachable'] = this.reachable;
    data['proxy'] = this.proxy;
    data['proxy_randomize_credentials'] = this.proxyRandomizeCredentials;
    return data;
  }
}

class LocalAddress {
  String address;
  int port;
  double score;

  LocalAddress({this.address, this.port, this.score});

  LocalAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    port = json['port'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['address'] = this.address;
    data['port'] = this.port;
    data['score'] = this.score;
    return data;
  }
}
