import 'dart:io';

import '../safe_convert.dart';

class ModelSecurityQuestionResult {
  List<ModelQuestion> data = [];
  int code = 0;

  ModelSecurityQuestionResult({
    this.data,
    this.code,
  });

  ModelSecurityQuestionResult.fromJson(Map<String, dynamic> json)
      : data = SafeManager.parseList(json, 'data')
            ?.map((e) => ModelQuestion.fromJson(e))
            ?.toList(),
        code = SafeManager.parseInt(json, 'code');

  Map<String, dynamic> toJson() => {
        'data': this.data?.map((e) => e.toJson())?.toList(),
        'code': this.code,
      };
}

class ModelQuestion {
  int id = 0;
  int accountId = 0;
  String question = "";
  String answer = ""; // tự thêm vào
  File file;
  int isFileUpload = 0;
  int status = 0;
  String createdAt = "";
  String updatedAt = "";

  ModelQuestion({
    this.id,
    this.accountId,
    this.question,
    this.answer,
    this.isFileUpload,
    this.status,
    this.createdAt,
    this.file,
    this.updatedAt,
  });

  ModelQuestion.fromJson(Map<String, dynamic> json)
      : id = SafeManager.parseInt(json, 'id'),
        accountId = SafeManager.parseInt(json, 'account_id'),
        question = SafeManager.parseString(json, 'question'),
        answer = SafeManager.parseString(json, 'answer'),
        isFileUpload = SafeManager.parseInt(json, 'is_file_upload'),
        status = SafeManager.parseInt(json, 'status'),
        createdAt = SafeManager.parseString(json, 'created_at'),
        updatedAt = SafeManager.parseString(json, 'updated_at');

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'account_id': this.accountId,
        'question': this.question,
        'answer': this.answer,
        'is_file_upload': this.isFileUpload,
        'status': this.status,
        'created_at': this.createdAt,
        'updated_at': this.updatedAt,
        'file': this.file,
      };
}
