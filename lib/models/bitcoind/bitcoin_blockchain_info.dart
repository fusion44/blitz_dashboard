class BitcoinBlockChainInfo {
  String chain;
  int blocks;
  int headers;
  String bestBlockHash;
  double difficulty;
  int medianTime;
  double verificationProgress;
  bool initialBlockDownload;
  String chainWork;
  int sizeOnDisk;
  bool pruned;
  int pruneHeight;
  bool automaticPruning;
  int pruneTargetSize;
  List<Softforks> softforks;
  Bip9Softforks bip9Softforks;
  String warnings;

  BitcoinBlockChainInfo({
    this.chain,
    this.blocks,
    this.headers,
    this.bestBlockHash,
    this.difficulty,
    this.medianTime,
    this.verificationProgress,
    this.initialBlockDownload,
    this.chainWork,
    this.sizeOnDisk,
    this.pruned,
    this.pruneHeight,
    this.automaticPruning,
    this.pruneTargetSize,
    this.softforks,
    this.bip9Softforks,
    this.warnings,
  });

  BitcoinBlockChainInfo.fromJson(Map<String, dynamic> json) {
    chain = json['chain'];
    blocks = json['blocks'];
    headers = json['headers'];
    bestBlockHash = json['bestblockhash'];
    difficulty = json['difficulty'];
    medianTime = json['mediantime'];
    verificationProgress = json['verificationprogress'];
    initialBlockDownload = json['initialblockdownload'];
    chainWork = json['chainwork'];
    sizeOnDisk = json['size_on_disk'];
    pruned = json['pruned'];
    pruneHeight = json['pruneheight'];
    automaticPruning = json['automatic_pruning'];
    pruneTargetSize = json['prune_target_size'];
    if (json['softforks'] != null) {
      softforks = <Softforks>[];
      json['softforks'].keys.forEach((v) {
        softforks.add(
          Softforks.fromJson(json['softforks'][v]),
        );
      });
    }
    bip9Softforks = json['bip9_softforks'] != null
        ? Bip9Softforks.fromJson(json['bip9_softforks'])
        : null;
    warnings = json['warnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['chain'] = this.chain;
    data['blocks'] = this.blocks;
    data['headers'] = this.headers;
    data['bestblockhash'] = this.bestBlockHash;
    data['difficulty'] = this.difficulty;
    data['mediantime'] = this.medianTime;
    data['verificationprogress'] = this.verificationProgress;
    data['initialblockdownload'] = this.initialBlockDownload;
    data['chainwork'] = this.chainWork;
    data['size_on_disk'] = this.sizeOnDisk;
    data['pruned'] = this.pruned;
    data['pruneheight'] = this.pruneHeight;
    data['automatic_pruning'] = this.automaticPruning;
    data['prune_target_size'] = this.pruneTargetSize;
    if (this.softforks != null) {
      data['softforks'] = this.softforks.map((v) => v.toJson()).toList();
    }
    if (this.bip9Softforks != null) {
      data['bip9_softforks'] = this.bip9Softforks.toJson();
    }
    data['warnings'] = this.warnings;
    return data;
  }
}

class Softforks {
  String id;
  int version;
  Reject reject;

  Softforks({this.id, this.version, this.reject});

  Softforks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    version = json['version'];
    reject = json['reject'] != null ? Reject.fromJson(json['reject']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['version'] = this.version;
    if (this.reject != null) {
      data['reject'] = this.reject.toJson();
    }
    return data;
  }
}

class Reject {
  bool status;

  Reject({this.status});

  Reject.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}

class Bip9Softforks {
  BitcoinSoftfork softfork;

  Bip9Softforks({this.softfork});

  Bip9Softforks.fromJson(Map<String, dynamic> json) {
    softfork = json['Softfork'] != null
        ? BitcoinSoftfork.fromJson(json['Softfork'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.softfork != null) {
      data['Softfork'] = this.softfork.toJson();
    }
    return data;
  }
}

class BitcoinSoftfork {
  String status;
  int bit;
  int startTime;
  int timeout;
  int since;
  BitcoinStatistics statistics;

  BitcoinSoftfork(
      {this.status,
      this.bit,
      this.startTime,
      this.timeout,
      this.since,
      this.statistics});

  BitcoinSoftfork.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    bit = json['bit'];
    startTime = json['startTime'];
    timeout = json['timeout'];
    since = json['since'];
    statistics = json['statistics'] != null
        ? BitcoinStatistics.fromJson(json['statistics'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['bit'] = this.bit;
    data['startTime'] = this.startTime;
    data['timeout'] = this.timeout;
    data['since'] = this.since;
    if (this.statistics != null) {
      data['statistics'] = this.statistics.toJson();
    }
    return data;
  }
}

class BitcoinStatistics {
  int period;
  int threshold;
  int count;
  bool possible;

  BitcoinStatistics({this.period, this.threshold, this.count, this.possible});

  BitcoinStatistics.fromJson(Map<String, dynamic> json) {
    period = json['period'];
    threshold = json['threshold'];
    count = json['count'];
    possible = json['possible'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['period'] = this.period;
    data['threshold'] = this.threshold;
    data['count'] = this.count;
    data['possible'] = this.possible;
    return data;
  }
}
