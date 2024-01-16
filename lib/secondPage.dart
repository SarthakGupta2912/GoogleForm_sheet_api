import 'dart:io';

import 'package:flutter/material.dart';
import 'package:googleform_api/main.dart';
import 'package:gsheets/gsheets.dart';

enum itemList { Delete }
List<List<String>> rowsList = [];
// your google auth credentials
const _credentials = r'''
{
  "type": "service_account",
  "project_id": "test-7efe0",
  "private_key_id": "8c8d408e17941d779d7baa8c68ab2c7cf2223d9a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCkVxJeMLcl1Dht\nyqe6OCSuSAoDLJsCnA/mjZQ3Kl9+dhiOCKZWW1OaPZJkTJUtPpdVBKFzOEkICK0u\nOEUVE+fhRS1SbTPS8iwnJyE7O8/DDNlH2MvjQA78CfO2HtFhIQjXRWOXvEIgKiAY\nIcs435RAPsohKbV6U6wRA5KJ/iCrvI2EKOXxlLO1Uy8kulujs/VYiwjXypIvjC1v\nDECTizj+7iAUMbR0LTyje2Ay4xHsuqTxW3FOOtll5P8BCN7FVYFU7BYIXgjqSmgM\nvackxzcwWIQho+jOe1DGvTZ8BJNiU0bY06o/r+yw7Qe5CVvkKzuZ+Z9EbZ9a4qcb\nkKbybACdAgMBAAECggEANPNJG8geerXSKK3vNPT5/J2BfFxW5ZRbGzHq24tvkVOD\nvd/TmGd8nGnSTTbPqfBM2jvPuUwdW9VP12CSAaSUReUAIVrGI+WbjFHzRx6SZoox\nSBD2QJZXPaYHPFrZo639Jz9YQ3+I3swz4xKgZAbFwZ15iw3hRzTGcATypjuXUz29\nMMf87iU8MCZAgn3tvE9Sn99iNaUJ/8iuA3jq8LjMMpe2RPSYlhQm+sxRzVVxqJ92\nrS8m4Ip2ujes0Vge7ibJBa0ZIKKnfPtWX1kdZsoPLHJ9hNNYalTXXByWMLN6pixs\nKEtm19SOucLLfxiIuVBDC4Pw2M7DD7XwDuWPlEOnEQKBgQDS7fMD4dZq+koNItHd\nitjfzMoqZiLATzVrWwccH9ZsJoPoPEUFHUC8kzKx6wSUhrlBcpqrQ6je4n1GPN2z\n8DBrRoRF+ASgFCG5Ew/3G1oU2qJ8vTqI47sgtBZTWcTtuFwxcVz/TrBYCiDzAmJR\nCb+8SkZItpMWOESidB3QebyvgwKBgQDHdKNpCwNcHIcQWLs+sDFeMyFlMkhvtuR8\nAKKrlcCStVrVx8ov3WOKTv7Eww2W+m6bD7pfJANqPDw7+pFK3A8ICTDiLftUYGGT\nJ9nbS27nlAF2NZq5/6Ls5aZsQmFC6PhdXFC1FgGu9KkBJcCBAsFHZoFJsbILdQuF\nQAooWxB1XwKBgFz9AdGIUlq/FL5Nx29/srSXN9kRRei6ArbdXnkLoB/1qtlLGLJ0\nfwGjcwn0rgQ8kJdFyuIN5fi8qLW6R5L4JKBmahHekUtxFJzexn8N09y1tkR/t7p5\nixmTyvPb83FJgXtamsEDE8L8VCJNvsIzJhAAPpP3yUhWbgugXTR3NrO5AoGAaIRA\nVP0GZ7AzPmegxvrBA+G7MDInLxMhq7ERjOROIxKRZNDqrCZQ0NsQOb8UUfctGmgl\ne1F90J972No2ZInn/ogCa6M4vkA7IUeSq41dslAma/EvASRqFcVJbhVirhMygomr\naRj9DNb78LP9qhztdyLJwPoymDpfLRYfvIHrn/UCgYBlrcE8U/toV6BkmqyaIVs5\nnOsH1OwJoschlHVV45kzTaHIlmLOGhXRps+B7LHt0ixsBPyexJyzZA937bAugBc3\nlU+AR+CD/1tVGRnHVDXNHaNwz5BGX+eIbqFlcEsieZ1Xs0p662ekToGx4gL/vs8Q\nYGgYFb7aOTtEFKWUSljvCw==\n-----END PRIVATE KEY-----\n",
  "client_email": "test-7efe0@appspot.gserviceaccount.com",
  "client_id": "102344811180720850390",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/test-7efe0%40appspot.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';
// your spreadsheet id
const _spreadsheetId = '1OLW51wt7q6ptbGlhpd9MKJsTOBBLS7wx2jTMV18zzn0';
// init GSheets
final gsheets = GSheets(_credentials);

Spreadsheet? ss;
Worksheet? sheet;

class Second_Page extends StatefulWidget {
  const Second_Page({Key? key}) : super(key: key);

  @override
  State<Second_Page> createState() => _Second_PageState();
}

class _Second_PageState extends State<Second_Page> {
  late Future<int> rowCountFuture;

  @override
  void initState() {
    super.initState();
    rowCountFuture = initializeSheets();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3));
    return Scaffold(
      body: Center(
        child: FutureBuilder<int>(

          future: rowCountFuture,
          builder: (context, AsyncSnapshot<int> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Text('Check your internet connection, If checked then contact Sarthak Gupta!', textAlign: TextAlign.center,);
              //return Text('Error: ${snapshot.error}');
            } else {
              int? rowCount = snapshot.data;
              print("rowCount: $rowCount");

              return ListView.builder(
                itemCount: rowCount,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      children: [

                        Align(
                          alignment: Alignment.topRight,
                          child: PopupMenuButton<itemList>(
                            onSelected: (itemList result) {
                              if (result == itemList.Delete) {
                                // Perform delete action
                                print('Deleted!');
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<itemList>>[
                              const PopupMenuItem<itemList>(
                                value: itemList.Delete,
                                child: Text('Delete'),
                              ),
                            ],
                            icon: const Icon(Icons.more_vert),
                          ),
                        ),
                        Text("Name: ${rowsList[index][1]}"),
                        Text("Email: ${rowsList[index][2]}"),
                        Text("Address: ${rowsList[index][3]}"),
                        Text("Mobile: ${rowsList[index][4]}"),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<int> initializeSheets() async {
    ss ??= await gsheets.spreadsheet(_spreadsheetId);
    sheet ??= ss?.worksheetByTitle('Form Responses 1');

    if (sheet != null) {
      return countRowsWithData(sheet!);
    } else {
      print("Error: Worksheet is null");
      throw Exception("Failed to initialize sheets");
    }
  }

  Future<int> countRowsWithData(Worksheet sheet) async {
    int? rowCount = sheet.rowCount;
    int count = 0;

    for (int i = 2; i <= rowCount; i++) {
      List<String>? rows = await sheet.values.row(i, length: -1);
      print("hi $i $rows");
      if (rows.isNotEmpty) {
        count++;
        rowsList.add(rows);
      } else {
        break;
      }
    }
    return count;
  }
}
