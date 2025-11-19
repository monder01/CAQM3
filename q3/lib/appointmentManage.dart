import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editAppointmentPage.dart';

class AdminPatientAppointmentsPage extends StatefulWidget {
  const AdminPatientAppointmentsPage({super.key});

  @override
  State<AdminPatientAppointmentsPage> createState() =>
      _AdminPatientAppointmentsPageState();
}

class _AdminPatientAppointmentsPageState
    extends State<AdminPatientAppointmentsPage> {
  TextEditingController searchController = TextEditingController();
  String searchPhone = '';
  String? selectedPatientId;

  // حجز موعد جديد
  String? selectedDoctorId;
  String? selectedDay;
  String? selectedTime;
  List<String> availableDays = [];
  List<String> availableTimes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Patient Appointments"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 حقل البحث عن المريض برقم الهاتف
            TextField(
              controller: searchController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Search Patient by Phone Number",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      searchPhone = searchController.text.trim();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // 🔹 عرض المريض إذا وجد
            if (searchPhone.isNotEmpty)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('Phone Number', isEqualTo: searchPhone)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());

                    var patients = snapshot.data!.docs;

                    if (patients.isEmpty)
                      return Center(child: Text("Patient not found"));

                    var patient = patients.first;
                    selectedPatientId = patient.id;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "users: ${patient['Full Name']}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Phone: ${patient['Phone Number']}",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),

                          // 🔹 عرض مواعيد المريض
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Appointments')
                                .where('userId', isEqualTo: selectedPatientId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();

                              var appointments = snapshot.data!.docs;

                              if (appointments.isEmpty)
                                return Text("No appointments for this patient");

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  var appointment = appointments[index];
                                  String doctorId = appointment['doctorId'];

                                  return FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('Doctors')
                                        .doc(doctorId)
                                        .get(),
                                    builder: (context, doctorSnapshot) {
                                      if (!doctorSnapshot.hasData)
                                        return ListTile(
                                          title: Text("Loading doctor..."),
                                        );

                                      var doctorData = doctorSnapshot.data!;
                                      String doctorName =
                                          doctorData['Full Name'] ?? 'Unknown';

                                      return Card(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: ListTile(
                                          title: Text("Doctor: $doctorName"),
                                          subtitle: Text(
                                            "Day: ${appointment['day']} | Time: ${appointment['time']}",
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditAppointmentPage(
                                                            appointmentId:
                                                                appointment.id,
                                                            currentDay:
                                                                appointment['day'],
                                                            currentTime:
                                                                appointment['time'],
                                                          ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                        'Appointments',
                                                      )
                                                      .doc(appointment.id)
                                                      .delete();
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Appointment deleted",
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 20),

                          // 🔹 قسم حجز موعد جديد
                          Divider(thickness: 1, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "Book New Appointment",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),

                          // اختيار الدكتور
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Doctors')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();

                              var docs = snapshot.data!.docs;
                              return DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "Select Doctor",
                                ),
                                items: docs.map((doc) {
                                  return DropdownMenuItem(
                                    value: doc.id,
                                    child: Text(doc['Full Name']),
                                  );
                                }).toList(),
                                onChanged: (value) async {
                                  setState(() {
                                    selectedDoctorId = value;
                                    selectedDay = null;
                                    selectedTime = null;
                                    availableDays = [];
                                    availableTimes = [];
                                  });

                                  var doctorDoc = await FirebaseFirestore
                                      .instance
                                      .collection('Doctors')
                                      .doc(value)
                                      .get();

                                  setState(() {
                                    availableDays = List<String>.from(
                                      doctorDoc['availableDays'] ?? [],
                                    );
                                    availableTimes = List<String>.from(
                                      doctorDoc['availableTimes'] ?? [],
                                    );
                                  });
                                },
                                value: selectedDoctorId,
                              );
                            },
                          ),
                          SizedBox(height: 10),

                          // اختيار اليوم
                          if (availableDays.isNotEmpty)
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Select Day",
                              ),
                              items: availableDays.map((day) {
                                return DropdownMenuItem(
                                  value: day,
                                  child: Text(day),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  setState(() => selectedDay = value),
                              value: selectedDay,
                            ),
                          SizedBox(height: 10),

                          // اختيار الوقت
                          if (availableTimes.isNotEmpty)
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Select Time",
                              ),
                              items: availableTimes.map((time) {
                                return DropdownMenuItem(
                                  value: time,
                                  child: Text(time),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  setState(() => selectedTime = value),
                              value: selectedTime,
                            ),
                          SizedBox(height: 10),

                          // زر الحجز
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (selectedDoctorId == null ||
                                    selectedDay == null ||
                                    selectedTime == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Please select all fields"),
                                    ),
                                  );
                                  return;
                                }

                                await FirebaseFirestore.instance
                                    .collection('Appointments')
                                    .add({
                                      'doctorId': selectedDoctorId,
                                      'userId': selectedPatientId!,
                                      'day': selectedDay,
                                      'time': selectedTime,
                                      'status': 'pending',
                                      'createdAt': DateTime.now(),
                                    });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Appointment booked successfully",
                                    ),
                                  ),
                                );

                                setState(() {
                                  selectedDoctorId = null;
                                  selectedDay = null;
                                  selectedTime = null;
                                  availableDays = [];
                                  availableTimes = [];
                                });
                              },
                              child: Text("Book Appointment"),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
