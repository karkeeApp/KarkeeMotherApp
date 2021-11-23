import 'ModelNewsResult.dart';
import 'V2/safe_convert.dart';

class ModelEventsResultV2 {
  bool success = false;
  List<ModelEvent> data = [];
  int count = 0;
  int currentPage = 0;
  int pageCount = 0;
  int code = 0;

  ModelEventsResultV2({
    this.success,
    this.data,
    this.count,
    this.currentPage,
    this.pageCount,
    this.code,
  });

  ModelEventsResultV2.fromJson(Map<String, dynamic> json)
      : success = SafeManager.parseBoolean(json, 'success'),
        data = SafeManager.parseList(json, 'data')
            ?.map((e) => ModelEvent.fromJson(e))
            ?.toList(),
        count = SafeManager.parseInt(json, 'count'),
        currentPage = SafeManager.parseInt(json, 'currentPage'),
        pageCount = SafeManager.parseInt(json, 'pageCount'),
        code = SafeManager.parseInt(json, 'code');

  Map<String, dynamic> toJson() => {
        'success': this.success,
        'data': this.data?.map((e) => e.toJson())?.toList(),
        'count': this.count,
        'currentPage': this.currentPage,
        'pageCount': this.pageCount,
        'code': this.code,
      };
}

class ModelEvent {
  int eventId = 0;
  int accountId = 0;
  String clubAccount = "";
  String title = "";
  String createdAt = "";
  String content = "";
  String summary = "";
  String image = "";
  String url = "";
  bool isAttendee = false;
  int isClosed = 0;
  int isPaid = 0;
  int eventFee = 0;
  String eventDate = "";
  String cutOffAt = "";
  String place = "";
  String limit = "";
  int numGuestBroughtLimit = 0;
  int status = 0;
  bool isPublic = false;
  bool isPast = false;
  String btnBookLabel = "";
  String btnCancelLabel = "";
  List<Galleries> galleries = [];

  isPaidEvent() {
    return isPaid == 1;
  }

  isNotClose() {
    return isClosed == 0;
  }

  getEventFee() {
    return eventFee.toStringAsFixed(2);
  }

  ModelEvent({
    this.eventId,
    this.accountId,
    this.clubAccount,
    this.title,
    this.createdAt,
    this.content,
    this.summary,
    this.image,
    this.url,
    this.isAttendee,
    this.isClosed,
    this.isPaid,
    this.eventFee,
    this.eventDate,
    this.cutOffAt,
    this.place,
    this.limit,
    this.numGuestBroughtLimit,
    this.status,
    this.isPublic,
    this.isPast,
    this.btnBookLabel,
    this.btnCancelLabel,
    this.galleries,
  });

  ModelEvent.fromJson(Map<String, dynamic> json)
      : eventId = SafeManager.parseInt(json, 'event_id'),
        accountId = SafeManager.parseInt(json, 'account_id'),
        clubAccount = SafeManager.parseString(json, 'club_account'),
        title = SafeManager.parseString(json, 'title'),
        createdAt = SafeManager.parseString(json, 'created_at'),
        content = SafeManager.parseString(json, 'content'),
        summary = SafeManager.parseString(json, 'summary'),
        image = SafeManager.parseString(json, 'image'),
        url = SafeManager.parseString(json, 'url'),
        isAttendee = SafeManager.parseBoolean(json, 'is_attendee'),
        isClosed = SafeManager.parseInt(json, 'is_closed'),
        isPaid = SafeManager.parseInt(json, 'is_paid'),
        eventFee = SafeManager.parseInt(json, 'event_fee'),
        eventDate = SafeManager.parseString(json, 'event_date'),
        cutOffAt = SafeManager.parseString(json, 'cut_off_at'),
        place = SafeManager.parseString(json, 'place'),
        limit = SafeManager.parseString(json, 'limit'),
        numGuestBroughtLimit =
            SafeManager.parseInt(json, 'num_guest_brought_limit'),
        status = SafeManager.parseInt(json, 'status'),
        isPublic = SafeManager.parseBoolean(json, 'is_public'),
        isPast = SafeManager.parseBoolean(json, 'is_past'),
        btnBookLabel = SafeManager.parseString(json, 'btn_book_label'),
        btnCancelLabel = SafeManager.parseString(json, 'btn_cancel_label'),
        galleries = SafeManager.parseList(json, 'galleries')
            ?.map((e) => Galleries.fromJson(e))
            ?.toList();

  Map<String, dynamic> toJson() => {
        'event_id': this.eventId,
        'account_id': this.accountId,
        'club_account': this.clubAccount,
        'title': this.title,
        'created_at': this.createdAt,
        'content': this.content,
        'summary': this.summary,
        'image': this.image,
        'url': this.url,
        'is_attendee': this.isAttendee,
        'is_closed': this.isClosed,
        'is_paid': this.isPaid,
        'event_fee': this.eventFee,
        'event_date': this.eventDate,
        'cut_off_at': this.cutOffAt,
        'place': this.place,
        'limit': this.limit,
        'num_guest_brought_limit': this.numGuestBroughtLimit,
        'status': this.status,
        'is_public': this.isPublic,
        'is_past': this.isPast,
        'btn_book_label': this.btnBookLabel,
        'btn_cancel_label': this.btnCancelLabel,
        'galleries': this.galleries,
      };
}
