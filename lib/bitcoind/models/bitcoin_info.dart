import 'package:blitz_gui/bitcoind/models/models.dart';

/// Convenience object that that holds data combined
/// from different Bitcoin RPC calls
class BitcoinInfo {
  /// The server version
  final int version;

  /// The server subversion string
  final String subversion;

  /// Whether p2p networking is enabled
  final bool networkActive;

  /// The number of connections
  final int connections;

  /// Information per network
  final List<BitcoinNetwork> networks;

  /// List of local addresses
  final List<LocalAddress> localAddresses;

  /// Current network name as defined in BIP70 (main, test, regtest)
  final String chain;

  /// The current number of blocks processed in the server
  final int blocks;

  /// The hash of the currently best block
  final String bestBlockHash;

  /// The estimated size of the block and undo files on disk
  final int sizeOnDisk;

  /// Current tx count
  final int mempoolTxCount;

  /// Sum of all virtual transaction sizes as defined in BIP 141.
  /// Differs from actual serialized size because witness data is discounted
  final int mempoolBytes;

  /// Total memory usage for the mempool
  final int mempoolTotalMemoryUsage;

  BitcoinInfo({
    this.version,
    this.subversion,
    this.networkActive,
    this.connections,
    this.networks,
    this.localAddresses,
    this.chain,
    this.blocks,
    this.bestBlockHash,
    this.sizeOnDisk,
    this.mempoolTxCount,
    this.mempoolBytes,
    this.mempoolTotalMemoryUsage,
  });

  static BitcoinInfo fromJson(Map<String, dynamic> json) {
    var networks = <BitcoinNetwork>[];

    if (json['networks'] != null) {
      json['networks'].forEach((v) {
        networks.add(BitcoinNetwork.fromJson(v));
      });
    }
    var localAddresses = <LocalAddress>[];

    if (json['localaddresses'] != null) {
      json['localaddresses'].forEach((v) {
        localAddresses.add(LocalAddress.fromJson(v));
      });
    }

    return BitcoinInfo(
      version: json['version'],
      subversion: json['subversion'],
      networkActive: json['networkactive'],
      connections: json['connections'],
      networks: networks,
      localAddresses: localAddresses,
      chain: json['chain'],
      blocks: json['blocks'],
      bestBlockHash: json['bestblockhash'],
      sizeOnDisk: json['size_on_disk'],
      mempoolTxCount: json['size'],
      mempoolBytes: json['bytes'],
      mempoolTotalMemoryUsage: json['usage'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['version'] = version;
    data['subversion'] = subversion;
    data['networkactive'] = networkActive;
    data['connections'] = connections;
    if (networks != null) {
      data['networks'] = networks.map((v) => v.toJson()).toList();
    }
    if (localAddresses != null) {
      data['localaddresses'] = localAddresses.map((v) => v.toJson()).toList();
    }
    data['chain'] = chain;
    data['blocks'] = blocks;
    data['bestblockhash'] = bestBlockHash;
    data['size_on_disk'] = sizeOnDisk;
    data['size'] = mempoolTxCount;
    data['bytes'] = mempoolBytes;
    data['usage'] = mempoolTotalMemoryUsage;
    return data;
  }
}
