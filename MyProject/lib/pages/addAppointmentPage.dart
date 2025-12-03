import 'package:flutter/material.dart';
import 'package:prototype1/oop/appointments.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAppointmentPage extends StatefulWidget {
  const AddAppointmentPage({super.key, this.patientIdd});

  final String? patientIdd;

  @override
  State<AddAppointmentPage> createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  Appointment appointment = Appointment();
  String? selectedDoctorId;
  String? selectedDoctorName;
  String? selectedTime;
  String? selectedAppointmentType;
  double? appointmentCost;
  final thisUser = FirebaseAuth.instance.currentUser;
  bool whosTheUser() {
    return widget.patientIdd != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة موعد جديد'),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () async {
                final result = await appointment.showDoctorsDialog(context);
                if (result != null) {
                  setState(() {
                    selectedDoctorId = result['doctorId'];
                    selectedDoctorName = result['doctorName'];
                    selectedTime = result['time'];
                  });
                }
              },
              child: Text('اختر طبيب ووقت'),
            ),
            SizedBox(height: 20),
            Text('الطبيب المختار: ${selectedDoctorName ?? "لم يتم الاختيار"}'),
            SizedBox(height: 10),
            Text('الوقت المختار: ${selectedTime ?? "لم يتم الاختيار"}'),
            Divider(),
            ElevatedButton(
              onPressed: () async {
                String? currentUser;
                if (whosTheUser()) {
                  currentUser = widget.patientIdd;
                } else {
                  currentUser = thisUser?.uid;
                }
                if (selectedDoctorId != null &&
                    selectedDoctorName != null &&
                    selectedTime != null) {
                  await appointment.saveAppointment(
                    doctorId: selectedDoctorId!,
                    doctorName: selectedDoctorName!,
                    time: selectedTime!,
                    appointmentType: selectedAppointmentType,
                    cost: appointmentCost,
                    patientId: currentUser,
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم حجز الموعد بنجاح ✔️',
                        style: TextStyle(
                          color: Colors.amberAccent[200],
                          fontSize: 34,
                        ),
                      ),
                    ),
                  );

                  setState(() {
                    selectedDoctorId = null;
                    selectedDoctorName = null;
                    selectedTime = null;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('يرجى اختيار طبيب ووقت قبل الحجز')),
                  );
                }
              },
              child: Text('حجز'),
            ),

            // chooese appointment type
            SizedBox(height: 20),
            DropdownButton(
              hint: Text('اختر نوع الموعد'),
              value: selectedAppointmentType,
              items: const [
                DropdownMenuItem(
                  child: Text('إستشارة (السعر 30د.ل)'),
                  value: 'إستشارة',
                ),
                DropdownMenuItem(
                  child: Text('متابعة (السعر 70د.ل)'),
                  value: 'متابعة',
                ),
                DropdownMenuItem(
                  child: Text('فحص دوري (السعر 50د.ل)'),
                  value: 'فحص دوري',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedAppointmentType = value as String?;
                  print('Selected appointment type: $selectedAppointmentType');
                  if (selectedAppointmentType == "إستشارة") {
                    appointmentCost = 30.0;
                  } else if (selectedAppointmentType == "متابعة") {
                    appointmentCost = 70.0;
                  } else if (selectedAppointmentType == "فحص دوري") {
                    appointmentCost = 50.0;
                  } else {
                    appointmentCost = null;
                  }
                  print('Appointment cost: $appointmentCost');
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
