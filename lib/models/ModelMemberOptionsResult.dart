class ModelMemberOptionsResult {
  int code;
  String memberId;
  String paymentSummary;
  List<IntStringOptions> ownerOptions;
  List<IntStringOptions> relationships;
  List<Salaries> salaries;
  String totalPayable;
  String entityEun;
  String entityName;
  List<Details> details;

  ModelMemberOptionsResult(
      {this.code,
        this.memberId,
        this.paymentSummary,
        this.ownerOptions,
        this.relationships,
        this.salaries,
        this.totalPayable,
        this.entityEun,
        this.entityName,
        this.details});

  ModelMemberOptionsResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    memberId = json['member_id'];
    paymentSummary = json['payment_summary'];
    if (json['owner_options'] != null) {
      ownerOptions = new List<IntStringOptions>();
      json['owner_options'].forEach((v) {
        ownerOptions.add(new IntStringOptions.fromJson(v));
      });
    }
    if (json['relationships'] != null) {
      relationships = new List<IntStringOptions>();
      json['relationships'].forEach((v) {
        relationships.add(new IntStringOptions.fromJson(v));
      });
    }
    if (json['salaries'] != null) {
      salaries = new List<Salaries>();
      json['salaries'].forEach((v) {
        salaries.add(new Salaries.fromJson(v));
      });
    }
    totalPayable = json['total_payable'];
    entityEun = json['entity_eun'];
    entityName = json['entity_name'];
    if (json['details'] != null) {
      details = new List<Details>();
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['member_id'] = this.memberId;
    data['payment_summary'] = this.paymentSummary;
    if (this.ownerOptions != null) {
      data['owner_options'] = this.ownerOptions.map((v) => v.toJson()).toList();
    }
    if (this.relationships != null) {
      data['relationships'] =
          this.relationships.map((v) => v.toJson()).toList();
    }
    if (this.salaries != null) {
      data['salaries'] = this.salaries.map((v) => v.toJson()).toList();
    }
    data['total_payable'] = this.totalPayable;
    data['entity_eun'] = this.entityEun;
    data['entity_name'] = this.entityName;
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IntStringOptions {
  int id;
  String value;

  IntStringOptions({this.id, this.value});

  IntStringOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    return data;
  }
}

class Salaries {
  String id;
  String value;

  Salaries({this.id, this.value});

  Salaries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    return data;
  }
}

class Details {
  String label;
  String amount;

  Details({this.label, this.amount});

  Details.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['amount'] = this.amount;
    return data;
  }
}