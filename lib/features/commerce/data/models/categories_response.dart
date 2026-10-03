import 'package:json_annotation/json_annotation.dart';

import 'category_model.dart';

part 'categories_response.g.dart';

@JsonSerializable()
class CategoriesResponse {
  @JsonKey(name: "status")
  final bool? status;
  @JsonKey(name: "code")
  final int? code;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final List<CategoryModel>? data;
  @JsonKey(name: "pagination")
  final Pagination? pagination;
  @JsonKey(name: "errors")
  final dynamic errors;

  CategoriesResponse ({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return _$CategoriesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CategoriesResponseToJson(this);
  }
}

@JsonSerializable()
class Pagination {
  @JsonKey(name: "page")
  final int? page;
  @JsonKey(name: "pageSize")
  final int? pageSize;
  @JsonKey(name: "totalCount")
  final int? totalCount;
  @JsonKey(name: "totalPages")
  final int? totalPages;
  @JsonKey(name: "hasNextPage")
  final bool? hasNextPage;
  @JsonKey(name: "hasPreviousPage")
  final bool? hasPreviousPage;

  Pagination ({
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return _$PaginationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PaginationToJson(this);
  }
}


