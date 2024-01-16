import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleform_api/secondPage.dart';
import 'package:dio/dio.dart';

class Front_Page extends StatefulWidget {
  const Front_Page({super.key});

  @override
  State<Front_Page> createState() => Front_PageState();
}

bool isDisabled = false;

class Front_PageState extends State<Front_Page> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
              height: 50,
              width: 120,
              child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please wait while the details are fetched!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Second_Page()));
                  },
                  child: const Text(
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black),
                      "View Cards")))
        ]),
        SizedBox(
          width: 200,
          child: TextField(
            controller: nameController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 200,
          child: TextField(
            controller: emailController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 200,
          child: TextField(
            controller: addressController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Address',
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 200,
          child: TextField(
            controller: mobileController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Mobile',
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10), // Limit to 10 characters
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            String name = nameController.text;
            String email = emailController.text;
            String address = addressController.text;
            String mobileNum = mobileController.text;

            if (name.isNotEmpty &&
                email.isNotEmpty &&
                address.isNotEmpty &&
                mobileNum.isNotEmpty) {
              if (!isValidEmail(email)) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please enter the email in correct format!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else if (mobileNum.length != 10) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please enter the correct mobile number!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                if (isDisabled == false) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please wait for the data to be submitted!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                  await submitForm(name, email, address, mobileNum);

                  await Future.delayed(const Duration(seconds: 1));

                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Second_Page()),
                  );
                  clearForm();
                  print('Form Submitted Successfully!');
                }
              }
            } else {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Please fill all the fields!',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    ));
  }

  bool isValidEmail(String email) {
    // Email validation using regex with specific domain endings
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@(?:[a-zA-Z0-9]+\.)+(?:com|gov|in)$");
    return emailRegExp.hasMatch(email);
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    addressController.clear();
    mobileController.clear();
  }

  Future<void> submitForm(String name, email, address, mobileNum) async {
    isDisabled = true;
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://docs.google.com/forms/d/e/1FAIpQLSd1zHtMH3vbysWm6RdN12qVrw3rRFSZYz2dqjs2tc3qOHh-EQ/formResponse',
        queryParameters: {
          'entry.2005620554': name,
          'entry.1045781291': email,
          'entry.1065046570': address,
          'entry.1166974658': mobileNum,
        },
      );

      if (response.statusCode == 200) {
        print('Form submitted successfully!');
      } else {
        print('Error submitting form. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
