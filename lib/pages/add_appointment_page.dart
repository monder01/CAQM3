import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../tappointment.dart';
import '../services/appointment_service.dart';

class AddAppointmentPage extends StatefulWidget {
  const AddAppointmentPage({super.key});

  @override
  State<AddAppointmentPage> createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final AppointmentService _appointmentService = AppointmentService();
  final _formKey = GlobalKey<FormState>();

  String? _selectedDoctorId;
  String? _selectedDoctorName;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool _loading = false;

  // 🔹 جلب قائمة الأطباء من قاعدة البيانات
  Stream<QuerySnapshot> getDoctorsStream() {
    return FirebaseFirestore.instance.collection('doctors').snapshots();
  }

  // 🔹 اختيار التاريخ
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // 🔹 اختيار الوقت
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // 🔹 حفظ الموعد
  Future<void> _saveAppointment() async {
    if (_selectedDoctorId == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار الطبيب، التاريخ والوقت')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final DateTime fullDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final appointment = Appointment(
        appointmentId: '',
        patientId: user.uid,
        doctorId: _selectedDoctorId!,
        appointmentDate: fullDateTime,
        appointmentTime:
            "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
        status: 'Pending',
      );

      await _appointmentService.addAppointment(appointment);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تمت إضافة الموعد بنجاح')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة موعد جديد')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 🔸 قائمة الأطباء
                    StreamBuilder<QuerySnapshot>(
                      stream: getDoctorsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text('لا يوجد أطباء متاحون حالياً');
                        }

                        final doctors = snapshot.data!.docs;

                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'اختر الطبيب',
                          ),
                          value: _selectedDoctorId,
                          items: doctors.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return DropdownMenuItem<String>(
                              value: doc.id,
                              child: Text(data['fullname'] ?? 'بدون اسم'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            final selected = doctors.firstWhere(
                              (doc) => doc.id == value,
                              orElse: () => doctors.first,
                            );
                            final data =
                                selected.data() as Map<String, dynamic>;
                            setState(() {
                              _selectedDoctorId = value;
                              _selectedDoctorName = data['fullname'];
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // 🔸 اختيار التاريخ
                    ListTile(
                      title: Text(
                        _selectedDate == null
                            ? 'اختر التاريخ'
                            : 'التاريخ: ${_selectedDate!.toLocal().toString().split(" ")[0]}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 8),

                    // 🔸 اختيار الوقت
                    ListTile(
                      title: Text(
                        _selectedTime == null
                            ? 'اختر الوقت'
                            : 'الوقت: ${_selectedTime!.format(context)}',
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: _pickTime,
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('تأكيد الموعد'),
                      onPressed: _saveAppointment,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
