import 'dart:async';

import 'package:expense_tracker/google_sheets_api.dart';
import 'package:expense_tracker/loading_circle.dart';
import 'package:expense_tracker/plus_button.dart';
import 'package:expense_tracker/top_card.dart';
import 'package:expense_tracker/transaction.dart';
import 'package:flutter/material.dart';

class HompePage extends StatefulWidget {
  const HompePage({Key? key}) : super(key: key);

  @override
  State<HompePage> createState() => _HompePageState();
}

class _HompePageState extends State<HompePage> {
  // collect user input
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  // enter the new transaction into the spreadsheet
  void _enterTransaction() {
    GoogleSheetsApi.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
    );
    setState(() {});
  }

  //new transaction
  // new transaction
  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text('NEW TRANSACTION'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Expense'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          const Text('Income'),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'For what?',
                              ),
                              controller: _textcontrollerITEM,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child:
                        const Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: const Text('Enter', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //start loading unitl the data arrives
    if (GoogleSheetsApi.loading == true && timerHasStarted == false) {
      startLoading();
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TopNeuCard(
            balance: (GoogleSheetsApi.calculateIncome() - GoogleSheetsApi.calculateExpense()).toString(), 
            income: GoogleSheetsApi.calculateIncome().toString(), 
            expense: GoogleSheetsApi.calculateExpense().toString()),
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: GoogleSheetsApi.loading == true
                            ? const LoadingCircle()
                            : ListView.builder(
                                itemCount:
                                    GoogleSheetsApi.currentTransactions.length,
                                itemBuilder: (context, index) {
                                  return MyTransaction(
                                    transactionName: GoogleSheetsApi
                                        .currentTransactions[index][0],
                                    money: GoogleSheetsApi
                                        .currentTransactions[index][1],
                                    expenseOrIncome: GoogleSheetsApi
                                        .currentTransactions[index][2],
                                  );
                                }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PlusButton(
              function: _newTransaction,
            ),
          ],
        ),
      ),
    );
  }
}
