class Softfork {
  /// name of the softfork
  final String name;

  /// One of "buried", "bip9"
  final String type;

  /// True if the rules are enforced for the mempool and the next block
  final bool active;

  /// Height of the first block which the rules are or will
  /// be enforced (only for "buried" type, or "bip9" type with
  /// "active" status)
  final int height;

  /// Status of bip9 softforks (only for "bip9" type)
  final Bip9Softfork bip9;

  Softfork({this.name, this.type, this.active, this.height, this.bip9});

  static Softfork fromJson(Map<String, dynamic> json) {
    return Softfork(
      name: json['name'],
      type: json['type'],
      active: json['active'],
      height: json['height'],
      bip9: json['bip9'] != null ? Bip9Softfork.fromJson(json['bip9']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['active'] = active;
    data['height'] = height;
    if (bip9 != null) {
      data['bip9'] = bip9.toJson();
    }
    return data;
  }
}

class Bip9Softfork {
  /// One of "defined", "started", "locked_in", "active", "failed"
  final String status;

  /// The bit (0-28) in the block version field used to signal this softfork (only for "started" status)
  final int bit;

  /// The minimum median time past of a block at which the bit gains its meaning
  final int startTime;

  /// The median time past of a block at which the deployment is considered failed if not yet locked in
  final int timeout;

  /// Height of the first block to which the status applies
  final int since;

  /// Numeric statistics about BIP9 signalling for a softfork
  final Bip9SoftforkStatistics statistics;

  Bip9Softfork({
    this.status,
    this.bit,
    this.startTime,
    this.timeout,
    this.since,
    this.statistics,
  });

  static Bip9Softfork fromJson(Map<String, dynamic> json) {
    return Bip9Softfork(
      status: json['status'],
      bit: json['bit'],
      startTime: json['start_time'],
      timeout: json['timeout'],
      since: json['since'],
      statistics: json['statistics'] != null
          ? Bip9SoftforkStatistics.fromJson(json['statistics'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['bit'] = bit;
    data['start_time'] = startTime;
    data['timeout'] = timeout;
    data['since'] = since;
    if (statistics != null) {
      data['statistics'] = statistics.toJson();
    }
    return data;
  }
}

class Bip9SoftforkStatistics {
  /// The length in blocks of the BIP9 signalling period
  final int period;

  /// The number of blocks with the version bit set required to activate the feature
  final int threshold;

  /// The number of blocks elapsed since the beginning of the current period
  final int elapsed;

  /// The number of blocks with the version bit set in the current period
  final int count;

  /// Returns false if there are not enough blocks left in this period to pass activation threshold
  final bool possible;

  Bip9SoftforkStatistics({
    this.period,
    this.threshold,
    this.elapsed,
    this.count,
    this.possible,
  });

  static Bip9SoftforkStatistics fromJson(Map<String, dynamic> json) {
    return Bip9SoftforkStatistics(
      period: json['period'],
      threshold: json['threshold'],
      elapsed: json['elapsed'],
      count: json['count'],
      possible: json['possible'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['period'] = period;
    data['threshold'] = threshold;
    data['elapsed'] = elapsed;
    data['count'] = count;
    data['possible'] = possible;
    return data;
  }
}

class BitcoinBlockchainInfo {
  /// Current network name as defined in BIP70 (main, test, regtest)
  final String chain;

  /// The current number of blocks processed in the server
  final int blocks;

  /// The current number of headers we have validated
  final int headers;

  /// The hash of the currently best block
  final String bestBlockhash;

  /// The current difficulty
  final double difficulty;

  /// Median time for the current best block
  final int medianTime;

  /// Estimate of verification progress from 0..1
  final double verificationProgress;

  /// Estimate of whether this node is in Initial Block Download mode. (debug information)
  final bool initialBlockDownload;

  /// Total amount of work in active chain, in hexadecimal
  final String chainwork;

  /// The estimated size of the block and undo files on disk
  final int sizeOnDisk;

  /// If the blocks are subject to pruning
  final bool pruned;

  /// Lowest-height complete block stored (only present if pruning is enabled)
  final int pruneHeight;

  /// Whether automatic pruning is enabled (only present if pruning is enabled)
  final bool automaticPruning;

  ///  The tar size used by pruning (only present if automatic pruning is enabled)
  final int pruneTargetSize;

  /// Status of softforks
  final List<Softfork> softforks;

  /// Any network and blockchain warnings.
  final String warnings;

  BitcoinBlockchainInfo({
    this.chain,
    this.blocks,
    this.headers,
    this.bestBlockhash,
    this.difficulty,
    this.medianTime,
    this.verificationProgress,
    this.initialBlockDownload,
    this.chainwork,
    this.sizeOnDisk,
    this.pruned,
    this.pruneHeight,
    this.automaticPruning,
    this.pruneTargetSize,
    this.softforks,
    this.warnings,
  });

  static BitcoinBlockchainInfo fromJson(Map<String, dynamic> json) {
    var softforks = <Softfork>[];

    if (json['softforks'] != null) {
      json['softforks'].forEach((v) {
        softforks.add(Softfork.fromJson(v));
      });
    }

    return BitcoinBlockchainInfo(
      warnings: json['warnings'],
      chain: json['chain'],
      blocks: json['blocks'],
      headers: json['headers'],
      bestBlockhash: json['bestblockhash'],
      difficulty: json['difficulty'],
      medianTime: json['mediantime'],
      verificationProgress: json['verificationprogress'],
      initialBlockDownload: json['initialblockdownload'],
      chainwork: json['chainwork'],
      sizeOnDisk: json['size_on_disk'],
      pruned: json['pruned'],
      pruneHeight: json['pruneheight'],
      automaticPruning: json['automatic_pruning'],
      pruneTargetSize: json['prune_target_size'],
      softforks: softforks,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['warnings'] = warnings;
    data['chain'] = chain;
    data['blocks'] = blocks;
    data['headers'] = headers;
    data['bestblockhash'] = bestBlockhash;
    data['difficulty'] = difficulty;
    data['mediantime'] = medianTime;
    data['verificationprogress'] = verificationProgress;
    data['initialblockdownload'] = initialBlockDownload;
    data['chainwork'] = chainwork;
    data['size_on_disk'] = sizeOnDisk;
    data['pruned'] = pruned;
    data['pruneheight'] = pruneHeight;
    data['automatic_pruning'] = automaticPruning;
    data['prune_target_size'] = pruneTargetSize;
    if (softforks != null) {
      data['softforks'] = softforks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
