import 'package:MyCAQM/NotificationSystemComponent/notifications.dart';
import 'package:flutter/material.dart';

class Medicalhistorypageb extends StatefulWidget {
  const Medicalhistorypageb({super.key});

  @override
  State<Medicalhistorypageb> createState() => _MedicalhistorypagebState();
}

class _MedicalhistorypagebState extends State<Medicalhistorypageb> {
  Notifications notify = Notifications();
  //String? illComplain;
  List<String> illnessList = [
    'السكري',
    'ضغط الدم',
    'القلب',
    'الربو',
    'الصرع',
    'السرطان',
    'الكلى',
    'الكبد',
    'الرئة',
    'فقر الدم',
  ];
  List<String> medicineList = [
    'الإنسولين',
    'الميتفورمين',
    'الأسبرين',
    'باراسيتامول',
    'أدوية الصرع',
    'مضادات حيوية',
    'أملوديبين',
    'أتينولول',
    'الكورتيزون',
  ];
  List<String> allergiesList = [
    'حساسية الأدوية',
    'حساسية الأطعمة',
    'حساسية الحيوانات',
    'حساسية أخرى',
  ];
  List<String> addictionsList = [
    'التدخين',
    'الكحول',
    'الكافين',
    'المخدرات',
    'الأدوية المهدئة',
    'المسكنات القوية',
  ];
  List<String> geneticdiseasesList = [
    'السكري',
    'ضغط الدم',
    'القلب',
    'الربو',
    'الصرع',
    'السرطان',
    'الكلى',
    'الكبد',
    'الرئة',
    'فقر الدم',
  ];
  List<String> previousSurgeriesList = [
    'استئصال الزائدة الدودية',
    'استئصال المرارة',
    'عمليات الفتق',
    'العمليات القيصرية',
    'جراحات العظام',
    'جراحات القلب',
    'جراحات العيون',
    'جراحات الأنف والأذن والحنجرة',
    'استئصال اللوزتين',
    'عمليات المسالك البولية',
  ];
  List<String> selectedIllnesses = []; // لتخزين الأمراض المختارة
  List<String> selectedMedicines = []; // لتخزين الأدوية المختارة
  List<String> selectedAllergies = []; // لتخزين الحساسيات المختارة
  List<String> selectedAddictions = []; // لتخزين الحساسيات المختارة
  List<String> selectedGeneticDiseases = []; // لتخزين الحساسيات المختارة
  List<String> selectedPreviousSurgeries = [];
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
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: illnessList.map((item) {
                                            return CheckboxListTile(
                                              title: Text(item), // اسم العنصر
                                              value: selectedIllnesses.contains(
                                                item,
                                              ), // هل العنصر مختار؟
                                              onChanged: (checked) {
                                                setState(() {
                                                  if (checked!) {
                                                    selectedIllnesses.add(item);
                                                  } else {
                                                    selectedIllnesses.remove(
                                                      item,
                                                    );
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
                                            print(selectedIllnesses);
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
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: medicineList.map((item) {
                                            return CheckboxListTile(
                                              title: Text(item), // اسم العنصر
                                              value: selectedMedicines.contains(
                                                item,
                                              ), // هل العنصر مختار؟
                                              onChanged: (checked) {
                                                setState(() {
                                                  if (checked!) {
                                                    selectedMedicines.add(item);
                                                  } else {
                                                    selectedMedicines.remove(
                                                      item,
                                                    );
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
                                            print(selectedMedicines);
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
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: allergiesList.map((item) {
                                            return CheckboxListTile(
                                              title: Text(item), // اسم العنصر
                                              value: selectedAllergies.contains(
                                                item,
                                              ), // هل العنصر مختار؟
                                              onChanged: (checked) {
                                                setState(() {
                                                  if (checked!) {
                                                    selectedAllergies.add(item);
                                                  } else {
                                                    selectedAllergies.remove(
                                                      item,
                                                    );
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
                                            print(selectedAllergies);
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
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: addictionsList.map((item) {
                                            return CheckboxListTile(
                                              title: Text(item), // اسم العنصر
                                              value: selectedAddictions
                                                  .contains(
                                                    item,
                                                  ), // هل العنصر مختار؟
                                              onChanged: (checked) {
                                                setState(() {
                                                  if (checked!) {
                                                    selectedAddictions.add(
                                                      item,
                                                    );
                                                  } else {
                                                    selectedAddictions.remove(
                                                      item,
                                                    );
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
                                            print(selectedAddictions);
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
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: geneticdiseasesList.map((
                                            item,
                                          ) {
                                            return CheckboxListTile(
                                              title: Text(item), // اسم العنصر
                                              value: selectedGeneticDiseases
                                                  .contains(
                                                    item,
                                                  ), // هل العنصر مختار؟
                                              onChanged: (checked) {
                                                setState(() {
                                                  if (checked!) {
                                                    selectedGeneticDiseases.add(
                                                      item,
                                                    );
                                                  } else {
                                                    selectedGeneticDiseases
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
                                            print(selectedGeneticDiseases);
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
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: previousSurgeriesList.map((
                                            item,
                                          ) {
                                            return CheckboxListTile(
                                              title: Text(item), // اسم العنصر
                                              value: selectedPreviousSurgeries
                                                  .contains(
                                                    item,
                                                  ), // هل العنصر مختار؟
                                              onChanged: (checked) {
                                                setState(() {
                                                  if (checked!) {
                                                    selectedPreviousSurgeries
                                                        .add(item);
                                                  } else {
                                                    selectedPreviousSurgeries
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
                                            print(selectedPreviousSurgeries);
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
