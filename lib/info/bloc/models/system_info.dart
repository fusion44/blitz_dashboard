import 'network_interface.dart';

/// Data class with system information from the Raspiblitz
class SystemInfo {
  /// The uptime of the system (including time spent in suspend) in seconds
  double totalUptime;

  /// The amount of time spent in the idle process in seconds
  double totalUptimeIdle;

  /// Current load CPU load over the last 1, 5, and 15 minutes
  int memTotal;

  /// Total memory in kB
  int memFree;

  /// Available memory in kB
  int memAvailable;

  /// The current temperature of the cpu in °C
  double temperatureC;

  /// The current temperature of the cpu in °F
  double temperatureF;

  /// The total hard drive size in kB
  int hardDriveTotal;

  /// The free hard drive size in kB
  int hardDriveFree;

  /// The total hard drive usage in percent
  int hardDriveUsage;

  /// Active network interfaces Currently only interfaces
  /// named eth* or en* and interfaces that are UP are
  /// included
  List<NetworkInterface> networkInterfaces;

  SystemInfo(
      {this.totalUptime,
      this.totalUptimeIdle,
      this.memTotal,
      this.memFree,
      this.memAvailable,
      this.temperatureC,
      this.temperatureF,
      this.hardDriveTotal,
      this.hardDriveFree,
      this.hardDriveUsage,
      this.networkInterfaces});

  SystemInfo.fromJson(Map<String, dynamic> json) {
    totalUptime = json['total_uptime'];
    totalUptimeIdle = json['total_uptime_idle'];
    memTotal = json['mem_total'];
    memFree = json['mem_free'];
    memAvailable = json['mem_available'];
    temperatureC = json['temperature_c'];
    temperatureF = json['temperature_f'];
    hardDriveTotal = json['hard_drive_total'];
    hardDriveFree = json['hard_drive_free'];
    hardDriveUsage = json['hard_drive_usage'];
    if (json['network_interfaces'] != null) {
      networkInterfaces = new List<NetworkInterface>();
      json['network_interfaces'].forEach((v) {
        networkInterfaces.add(new NetworkInterface.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_uptime'] = this.totalUptime;
    data['total_uptime_idle'] = this.totalUptimeIdle;
    data['mem_total'] = this.memTotal;
    data['mem_free'] = this.memFree;
    data['mem_available'] = this.memAvailable;
    data['temperature_c'] = this.temperatureC;
    data['temperature_f'] = this.temperatureF;
    data['hard_drive_total'] = this.hardDriveTotal;
    data['hard_drive_free'] = this.hardDriveFree;
    data['hard_drive_usage'] = this.hardDriveUsage;
    if (this.networkInterfaces != null) {
      data['network_interfaces'] =
          this.networkInterfaces.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
