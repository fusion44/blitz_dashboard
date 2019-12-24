class NetworkInterface {
  /// name of the network interface
  String name;

  /// IPV4 address
  String ip4;

  /// IPV6 address
  String ip6;

  /// kBytes downloaded since last reboot
  int rx;

  /// kBytes uploaded since last reboot
  int tx;

  NetworkInterface({this.name, this.ip4, this.ip6, this.rx, this.tx});

  NetworkInterface.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ip4 = json['ip4'];
    ip6 = json['ip6'];
    rx = json['rx'];
    tx = json['tx'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['ip4'] = ip4;
    data['ip6'] = ip6;
    data['rx'] = rx;
    data['tx'] = tx;
    return data;
  }
}
