import '../../domain/entities/property_entity.dart';

class PropertyModel {
  final String id;
  final String clientId;
  final String name;
  final String? address;
  final String? googleMapLink;
  final String? image;
  final String? propertyImageUrl;

  const PropertyModel({
    required this.id,
    required this.clientId,
    required this.name,
    this.address,
    this.googleMapLink,
    this.image,
    this.propertyImageUrl,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: (json['id'] as int? ?? 0).toString(),
      clientId: (json['client_id'] as int? ?? 0).toString(),
      name: json['name'] as String? ?? '',
      address: json['address'] as String?,
      googleMapLink: json['google_map_link'] as String?,
      image: json['image'] as String?,
      propertyImageUrl: json['property_image_url'] as String?,
    );
  }

  PropertyEntity toEntity() => PropertyEntity(
        id: id,
        clientId: clientId,
        name: name,
        address: address,
        googleMapLink: googleMapLink,
        image: image,
        propertyImageUrl: propertyImageUrl,
      );
}
