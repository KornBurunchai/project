class Asset {
  final String assetId;
  final String assetCode;
  final String assetName;
  final String typeName;
  final String brand;
  final String location;
  final String description;
  final String status;
  final String image;

  Asset({
    required this.assetId,
    required this.assetCode,
    required this.assetName,
    required this.typeName,
    required this.brand,
    required this.location,
    required this.description,
    required this.status,
    required this.image,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      assetId: json['asset_id'].toString(),
      assetCode: json['asset_code'],
      assetName: json['asset_name'],
      typeName: json['type_name'],
      brand: json['brand'],
      location: json['location'],
      description: json['description'],
      status: json['status'],
      image: json['image'] ?? '',
    );
  }
}