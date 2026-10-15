class PropertyEntity {
  final String id;
  final String clientId;
  final String name;
  final String? address;
  final String? googleMapLink;
  final String? image;
  final String? propertyImageUrl;

  const PropertyEntity({
    required this.id,
    required this.clientId,
    required this.name,
    this.address,
    this.googleMapLink,
    this.image,
    this.propertyImageUrl,
  });

  bool get hasAddress => address != null && address!.trim().isNotEmpty;
  bool get hasGoogleMapLink => googleMapLink != null && googleMapLink!.trim().isNotEmpty;
  bool get hasImage => propertyImageUrl != null && propertyImageUrl!.trim().isNotEmpty;
}
