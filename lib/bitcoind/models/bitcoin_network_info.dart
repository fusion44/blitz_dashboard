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
    final data = <String, dynamic>{};
    data['version'] = version;
    data['subversion'] = subversion;
    data['protocolversion'] = protocolVersion;
    data['localservices'] = localServices;
    data['localservicesnames'] = localServicesNames;
    data['localrelay'] = localRelay;
    data['timeoffset'] = timeOffset;
    data['networkactive'] = networkActive;
    data['connections'] = connections;
    if (networks != null) {
      data['networks'] = networks.map((v) => v.toJson()).toList();
    }
    data['relayfee'] = relayFee;
    data['incrementalfee'] = incrementalFee;
    if (localAddresses != null) {
      data['localaddresses'] = localAddresses.map((v) => v.toJson()).toList();
    }
    data['warnings'] = warnings;
    return data;
  }
}

class BitcoinNetwork {
  String name;
  bool limited;
  bool reachable;
  String proxy;
  bool proxyRandomizeCredentials;

  BitcoinNetwork({
    this.name,
    this.limited,
    this.reachable,
    this.proxy,
    this.proxyRandomizeCredentials,
  });

  BitcoinNetwork.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    limited = json['limited'];
    reachable = json['reachable'];
    proxy = json['proxy'];
    proxyRandomizeCredentials = json['proxy_randomize_credentials'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['limited'] = limited;
    data['reachable'] = reachable;
    data['proxy'] = proxy;
    data['proxy_randomize_credentials'] = proxyRandomizeCredentials;
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
    score = json['score'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['address'] = address;
    data['port'] = port;
    data['score'] = score;
    return data;
  }
}
