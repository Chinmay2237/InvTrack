class DemoResponse {
  final String id;
  final String name;
  final String description;

  DemoResponse({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DemoResponse.fromJson(Map<String, dynamic> json) {
    return DemoResponse(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
