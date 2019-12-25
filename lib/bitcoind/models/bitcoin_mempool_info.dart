class BitcoinMempoolInfo {
  /// True if the mempool is fully loaded
  final bool loaded;

  /// Current tx count
  final int size;

  /// Sum of all virtual transaction sizes as defined in BIP 141.
  /// Differs from actual serialized size because witness data is discounted
  final int bytes;

  /// Total memory usage for the mempool
  final int usage;

  /// Maximum memory usage for the mempool
  final int maxmempool;

  /// Minimum fee rate in BTC/kB for tx to be accepted.
  /// Is the maximum of minrelaytxfee and minimum mempool fee
  final double mempoolminfee;

  /// Current minimum relay fee for transactions
  final double minrelaytxfee;

  const BitcoinMempoolInfo({
    this.loaded,
    this.size,
    this.bytes,
    this.usage,
    this.maxmempool,
    this.mempoolminfee,
    this.minrelaytxfee,
  });

  BitcoinMempoolInfo copyWith({
    bool loaded,
    int size,
    int bytes,
    int usage,
    int maxmempool,
    double mempoolminfee,
    double minrelaytxfee,
  }) {
    return BitcoinMempoolInfo(
      loaded: loaded ?? this.loaded,
      size: size ?? this.size,
      bytes: bytes ?? this.bytes,
      usage: usage ?? this.usage,
      maxmempool: maxmempool ?? this.maxmempool,
      mempoolminfee: mempoolminfee ?? this.mempoolminfee,
      minrelaytxfee: minrelaytxfee ?? this.minrelaytxfee,
    );
  }

  static BitcoinMempoolInfo fromJson(Map<String, dynamic> json) {
    return BitcoinMempoolInfo(
      loaded: json['loaded'],
      size: json['size'],
      bytes: json['bytes'],
      usage: json['usage'],
      maxmempool: json['maxmempool'],
      mempoolminfee: json['mempoolminfee'],
      minrelaytxfee: json['minrelaytxfee'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['loaded'] = loaded;
    data['size'] = size;
    data['bytes'] = bytes;
    data['usage'] = usage;
    data['maxmempool'] = maxmempool;
    data['mempoolminfee'] = mempoolminfee;
    data['minrelaytxfee'] = minrelaytxfee;
    return data;
  }
}
