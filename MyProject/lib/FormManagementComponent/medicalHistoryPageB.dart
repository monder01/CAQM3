//medicalHistoryPageB.dart
import 'package:MyCAQM/FormManagementComponent/forms.dart';
import 'package:MyCAQM/NotificationSystemComponent/notifications.dart';
import 'package:flutter/material.dart';

class Medicalhistorypageb extends StatefulWidget {
  const Medicalhistorypageb({super.key});

  @override
  State<Medicalhistorypageb> createState() => _MedicalhistorypagebState();
}

class _MedicalhistorypagebState extends State<Medicalhistorypageb> {
  Notifications notify = Notifications();
  Forms form = Forms();
  TextEditingController illComplainController = TextEditingController();
  TextEditingController illnessController = TextEditingController();
  TextEditingController medicineController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();
  TextEditingController addictionsController = TextEditingController();
  TextEditingController geneticDiseasesController = TextEditingController();
  TextEditingController previousSurgeriesController = TextEditingController();
  TextEditingController otherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("النموذج الطبي / التاريخ المرضي - النسخة ب"),
          backgroundColor: Colors.amberAccent[200],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // الشكوى الرئيسية
                    Row(
                      children: [
                        Text(
                          "الشكوى الرئيسية  :",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: illComplainController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // الامراض المزمنة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "الامراض المزمنة :",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // زوايا ناعمة
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text(
                                        "حدد المرض",
                                        textAlign: TextAlign.right,
                                      ),
                                      content: SizedBox(
                                        height: 300,
                                        width: double.maxFinite,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: form.illnessList.map((
                                            item,
                                          ) {
                                            return CheckboxListTile(
                                              title: Text(item), // اسم العنصر
                                              value: form.selectedIllnesses
                                                  .contains(
                                                    item,
                                                  ), // هل العنصر مختار؟
                                              onChanged: (checked) {
                                                setState(() {
                                                  if (checked!) {
                                                    form.selectedIllnesses.add(
                                                      item,
                                                    );
                                                  } else {
                                                    form.selectedIllnesses
                                                        .remove(item);
                                                  }
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("إلغاء"),
                                        ),
                                        SizedBox(width: 100),
                                        TextButton(
                                          onPressed: () {
                                            print(form.selectedIllnesses);
                                            Navigator.pop(context);
                                          },
                                          child: Text("تأكيد"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.amberAccent[200]),
                              SizedBox(width: 5),
                              Text(
                                "تحديد",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: illnessController,
                            decoration: InputDecoration(
                              labelText: "تحديد حر",
                              prefixIcon: Icon(Icons.edit),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // الأدوية الحالية
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "الأدوية الحالية :",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // زوايا ناعمة
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text(
                                        "حدد الادوية",
                                        textAlign: TextAlign.right,
                                      ),
                                      content: SizedBox(
                                        height: 300,
                                        width: double.maxFinite,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: form.medicineList.map((
                                            item,
                                          ) {
                                            return CheckboxListTile(
                                              title: Text(item), // اسم العنصر
                                              value: form.selectedMedicines
                                                  .contains(
                                                    item,
                                                  ), // هل العنصر مختار؟
                                              onChanged: (checked) {
                                                setState(() {
                                                  if (checked!) {
                                                    form.selectedMedicines.add(
                                                      item,
                                                    );
                                                  } else {
                                                    form.selectedMedicines
                                                        .remove(item);
                                                  }
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("إلغاء"),
                                        ),
                                        SizedBox(width: 100),
                                        TextButton(
                                          onPressed: () {
                                            print(form.selectedMedicines);
                                            Navigator.pop(context);
                                          },
                                          child: Text("تأكيد"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.amberAccent[200]),
                              SizedBox(width: 5),
                              Text(
                                "تحديد",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: medicineController,
                            decoration: InputDecoration(
                              labelText: "تحديد حر",
                              prefixIcon: Icon(Icons.edit),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // الحساسية إتجاه شيء
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "الحساسية إتجاه شيء :",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // زوايا ناعمة
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text(
                                        "حدد الحساسية",
                                        textAlign: TextAlign.right,
                                      ),
                                      content: SizedBox(
                                        height: 300,
                                        width: double.maxFinite,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: form.allergiesList.map((
                                            item,
                                          ) {
                                            return CheckboxListTile(
                                              title: Text(item), // اسم العنصر
                                              value: form.selectedAllergies
                                                  .contains(
                                                    item,
                                                  ), // هل العنصر مختار؟
                                              onChanged: (checked) {
                                                setState(() {
                                                  if (checked!) {
                                                    form.selectedAllergies.add(
                                                      item,
                                                    );
                                                  } else {
                                                    form.selectedAllergies
                                                        .remove(item);
                                                  }
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("إلغاء"),
                                        ),
                                        SizedBox(width: 100),
                                        TextButton(
                                          onPressed: () {
                                            print(form.selectedAllergies);
                                            Navigator.pop(context);
                                          },
                                          child: Text("تأكيد"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.amberAccent[200]),
                              SizedBox(width: 5),
                              Text(
                                "تحديد",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: allergiesController,
                            decoration: InputDecoration(
                              labelText: "تحديد حر",
                              prefixIcon: Icon(Icons.edit),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // الادمان إتجاه شيء
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "الادمان إتجاه شيء :",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // زوايا ناعمة
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text(
                                        "حدد الادمان",
                                        textAlign: TextAlign.right,
                                      ),
                                      content: SizedBox(
                                        height: 300,
                                        width: double.maxFinite,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: form.addictionsList.map((
                                            item,
                                          ) {
                                            return CheckboxListTile(
                                              title: Text(item), // اسم العنصر
                                              value: form.selectedAddictions
                                                  .contains(
                                                    item,
                                                  ), // هل العنصر مختار؟
                                              onChanged: (checked) {
                                                setState(() {
                                                  if (checked!) {
                                                    form.selectedAddictions.add(
                                                      item,
                                                    );
                                                  } else {
                                                    form.selectedAddictions
                                                        .remove(item);
                                                  }
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("إلغاء"),
                                        ),
                                        SizedBox(width: 100),
                                        TextButton(
                                          onPressed: () {
                                            print(form.selectedAddictions);
                                            Navigator.pop(context);
                                          },
                                          child: Text("تأكيد"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.amberAccent[200]),
                              SizedBox(width: 5),
                              Text(
                                "تحديد",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: addictionsController,
                            decoration: InputDecoration(
                              labelText: "تحديد حر",
                              prefixIcon: Icon(Icons.edit),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // امراض وراثية
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("أمراض وراثية :", style: TextStyle(fontSize: 16)),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // زوايا ناعمة
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text(
                                        "حدد المرض",
                                        textAlign: TextAlign.right,
                                      ),
                                      content: SizedBox(
                                        height: 300,
                                        width: double.maxFinite,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: form.geneticdiseasesList.map((
                                            item,
                                          ) {
                                            return CheckboxListTile(
                                              title: Text(item), // اسم العنصر
                                              value: form
                                                  .selectedGeneticDiseases
                                                  .contains(
                                                    item,
                                                  ), // هل العنصر مختار؟
                                              onChanged: (checked) {
                                                setState(() {
                                                  if (checked!) {
                                                    form.selectedGeneticDiseases
                                                        .add(item);
                                                  } else {
                                                    form.selectedGeneticDiseases
                                                        .remove(item);
                                                  }
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("إلغاء"),
                                        ),
                                        SizedBox(width: 100),
                                        TextButton(
                                          onPressed: () {
                                            print(form.selectedGeneticDiseases);
                                            Navigator.pop(context);
                                          },
                                          child: Text("تأكيد"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.amberAccent[200]),
                              SizedBox(width: 5),
                              Text(
                                "تحديد",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: geneticDiseasesController,
                            decoration: InputDecoration(
                              labelText: "تحديد حر",
                              prefixIcon: Icon(Icons.edit),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // عمليات جراحية سابقة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "عمليات جراحية سابقة :",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // زوايا ناعمة
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text(
                                        "حدد العملية",
                                        textAlign: TextAlign.right,
                                      ),
                                      content: SizedBox(
                                        height: 300,
                                        width: double.maxFinite,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: form.previousSurgeriesList.map((
                                            item,
                                          ) {
                                            return CheckboxListTile(
                                              title: Text(item), // اسم العنصر
                                              value: form
                                                  .selectedPreviousSurgeries
                                                  .contains(
                                                    item,
                                                  ), // هل العنصر مختار؟
                                              onChanged: (checked) {
                                                setState(() {
                                                  if (checked!) {
                                                    form.selectedPreviousSurgeries
                                                        .add(item);
                                                  } else {
                                                    form.selectedPreviousSurgeries
                                                        .remove(item);
                                                  }
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("إلغاء"),
                                        ),
                                        SizedBox(width: 100),
                                        TextButton(
                                          onPressed: () {
                                            print(
                                              form.selectedPreviousSurgeries,
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Text("تأكيد"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.amberAccent[200]),
                              SizedBox(width: 5),
                              Text(
                                "تحديد",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: previousSurgeriesController,
                            decoration: InputDecoration(
                              labelText: "تحديد حر",
                              prefixIcon: Icon(Icons.edit),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // ملاحظات
                    Center(
                      child: TextField(
                        controller: otherController,
                        decoration: InputDecoration(
                          labelText: "ملاحظات اخرى",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.note_add),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // زر حفظ
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              5,
                            ), // زوايا ناعمة
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "حفظ و إرسال",
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.save, color: Colors.black45),
                          ],
                        ),
                        onPressed: () async {
                          final confirmed = await notify.showConfirmationDialog(
                            context,
                            'هل أنت متأكد من حفظ بيانات السجل الطبي؟ \n سيتم تشخيص حالتك بناءا على البيانات المدخلة', // رسالة التأكيد
                          );
                          if (!confirmed) {
                            return; //اذا لم يؤكد المستخدم، لا تفعل شيئًا
                          }
                          await form.saveToFirebase(
                            mainComplaint: illComplainController.text,
                            illnessFree: illnessController.text,
                            medicineFree: medicineController.text,
                            allergiesFree: allergiesController.text,
                            addictionsFree: addictionsController.text,
                            geneticDiseasesFree: geneticDiseasesController.text,
                            previousSurgeriesFree:
                                previousSurgeriesController.text,
                            otherNotes: otherController.text,
                            context: context,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("تم حفظ البيانات بنجاح!")),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
