import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patients.dart';
import '../services/auth_service.dart';

class PatientHome extends StatefulWidget {
  final Patient user;
  const PatientHome({super.key, required this.user});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> appointments = [];
  bool loadingAppointments = false;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => loadingAppointments = true);
    QuerySnapshot snapshot = await _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: widget.user.userId)
        .get();

    appointments = snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    setState(() => loadingAppointments = false);
  }

  Future<void> _addAppointmentDialog() async {
    String? selectedDoctor;
    DateTime? selectedDateTime;
    TextEditingController noteC = TextEditingController();

    List<QueryDocumentSnapshot> doctorDocs =
        (await _firestore
                .collection('users')
                .where('role', isEqualTo: 'doctor')
                .get())
            .docs;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("إضافة موعد جديد"),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedDoctor,
                      hint: Text("اختر الطبيب"),
                      items: doctorDocs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return DropdownMenuItem(
                          value: doc.id,
                          child: Text(
                            "${data['firstName']} ${data['lastName']}",
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() => selectedDoctor = value);
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: noteC,
                      decoration: InputDecoration(
                        labelText: "ملاحظة (اختياري)",
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setDialogState(() {
                              selectedDateTime = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                      child: Text(
                        selectedDateTime == null
                            ? "اختر التاريخ والوقت"
                            : "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year} - ${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}",
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedDoctor != null && selectedDateTime != null) {
                  await _firestore.collection('appointments').add({
                    'patientId': widget.user.userId,
                    'patientName': widget.user.fullName,
                    'doctorId': selectedDoctor,
                    'note': noteC.text,
                    'dateTime': selectedDateTime,
                  });
                  Navigator.pop(context);
                  _loadAppointments();
                }
              },
              child: Text("حفظ"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppointmentsList() {
    if (loadingAppointments) {
      return Center(child: CircularProgressIndicator());
    }
    if (appointments.isEmpty) {
      return Center(child: Text("لا توجد مواعيد بعد"));
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final a = appointments[index];
        final date = (a['dateTime'] as Timestamp).toDate();
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            title: Text("مع الطبيب: ${a['doctorId']}"),
            subtitle: Text(
              "التاريخ: ${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}\nملاحظة: ${a['note'] ?? 'لا توجد'}",
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الصفحة الرئيسية للمريض'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'مرحبًا ${widget.user.fullName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addAppointmentDialog,
              child: Text("إضافة موعد جديد"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadAppointments,
              child: Text("عرض مواعيدي"),
            ),
            SizedBox(height: 20),
            _buildAppointmentsList(),
          ],
        ),
      ),
    );
  }
}
