class TransactionModel {
  int? amount;
  String? key;
  String? senderId;
  String? createdAt;
  String? senderName;
  String? recipientId;
  String? recipientName;
  TransactionModel({
    this.key,
    this.amount,
    this.senderId,
    this.createdAt,
    this.senderName,
    this.recipientId,
    this.recipientName,
  });
  factory TransactionModel.fromJson(Map<dynamic, dynamic> json) =>
      TransactionModel(
        key: json["key"],
        amount: json["amount"],
        senderId: json["senderId"],
        createdAt: json["createdAt"],
        senderName: json["senderName"],
        recipientId: json["recipientId"],
        recipientName: json["recipientName"],
      );
  Map<String, dynamic> toJson() => {
        "key": key,
        "amount": amount,
        "senderId": senderId,
        "createdAt": createdAt,
        "senderName": senderName,
        "recipientId": recipientId,
        "recipientName": recipientName,
      };
}
