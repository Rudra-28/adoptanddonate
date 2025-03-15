import 'package:adoptanddonate_new/forms/provider/cat_provider.dart';
import 'package:adoptanddonate_new/screens/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorDogForm extends StatefulWidget {
  DonorDogForm({super.key});
  static const String id = "dog-form";

  @override
  State<DonorDogForm> createState() => _DonorDogFormState();
}

class _DonorDogFormState extends State<DonorDogForm> {


  final _formKey = GlobalKey<FormState>();

  var _breedController = TextEditingController();
  var _ageController = TextEditingController();
  var _genderController = TextEditingController();
  var _weightController = TextEditingController();
  var _vaccinationController = TextEditingController();
  var _sterilizationController = TextEditingController();
  var _temperamentController = TextEditingController();
  var _addressController = TextEditingController();
 

  validate() {
    if (_formKey.currentState!.validate()) {
      print("validated");
    }
  }

  List<String> _genderList = ['Male', 'Female'];
  List<String> _vaccinationList = [
    'Vaccinated',
    'Not Vaccinated',
    'Partially Vaccinated'
  ];
  List<String> _sterilizationList = ['Sterilized', 'Not Sterilized'];
  List<String> _temperamentList = [
    'Calm',
    'Friendly',
    'Independent',
    'Cautious',
    'Aggressive'
  ];

  Widget _appBar(title, FieldValue) {
    return AppBar(
      backgroundColor: Colors.grey[100],
      iconTheme: const IconThemeData(color: Colors.black),
      automaticallyImplyLeading: false,
      title: Text(
        "$title > $FieldValue",
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
      elevation: 0,
    );
  }

  Widget _breedlist() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _appBar(
              Provider.of<CategoryProvider>(context, listen: false)
                  .selectedCategory,
              'Breed'),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Provider.of<CategoryProvider>(context, listen: false)
                  .doc['breed']
                  .length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    setState(() {
                      _breedController.text =
                          Provider.of<CategoryProvider>(context, listen: false)
                              .doc['breed'][index];
                    });
                    Navigator.pop(context);
                  },
                  title: Text(
                      Provider.of<CategoryProvider>(context, listen: false)
                          .doc['breed'][index]),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _listview({FieldValue, list, textController}) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(
                Provider.of<CategoryProvider>(context, listen: false)
                    .selectedCategory,
                FieldValue),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        textController.text = list[index];
                      });
                      Navigator.pop(context);
                    },
                    title: Text(list[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: const Text(
          "Add some details",
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _inputField("Breed", _breedController, enabled: false,
                      onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => _breedlist());
                  }),
                  _ageWeightField(
                      "Age", _ageController, "years", TextInputType.number),
                  _ageWeightField(
                      "Weight", _weightController, "kg", TextInputType.number),
                  _inputField("Gender", _genderController, enabled: false,
                      onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => _listview(
                            FieldValue: 'Gender',
                            list: _genderList,
                            textController: _genderController));
                  }),
                  _inputField("Vaccination Status", _vaccinationController,
                      enabled: false, onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => _listview(
                            FieldValue: 'Vaccination',
                            list: _vaccinationList,
                            textController: _vaccinationController));
                  }),
                  _inputField("Sterilization Status", _sterilizationController,
                      enabled: false, onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => _listview(
                            FieldValue: 'Sterilization',
                            list: _sterilizationList,
                            textController: _sterilizationController));
                  }),
                  _inputField("Temperament", _temperamentController,
                      enabled: false, onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => _listview(
                            FieldValue: 'Temperament',
                            list: _temperamentList,
                            textController: _temperamentController));
                  }),
                     _inputField("Seller Address", _addressController,
                      enabled: false, onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => _listview(
                            FieldValue: 'Donor Address',
                            textController: _addressController));
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            minimumSize: const Size(double.infinity, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: validate,
          child: const Text("Next",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller,
      {TextInputType? keyboardType, bool enabled = true, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: enabled ? null : onTap,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please complete required fields';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _ageWeightField(String label, TextEditingController controller,
      String unit, TextInputType keyboardType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: label,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8)),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please complete required fields';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(unit, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
