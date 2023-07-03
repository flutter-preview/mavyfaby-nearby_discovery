class NearbyDevice {
  String name;
  String endpointID;
  String serviceID;
  String? ipAddress;

  NearbyDevice({
    required this.name,
    required this.endpointID,
    required this.serviceID,
    this.ipAddress
  });

  factory NearbyDevice.fromMap(Map<dynamic, dynamic> map) {
    return NearbyDevice(
      name: map['name'],
      endpointID: map['endpointID'],
      serviceID: map['serviceID'],
      ipAddress: map['ipAddress']
    );
  }
}