import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:test/models/event.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key, required this.uid});

  final String uid;

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> _categories = [];
  List<String> _categoryTypes = [];
  String _selectedCategoryType = 'Certificate';
  String _selectedTitle = '';
  List<int> _expiryYears = [];
  int? _selectedExpiryYear;
  int? _renewalDays;
  String _enteredTitle = '';
  String _enteredDescription = '';
  bool _isInvalid = false;
  bool _isLoading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchCategoryTypes();
    _fetchCategories();
  }

  Future<void> _fetchCategoryTypes() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/api/eventcategories/types'));

    if (response.statusCode == 200) {
      setState(() {
        _categoryTypes = List<String>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load category types');
    }
  }

  Future<void> _fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8080/api/eventcategories'));

    if (response.statusCode == 200) {
      setState(() {
        _categories = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void _fetchRenewlDays(String type, String? title) async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/api/eventcategories/renewal-days?type=$type&title=$title'));

    if (type != "Certificate" || title == "") {
      return;
    }

    if (response.statusCode == 200) {
      setState(() {
        _renewalDays = json.decode(response.body);
      });
      // print(_renewalDays);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void _onCategorySelected(String type) {
    setState(() {
      _selectedCategoryType = type;
      _selectedTitle = '';
      _expiryYears = [];
      _selectedExpiryYear = null;
      _isInvalid = false;
    });
  }

  void _onTitleSelected(String title, List<dynamic> years) {
    setState(() {
      _selectedTitle = title;
      _expiryYears = years.cast<int>(); // Cast to List<int>
      _selectedExpiryYear = null;
      _isInvalid = false;
    });
  }

  void _onExpiryYearSelected(int year) {
    setState(() {
      _selectedExpiryYear = year;
      _isInvalid = false;
    });
  }

  bool _isCertificate() {
    return _selectedCategoryType == "Certificate";
  }

  DateTime getExpiryDate(DateTime date) {
    return DateTime(date.year + _selectedExpiryYear!, date.month, date.day);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onSubmit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    if (_isCertificate() && _selectedExpiryYear == null) {
      setState(() {
        _isInvalid = true;
      });
      return;
    }

    if (_isCertificate() && _selectedTitle == "") {
      setState(() {
        _isInvalid = true;
      });
      return;
    }

    _fetchRenewlDays(_selectedCategoryType, _selectedTitle);

    // print(_renewalDays);

    // Create an Event object
    Event event = Event(
      id: 100, // You can generate a unique ID here if needed
      uid: widget.uid,
      category: _selectedCategoryType,
      title: _enteredTitle,
      content: _enteredDescription,
      issueDate: _isCertificate() ? _selectedDate : null,
      expiryDate:
          _isCertificate() ? getExpiryDate(_selectedDate) : _selectedDate,
      renewalDays: _renewalDays,
      recurring: !_isCertificate(),
      reminderTypes: [], // Add reminder types if needed
    );

    // print(event.recurring);

    setState(() {
      _isLoading = true;
    });

    // Send POST request
    final url = Uri.parse("http://10.0.2.2:8080/api/events");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "uid": event.uid,
        "category": event.category,
        "title": event.title,
        "content": event.content,
        "issueDate": event.issueDate != null
            ? DateFormat('yyyy-MM-dd').format(event.issueDate!)
            : null,
        "expiryDate": DateFormat('yyyy-MM-dd').format(event.expiryDate!),
        "renewalDays": event.renewalDays,
        "reminders": {"recurring": event.recurring, "types": []},
      }),
    );

    // print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.pop(context);

      // Handle successful response
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Created'),
          content: Text(response.body),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text(
                'Okay',
              ),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      // Handle error response
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive Sizing
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSizeTitle = screenWidth * 0.05;
    double fontSizeLabel = screenWidth * 0.04;
    double padding = screenWidth * 0.04;
    double spacing = screenHeight * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event', style: TextStyle(fontSize: fontSizeTitle)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Categories:',
                    style: TextStyle(
                        fontSize: fontSizeLabel, fontWeight: FontWeight.bold)),
                SizedBox(height: spacing),
                Wrap(
                  spacing: spacing,
                  children: _categoryTypes.map((type) {
                    return ChoiceChip(
                      label:
                          Text(type, style: TextStyle(fontSize: fontSizeLabel)),
                      selected: _selectedCategoryType == type,
                      onSelected: (selected) {
                        if (selected) {
                          _onCategorySelected(type);
                        }
                      },
                    );
                  }).toList(),
                ),
                if (_selectedCategoryType == 'Certificate') ...[
                  SizedBox(height: spacing),
                  Wrap(
                    spacing: spacing,
                    children: _categories
                        .where((category) => category['type'] == 'Certificate')
                        .map((certificate) {
                      return ChoiceChip(
                        label: Text(certificate['title'],
                            style: TextStyle(fontSize: fontSizeLabel)),
                        selected: _selectedTitle == certificate['title'],
                        onSelected: (selected) {
                          if (selected) {
                            _onTitleSelected(certificate['title'],
                                certificate['expiryYears']);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
                if (_expiryYears.isNotEmpty) ...[
                  SizedBox(height: spacing),
                  Wrap(
                    spacing: spacing,
                    children: _expiryYears.map((year) {
                      return ChoiceChip(
                        label: Text('$year yrs',
                            style: TextStyle(fontSize: fontSizeLabel)),
                        selected: _selectedExpiryYear == year,
                        onSelected: (selected) {
                          if (selected) {
                            _onExpiryYearSelected(year);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
                if (_isInvalid) ...[
                  SizedBox(height: spacing),
                  Text(
                    "Select a certificate and the number of years",
                    style: TextStyle(
                        color: Colors.redAccent, fontSize: fontSizeLabel),
                  ),
                ],
                SizedBox(height: spacing),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'e.g. Driver\'s License',
                    labelStyle: TextStyle(fontSize: fontSizeLabel),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a title.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredTitle = value!;
                  },
                  style: TextStyle(fontSize: fontSizeLabel),
                ),
                SizedBox(height: spacing),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'e.g. Renew driver\'s License',
                    labelStyle: TextStyle(fontSize: fontSizeLabel),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a description.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredDescription = value!;
                  },
                  style: TextStyle(fontSize: fontSizeLabel),
                ),
                SizedBox(height: spacing),
                Row(
                  children: [
                    Text(
                      _selectedCategoryType == "Certificate"
                          ? 'Issued Date:'
                          : 'Date',
                      style: TextStyle(fontSize: fontSizeLabel),
                    ),
                    SizedBox(width: spacing),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                          DateFormat('dd - MM - yyyy').format(_selectedDate),
                          style: TextStyle(fontSize: fontSizeLabel)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _isLoading
          ? const CircularProgressIndicator()
          : FloatingActionButton.extended(
              onPressed: _onSubmit,
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: Icon(
                Icons.add_alert,
                color: Colors.white,
                size: fontSizeLabel,
              ),
              label: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSizeLabel,
                ),
              ),
            ),
    );
  }
}
