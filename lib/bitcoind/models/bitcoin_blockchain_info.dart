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
    final data = <String, dynamic>{};
    data['chain'] = chain;
    data['blocks'] = blocks;
    data['headers'] = headers;
    data['bestblockhash'] = bestBlockHash;
    data['difficulty'] = difficulty;
    data['mediantime'] = medianTime;
    data['verificationprogress'] = verificationProgress;
    data['initialblockdownload'] = initialBlockDownload;
    data['chainwork'] = chainWork;
    data['size_on_disk'] = sizeOnDisk;
    data['pruned'] = pruned;
    data['pruneheight'] = pruneHeight;
    data['automatic_pruning'] = automaticPruning;
    data['prune_target_size'] = pruneTargetSize;
    if (softforks != null) {
      data['softforks'] = softforks.map((v) => v.toJson()).toList();
    }
    if (bip9Softforks != null) {
      data['bip9_softforks'] = bip9Softforks.toJson();
    }
    data['warnings'] = warnings;
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
    final data = <String, dynamic>{};
    data['id'] = id;
    data['version'] = version;
    if (reject != null) {
      data['reject'] = reject.toJson();
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
    final data = <String, dynamic>{};
    data['status'] = status;
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
    final data = <String, dynamic>{};
    if (softfork != null) {
      data['Softfork'] = softfork.toJson();
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
    final data = <String, dynamic>{};
    data['status'] = status;
    data['bit'] = bit;
    data['startTime'] = startTime;
    data['timeout'] = timeout;
    data['since'] = since;
    if (statistics != null) {
      data['statistics'] = statistics.toJson();
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
    final data = <String, dynamic>{};
    data['period'] = period;
    data['threshold'] = threshold;
    data['count'] = count;
    data['possible'] = possible;
    return data;
  }
}
