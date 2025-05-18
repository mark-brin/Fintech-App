import 'package:flutter/foundation.dart';
import 'package:clearpay/common/enums.dart';
import 'package:clearpay/state/appstate.dart';
import 'package:clearpay/auth/usermodel.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:clearpay/state/transactionState.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clearpay/transactions/requestModel.dart';
import 'package:clearpay/transactions/transactionModel.dart';

class RequestsState extends AppState {
  List<RequestModel>? _sentRequests;
  List<RequestModel>? _receivedRequests;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<RequestModel> get sentRequests {
    if (_sentRequests == null) {
      return [];
    } else {
      _sentRequests!.sort(
        (a, b) => DateTime.parse(b.createdAt!).compareTo(
          DateTime.parse(a.createdAt!),
        ),
      );
      return _sentRequests!;
    }
  }

  List<RequestModel> get receivedRequests {
    if (_receivedRequests == null) {
      return [];
    } else {
      _receivedRequests!.sort(
        (a, b) => DateTime.parse(b.createdAt!).compareTo(
          DateTime.parse(a.createdAt!),
        ),
      );
      return _receivedRequests!;
    }
  }

  List<RequestModel> get pendingSentRequests {
    return sentRequests
        .where((request) => request.status == "pending")
        .toList();
  }

  List<RequestModel> get pendingReceivedRequests {
    return receivedRequests
        .where((request) => request.status == "pending")
        .toList();
  }

  List<RequestModel> get completedRequests {
    List<RequestModel> allCompleted = [];

    if (_sentRequests != null) {
      allCompleted.addAll(
          _sentRequests!.where((request) => request.status != "pending"));
    }

    if (_receivedRequests != null) {
      allCompleted.addAll(
          _receivedRequests!.where((request) => request.status != "pending"));
    }

    allCompleted.sort((a, b) =>
        DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));

    return allCompleted;
  }

  Future<void> createRequest(RequestModel request) async {
    try {
      isBusy = true;
      final docRef = firestore.collection(REQUESTS).doc();
      request.id = docRef.id;
      await docRef.set(request.toJson());
      isBusy = false;
    } catch (e) {
      isBusy = false;
      if (kDebugMode) {
        print("Error creating request: $e");
      }
    }
  }

  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      isBusy = true;
      await firestore
          .collection(REQUESTS)
          .doc(requestId)
          .update({"status": status});
      isBusy = false;
    } catch (e) {
      isBusy = false;
      if (kDebugMode) {
        print("Error updating request: $e");
      }
    }
  }

  Future<void> fetchRequests(String userId) async {
    try {
      isBusy = true;

      // Initialize lists
      _sentRequests = [];
      _receivedRequests = [];

      // Fetch sent requests
      final sentSnapshot = await firestore
          .collection(REQUESTS)
          .where("requesterId", isEqualTo: userId)
          .get();

      for (var doc in sentSnapshot.docs) {
        _sentRequests!.add(RequestModel.fromJson(doc.data()));
      }

      // Fetch received requests
      final receivedSnapshot = await firestore
          .collection(REQUESTS)
          .where("recipientId", isEqualTo: userId)
          .get();

      for (var doc in receivedSnapshot.docs) {
        _receivedRequests!.add(RequestModel.fromJson(doc.data()));
      }

      isBusy = false;
    } catch (e) {
      isBusy = false;
      print("Error fetching requests: $e");
    }
  }

  Future<void> processPayment(RequestModel request, AuthState authState,
      TransactionState transactionState) async {
    try {
      isBusy = true;

      // Check if user has enough balance
      int amount = int.parse(request.amount!);
      if (authState.userModel!.balance! < amount) {
        throw "Insufficient balance";
      }

      // Update sender's balance
      int remAmount = authState.userModel!.balance! - amount;
      authState.userModel!.balance = remAmount;
      var user = UserModel(
        balance: remAmount,
        email: authState.userModel!.email,
        userId: authState.userModel!.userId,
        profilePic: authState.userModel!.profilePic,
        displayName: authState.userModel!.displayName,
      );
      authState.updateUserProfile(user);

      // Update recipient's balance
      QuerySnapshot recipientQuery = await firestore
          .collection(USERS)
          .where('userId', isEqualTo: request.requesterId)
          .limit(1)
          .get();

      if (recipientQuery.docs.isEmpty) {
        throw "Recipient not found";
      }

      DocumentSnapshot recipientSnapshot = recipientQuery.docs.first;
      var recipientData = recipientSnapshot.data() as Map<String, dynamic>;
      var recipientBalance = recipientData['balance'] ?? 0;

      // Update recipient's balance
      int recipientNewBalance = recipientBalance + amount;
      await firestore
          .collection(USERS)
          .doc(request.requesterId)
          .update({'balance': recipientNewBalance});

      // Record transaction
      TransactionModel transaction = TransactionModel(
        amount: amount,
        recipientName: request.requesterName,
        senderId: authState.userModel!.userId,
        createdAt: DateTime.now().toString(),
        recipientId: request.requesterId,
        senderName: authState.userModel!.displayName,
      );
      transactionState.recordTransaction(transaction);

      // Update request status
      await updateRequestStatus(request.id!, "completed");

      isBusy = false;
    } catch (e) {
      isBusy = false;
      throw e.toString();
    }
  }
}
