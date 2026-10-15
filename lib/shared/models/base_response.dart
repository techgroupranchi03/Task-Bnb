class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, List<String>>? errors;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      statusCode: json['status_code'] as int?,
    );
  }

  factory ApiResponse.success({T? data, String? message}) =>
      ApiResponse<T>(success: true, data: data, message: message);

  factory ApiResponse.failure({
    String? message,
    Map<String, List<String>>? errors,
  }) =>
      ApiResponse<T>(success: false, message: message, errors: errors);
}

class PaginatedResponse<T> extends ApiResponse<List<T>> {
  final int? total;
  final int? currentPage;
  final int? lastPage;
  final int? perPage;

  const PaginatedResponse({
    required super.success,
    super.message,
    super.data,
    this.total,
    this.currentPage,
    this.lastPage,
    this.perPage,
  });

  bool get hasMore => (currentPage ?? 0) < (lastPage ?? 0);
}
