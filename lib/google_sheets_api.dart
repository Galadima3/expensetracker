import 'package:gsheets/gsheets.dart';
import 'package:expense_tracker/homepage.dart';

class GoogleSheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "flutter-gsheets-app-355806",
  "private_key_id": "8fa5508cbf5d70d1c18bc85df441b22435d23cd7",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC6qxvwo8o4mqaV\n4u9bhmpiq7QrND8WVXYxDoeZrVViuUFnBTIhLyYJUJU8+BblfnQ/s9fjW4lunYFh\nPDj25pB9xg0EGW4Jis3R+MPrCOJhNRKDTlQnWuTlGRxACWWhcGz5Et98BEcGNo7g\naOs9K/jAz+Ch/0R3tA4jMxPe4jLGVZw0/Fa1hq/g6jzrOwyFfdM2q+PXU/YjxR7P\nuZ+f2zGKuzSikiPQ5FrC5CZ5S3MoS9O8N0ZVejFCWQRzMBC3tw97Fe9aT7Tv0qSk\ngxZSsgkkKpH8JSUQ87BcgZqsSJV5o3PdFp9oyk3IK1W2MUqcDnACPI//iJgoCGDW\nWCLHRPNvAgMBAAECggEARF+Kc2E7H/KdlAc0jzyz2QJ1kuGnPgH9schVqNeRkAC1\nUQvZKciAUScgEt34XQUthWvVZuTPeSHeEwShBOa9BCS3/clmwb4C16cb9AokCWEM\nL+ZP8r5bWwMQkvAeNrzcXXspOt7COSdgvBgSGizyB4XdDNlYddQQ3ZnG7HvEB1sQ\nh2woT/oTfs9uu00NES/gfBemjtAsQfi+3iCmtbkTs+eizH5Vx99H1sXzEjftZsuy\nEV5vrEAOw3dUEffcAMfx38OBb8uRNkL8AW79iHKbgtyhVcqhLsZRWKa9hzyljwX2\n2VE1Vhx8I22gMjlZEPAf1+hycEq1RRZFLpqibgTTcQKBgQD7wgsen4odsY7I6iV8\nj8jpZvb/G1MIyI36grzEtDWCuVRhGHvkpXMJk7kHJ+jPYKjKH5EAoO7LKXPwqOUe\nr9jBooSP3UBJ8oTGKm97QtLmCUiEnsyXTXw7xCXs95gvwMtl5EhXy3bIkr7U7SqR\nzYE0lHNEFVadCzT64Eo+ihH2NwKBgQC90E1aIBeknUbE3Wn6aOTaf16yTtWmbPCO\nOKqaHo0Fq15fYYHb1r62SxRdtrrDnbw3vuCCp+j38EidD02Z51IwCAKKvYQebmYF\na0DH2RY9ohXY6ZK1DsYKWzUPh/BtybLpY80yFx256c4F02haD5TZUMwY+/XsZdmi\nVXtO84FQiQKBgDY63TRSf2jYB37F2R9UxZ1pPYlENIWu1c6BfPIOM3yeOUvU/1MI\nRJhqhq/A7AhHtPQdCpoNEIMYwc20Q+5xSIqlXFK1ARUstWcOWwc9JLrCgyl2H3H0\nEe+518WMq+6VY/rlyqOGw2Z/HbY2BDZ2Av/1fkLLKeYYNOhZigSgry/PAoGABMgh\nmrqiPdhkdwMo71EDKun4hb9srHOkH8EXsyg/3zuw9fAr6FDhnxAHJFE9JT5tBm59\nk20NdmmMOsCu8MieDm21Oq+Ji4a2dT59dEtovwa9TCieNId5v7sKfCitiuaA5lZI\nThG9Avj74rOvtk0cL9lUOvDmAh2SvP8wSw3hXRkCgYB9MfkLLaqdU5b8APCnyLcV\naO4G7odSUc1JnbeEuQ4iEdTIzgcH1reIc+VBpGXlRa/5SlUUAYEcMUVwBEsnqyAn\nmFjSTQwW+9mUZ9ZQa5Z6UoLALOlNRJ6iPuaXGHwybBhFrtfDzUA7eRdLtYRf8lsZ\ngRSODht6i6yWUK0XaYuwSA==\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheets-app@flutter-gsheets-app-355806.iam.gserviceaccount.com",
  "client_id": "115513638346284142396",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets-app%40flutter-gsheets-app-355806.iam.gserviceaccount.com"
}

''';

//set up and connect to the spreadsheet
  static const _spreadsheetId = '1HnYbci72RWdKz6f6qQ6ADipLxbCi7wdl5y4xxhZ-6IE';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

//some variables to keep track of...
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

//initialise the spreadsheet
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

    // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    
    // this will stop the circular loading indicator
    loading = false;
  }
  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }
  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
