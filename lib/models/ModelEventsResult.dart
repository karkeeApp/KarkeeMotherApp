// import 'package:carkee/models/ModelNewsResult.dart';
//
// class ModelEventsResult {
//   bool success;
//   List<ModelEvent> data;
//   int count;
//   int currentPage;
//   int pageCount;
//   int code;
//
//   ModelEventsResult(
//       {this.success,
//         this.data,
//         this.count,
//         this.currentPage,
//         this.pageCount,
//         this.code});
//
//   ModelEventsResult.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['data'] != null) {
//       data = new List<ModelEvent>();
//       json['data'].forEach((v) {
//         data.add(new ModelEvent.fromJson(v));
//       });
//     }
//     count = json['count'];
//     currentPage = json['currentPage'];
//     pageCount = json['pageCount'];
//     code = json['code'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data.map((v) => v.toJson()).toList();
//     }
//     data['count'] = this.count;
//     data['currentPage'] = this.currentPage;
//     data['pageCount'] = this.pageCount;
//     data['code'] = this.code;
//     return data;
//   }
// }
//
// class ModelEvent {
//   int eventId;
//   String title;
//   String createdAt;
//   String summary;
//   String image;
//   String url;
//   bool isAttendee;
//   bool isPublic;
//   int is_closed;
//   int is_paid;
//   double event_fee;
//
//   bool isPast;
//   String btnBookLabel;
//   String btnCancelLabel;
//   List<Galleries> galleries;
//
//   isPaidEvent(){
//     return is_paid == 1;
//   }
//
//   isNotClose(){
//     return is_closed == 1;
//   }
//
//   getEventFee(){
//     return event_fee.toStringAsFixed(2);
//   }
//
//
//   ModelEvent(
//       {this.eventId,
//         this.title,
//         this.createdAt,
//         this.summary,
//         this.image,
//         this.url,
//         this.isAttendee,
//         this.isPublic,
//         this.isPast,
//         this.btnBookLabel,
//         this.btnCancelLabel,
//         this.galleries,
//
//         this.is_closed,
//         this.is_paid,
//         this.event_fee,
//
//       });
//
//   ModelEvent.fromJson(Map<String, dynamic> json) {
//     eventId = json['event_id'];
//     title = json['title'];
//     createdAt = json['created_at'];
//
//     is_closed = json['is_closed'];
//     is_paid = json['is_paid'];
//     event_fee = json['event_fee'];
//
//     summary = json['summary'];
//     image = json['image'];
//     url = json['url'];
//     isAttendee = json['is_attendee'];
//     isPublic = json['is_public'];
//     isPast = json['is_past'];
//     btnBookLabel = json['btn_book_label'];
//     btnCancelLabel = json['btn_cancel_label'];
//     if (json['galleries'] != null) {
//       galleries = new List<Galleries>();
//       json['galleries'].forEach((v) {
//         galleries.add(new Galleries.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//
//     data['event_id'] = this.eventId;
//     data['title'] = this.title;
//     data['created_at'] = this.createdAt;
//
//     data['is_closed'] = this.is_closed;
//     data['is_paid'] = this.is_paid;
//     data['event_fee'] = this.event_fee;
//
//
//     data['summary'] = this.summary;
//     data['image'] = this.image;
//     data['url'] = this.url;
//     data['is_attendee'] = this.isAttendee;
//     data['is_public'] = this.isPublic;
//     data['is_past'] = this.isPast;
//     data['btn_book_label'] = this.btnBookLabel;
//     data['btn_cancel_label'] = this.btnCancelLabel;
//     if (this.galleries != null) {
//       data['galleries'] = this.galleries.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
