import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCountry',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 15, 111, 138),
          title: const Text(
            'MyCountry APP',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const HomePage(
          title: "Country",
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController control1 = TextEditingController();

  String location = "",
      desc1 = "",
      desc2 = "",
      country = "",
      capital = "",
      currency = "",
      name = "";
  double gdp = 0.0, population = 0.0, area = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 247, 235, 255),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Container(
                    height: 125,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          250, 247, 235, 255), // Add a green background color
                      border: Border.all(
                        color: const Color.fromARGB(250, 247, 235, 255),
                        width: 2,
                      ),
                    ),
                    child: Image.asset(
                      'asset/logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Search For Country",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: control1,
                      decoration: InputDecoration(
                        hintText: "Enter Country Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _getCountry,
                      child: const Text(
                        "Search",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _clear,
                      child: const Text(
                        "Clear",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (country.isNotEmpty)
                  Text(
                    name,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (country.isNotEmpty)
                  SizedBox(
                    height: 125,
                    child: Image.network(
                      'https://flagsapi.com/$country/flat/64.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                Text(
                  desc1 + desc2,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getCountry() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        title: const Text("Please Wait..."), message: const Text("Searching"));
    progressDialog.show();
    location = control1.text;

    Uri url = Uri.parse('https://api.api-ninjas.com/v1/country?name=$location');
    final response = await http.get(url,
        headers: {'X-Api-Key': 'D5erUuiTFFzYwppGv+goFQ==1AAJEFXgCylVWvUl'});
    setState(() {
      if (response.statusCode == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        if (parsedJson.length > 0) {
          currency = parsedJson[0]['currency']['name'];
          capital = parsedJson[0]['capital'];
          name = parsedJson[0]['name'];
          country = parsedJson[0]['iso2'];
          gdp = parsedJson[0]['gdp'];
          population = parsedJson[0]['population'];
          area = parsedJson[0]['surface_area'];

          desc1 =
              "1. Capital\t\t\t\t\t\t\t: $capital\n2. Currency\t\t\t: $currency\n";
          desc2 =
              "3. GDP\t\t\t\t\t\t\t\t\t\t\t\t: $gdp\n4. Population : $population\n5. Area\t\t\t\t\t\t\t\t\t\t\t\t: $area km²";
        } else {
          desc1 =
              "Country not found, please check the spelling for <$location> is correct.";
          desc2 = "";
          country = "";
        }
      } else {
        desc1 = "Error: ${response.statusCode} ${response.body}";
      }
      progressDialog.dismiss();
    });
  }

  void _clear() {
    setState(() {
      country = "";
      desc1 = "";
      desc2 = "";
      control1.clear();
    });
  }
}
