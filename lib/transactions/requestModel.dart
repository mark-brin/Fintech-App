class RequestModel {
  String? id;
  String? amount;
  String? note;
  String? requesterId;
  String? requesterName;
  String? recipientId;
  String? recipientName;
  String? status;
  String? createdAt;

  RequestModel({
    this.id,
    this.amount,
    this.note,
    this.requesterId,
    this.requesterName,
    this.recipientId,
    this.recipientName,
    this.status,
    this.createdAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        id: json["id"],
        amount: json["amount"],
        note: json["note"],
        requesterId: json["requesterId"],
        requesterName: json["requesterName"],
        recipientId: json["recipientId"],
        recipientName: json["recipientName"],
        status: json["status"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "note": note,
        "requesterId": requesterId,
        "requesterName": requesterName,
        "recipientId": recipientId,
        "recipientName": recipientName,
        "status": status,
        "createdAt": createdAt,
      };
}
