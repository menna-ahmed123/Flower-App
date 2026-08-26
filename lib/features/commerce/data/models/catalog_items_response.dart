class CatalogItemsResponse {
  const CatalogItemsResponse({required this.items});

  final List<Map<String, dynamic>> items;

  factory CatalogItemsResponse.fromJson(Map<String, dynamic> json) {
    return CatalogItemsResponse(items: catalogItemsFromJson(json['data']));
  }

  Map<String, dynamic> toJson() => {'data': items};
}

List<Map<String, dynamic>> catalogItemsFromJson(dynamic json) {
  if (json is List) return _mapsFromList(json);
  if (json is Map) return catalogItemsFromJson(json['items']);
  return const [];
}

List<Map<String, dynamic>> _mapsFromList(List<dynamic> json) {
  return [
    for (final item in json)
      if (item is Map) Map<String, dynamic>.from(item),
  ];
}
