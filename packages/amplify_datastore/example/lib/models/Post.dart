/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/// This is an auto generated class representing the Post type in your schema.
@immutable
class Post extends Model {
  static const classType = _PostModelType();
  final String id;
  final String? _title;
  final int? _rating;
  final TemporalDateTime? _created;
  final Blog? _blog;
  final List<Comment>? _comments;
  final List<PostTags>? _tags;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  PostModelIdentifier get modelIdentifier {
    return PostModelIdentifier(id: id);
  }

  String get title {
    try {
      return _title!;
    } catch (e) {
      throw AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  int get rating {
    try {
      return _rating!;
    } catch (e) {
      throw AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  TemporalDateTime? get created {
    return _created;
  }

  Blog? get blog {
    return _blog;
  }

  List<Comment>? get comments {
    return _comments;
  }

  List<PostTags>? get tags {
    return _tags;
  }

  TemporalDateTime? get createdAt {
    return _createdAt;
  }

  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const Post._internal(
      {required this.id,
      required title,
      required rating,
      created,
      blog,
      comments,
      tags,
      createdAt,
      updatedAt})
      : _title = title,
        _rating = rating,
        _created = created,
        _blog = blog,
        _comments = comments,
        _tags = tags,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Post(
      {String? id,
      required String title,
      required int rating,
      TemporalDateTime? created,
      Blog? blog,
      List<Comment>? comments,
      List<PostTags>? tags}) {
    return Post._internal(
        id: id == null ? UUID.getUUID() : id,
        title: title,
        rating: rating,
        created: created,
        blog: blog,
        comments:
            comments != null ? List<Comment>.unmodifiable(comments) : comments,
        tags: tags != null ? List<PostTags>.unmodifiable(tags) : tags);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Post &&
        id == other.id &&
        _title == other._title &&
        _rating == other._rating &&
        _created == other._created &&
        _blog == other._blog &&
        DeepCollectionEquality().equals(_comments, other._comments) &&
        DeepCollectionEquality().equals(_tags, other._tags);
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = StringBuffer();

    buffer.write("Post {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write(
        "rating=" + (_rating != null ? _rating!.toString() : "null") + ", ");
    buffer.write(
        "created=" + (_created != null ? _created!.format() : "null") + ", ");
    buffer.write("blog=" + (_blog != null ? _blog!.toString() : "null") + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Post copyWith(
      {String? title,
      int? rating,
      TemporalDateTime? created,
      Blog? blog,
      List<Comment>? comments,
      List<PostTags>? tags}) {
    return Post._internal(
        id: id,
        title: title ?? this.title,
        rating: rating ?? this.rating,
        created: created ?? this.created,
        blog: blog ?? this.blog,
        comments: comments ?? this.comments,
        tags: tags ?? this.tags);
  }

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _title = json['title'],
        _rating = (json['rating'] as num?)?.toInt(),
        _created = json['created'] != null
            ? TemporalDateTime.fromString(json['created'])
            : null,
        _blog = json['blog']?['serializedData'] != null
            ? Blog.fromJson(
                Map<String, dynamic>.from(json['blog']['serializedData']))
            : null,
        _comments = json['comments'] is List
            ? (json['comments'] as List)
                .where((e) => e?['serializedData'] != null)
                .map((e) => Comment.fromJson(
                    Map<String, dynamic>.from(e['serializedData'])))
                .toList()
            : null,
        _tags = json['tags'] is List
            ? (json['tags'] as List)
                .where((e) => e?['serializedData'] != null)
                .map((e) => PostTags.fromJson(
                    Map<String, dynamic>.from(e['serializedData'])))
                .toList()
            : null,
        _createdAt = json['createdAt'] != null
            ? TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': _title,
        'rating': _rating,
        'created': _created?.format(),
        'blog': _blog?.toJson(),
        'comments': _comments?.map((Comment? e) => e?.toJson()).toList(),
        'tags': _tags?.map((PostTags? e) => e?.toJson()).toList(),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  static final QueryModelIdentifier<PostModelIdentifier> MODEL_IDENTIFIER =
      QueryModelIdentifier<PostModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField RATING = QueryField(fieldName: "rating");
  static final QueryField CREATED = QueryField(fieldName: "created");
  static final QueryField BLOG = QueryField(
      fieldName: "blog",
      fieldType: ModelFieldType(ModelFieldTypeEnum.model,
          ofModelName: (Blog).toString()));
  static final QueryField COMMENTS = QueryField(
      fieldName: "comments",
      fieldType: ModelFieldType(ModelFieldTypeEnum.model,
          ofModelName: (Comment).toString()));
  static final QueryField TAGS = QueryField(
      fieldName: "tags",
      fieldType: ModelFieldType(ModelFieldTypeEnum.model,
          ofModelName: (PostTags).toString()));
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Post";
    modelSchemaDefinition.pluralName = "Posts";

    modelSchemaDefinition.indexes = [
      ModelIndex(fields: const ["blogID"], name: "byBlog")
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Post.TITLE,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Post.RATING,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Post.CREATED,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.belongsTo(
        key: Post.BLOG,
        isRequired: false,
        targetNames: ["blogID"],
        ofModelName: (Blog).toString()));

    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
        key: Post.COMMENTS,
        isRequired: false,
        ofModelName: (Comment).toString(),
        associatedKey: Comment.POST));

    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
        key: Post.TAGS,
        isRequired: false,
        ofModelName: (PostTags).toString(),
        associatedKey: PostTags.POST));

    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
        fieldName: 'createdAt',
        isRequired: false,
        isReadOnly: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
        fieldName: 'updatedAt',
        isRequired: false,
        isReadOnly: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));
  });
}

class _PostModelType extends ModelType<Post> {
  const _PostModelType();

  @override
  Post fromJson(Map<String, dynamic> jsonData) {
    return Post.fromJson(jsonData);
  }
}

/// This is an auto generated class representing the model identifier
/// of [Post] in your schema.
@immutable
class PostModelIdentifier implements ModelIdentifier<Post> {
  final String id;

  /// Create an instance of PostModelIdentifier using [id] the primary key.
  const PostModelIdentifier({required this.id});

  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{'id': id});

  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
      .entries
      .map((entry) => (<String, dynamic>{entry.key: entry.value}))
      .toList();

  @override
  String serializeAsString() => serializeAsMap().values.join('#');

  @override
  String toString() => 'PostModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PostModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
