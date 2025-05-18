import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearpay/common/enums.dart';
import 'package:clearpay/state/appstate.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clearpay/transactions/transactionModel.dart';

class TransactionState extends AppState {
  User? user;
  Query? transactionQuery;
  TransactionModel? transactionModel;
  List<TransactionModel>? _recipientsList;
  List<TransactionModel>? _transactionsList;
  List<TransactionModel>? _recipientFilterList;
  //List<TransactionModel>? _userTransactionsList;
  List<TransactionModel>? _transactionFilterList;
  final FirebaseFirestore firestoreDatabase = FirebaseFirestore.instance;
  List<TransactionModel>? get transactionsList {
    if (_transactionFilterList == null) {
      return [];
    } else {
      _transactionFilterList!.sort(
        (x, y) => DateTime.parse(x.createdAt!).compareTo(
          DateTime.parse(y.createdAt!),
        ),
      );
      return List.from(_transactionFilterList!.reversed);
    }
  }

  List<TransactionModel>? get recipientTransactionsList {
    if (_recipientFilterList == null) {
      return [];
    } else {
      _recipientFilterList!.sort(
        (x, y) => DateTime.parse(x.createdAt!).compareTo(
          DateTime.parse(y.createdAt!),
        ),
      );
      return List.from(_recipientFilterList!.reversed);
    }
  }

  List<TransactionModel>? get userTransactionsList {
    List<TransactionModel>? userTransactionsFilterList =
        recipientTransactionsList! + transactionsList!;
    if (recipientTransactionsList == null && transactionsList == null) {
      return [];
    } else {
      userTransactionsFilterList.sort(
        (x, y) => DateTime.parse(x.createdAt!).compareTo(
          DateTime.parse(y.createdAt!),
        ),
      );
      return List.from(userTransactionsFilterList.reversed);
    }
  }

  void recordTransaction(TransactionModel transaction) {
    firestoreDatabase
        .collection(TRANSACTIONS)
        .doc(transaction.key)
        .set(transaction.toJson());
    transactionModel = transaction;
    isBusy = false;
  }

  void getDataFromDatabase(BuildContext context) async {
    var state = Provider.of<AuthState>(context, listen: false);
    String userId = state.userModel!.userId!;
    try {
      isBusy = true;
      if (_transactionFilterList == null) {
        _transactionFilterList = <TransactionModel>[];
        _recipientFilterList = <TransactionModel>[];
      } else {}
      _transactionsList ??= <TransactionModel>[];
      _recipientsList ??= <TransactionModel>[];
      _transactionFilterList!.clear();
      _transactionsList!.clear();
      _recipientFilterList!.clear();
      _recipientsList!.clear();
      QuerySnapshot qSnapshot = await firestoreDatabase
          .collection(TRANSACTIONS)
          .where('senderId', isEqualTo: userId)
          .get();
      QuerySnapshot qSnapshot1 = await firestoreDatabase
          .collection(TRANSACTIONS)
          .where('recipientId', isEqualTo: userId)
          .get();
      if (qSnapshot.docs.isNotEmpty || qSnapshot1.docs.isNotEmpty) {
        for (var i = 0; i < qSnapshot.docs.length; i++) {
          var map = qSnapshot.docs[i].data() as Map<dynamic, dynamic>;
          _transactionFilterList!.add(TransactionModel.fromJson(map));
        }
        for (var j = 0; j < _transactionFilterList!.length; j++) {
          _transactionsList!.add(_transactionFilterList![j]);
        }

        for (var k = 0; k < qSnapshot1.docs.length; k++) {
          var map = qSnapshot1.docs[k].data() as Map<dynamic, dynamic>;
          _recipientFilterList!.add(TransactionModel.fromJson(map));
        }
        for (var l = 0; l < _recipientFilterList!.length; l++) {
          _recipientsList!.add(_recipientFilterList![l]);
        }
      } else {
        _transactionsList = null;
      }
      isBusy = false;
    } catch (error) {
      isBusy = false;
    }
  }
}
