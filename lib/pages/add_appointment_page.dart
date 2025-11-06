import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../tappointment.dart';
import '../services/appointment_service.dart';

class AddAppointmentPage extends StatefulWidget {
  const AddAppointmentPage({super.key});

  @override
  State<AddAppointmentPage> createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final AppointmentService _appointmentService = AppointmentService();
  String? _selectedDoctorId;
  String? _selectedDoctorName;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _loading = false;
  List<Map<String, dynamic>> _doctors = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  // 🔹 جلب الأطباء من مجموعة users حسب الدور
  Future<void> _fetchDoctors() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .get();

      setState(() {
        _doctors = querySnapshot.docs
            .map(
              (doc) => {
                'id': doc.id,
                'fullname': doc['fullname'] ?? 'بدون اسم',
                'specialization': doc['specialization'] ?? 'غير محدد',
              },
            )
            .toList();
      });
    } catch (e) {
      debugPrint('خطأ في جلب الأطباء: $e');
    }
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
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // 🔹 اختيار الوقت
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // 🔹 حفظ الموعد
  Future<void> _saveAppointment() async {
    if (_selectedDoctorId == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار الطبيب، التاريخ، والوقت')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('لم يتم تسجيل الدخول');

      final appointment = Appointment()
        ..appointmentId = DateTime.now().millisecondsSinceEpoch.toString()
        ..patientId = user.uid
        ..doctorId = _selectedDoctorId
        ..appointmentDate = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        )
        ..appointmentTime =
            '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
        ..status = 'قيد الانتظار';

      await _appointmentService.addAppointment(appointment);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حجز الموعد بنجاح')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء حفظ الموعد: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة موعد جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'اختر الطبيب:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _doctors.isEmpty
                        ? const Text('لا يوجد أطباء متاحون')
                        : DropdownButtonFormField<String>(
                            value: _selectedDoctorId,
                            hint: const Text('اختر الطبيب'),
                            onChanged: (value) {
                              setState(() {
                                _selectedDoctorId = value;
                                _selectedDoctorName = _doctors.firstWhere(
                                  (d) => d['id'] == value,
                                  orElse: () => {'fullname': ''},
                                )['fullname'];
                              });
                            },
                            items: _doctors
                                .map(
                                  (doctor) => DropdownMenuItem<String>(
                                    value: doctor['id'],
                                    child: Text(
                                      '${doctor['fullname']} - ${doctor['specialization']}',
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                    const SizedBox(height: 16),
                    const Text(
                      'اختر التاريخ:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'لم يتم اختيار تاريخ'
                              : _selectedDate!.toLocal().toString().split(
                                  ' ',
                                )[0],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _pickDate,
                          child: const Text('اختر التاريخ'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'اختر الوقت:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          _selectedTime == null
                              ? 'لم يتم اختيار الوقت'
                              : _selectedTime!.format(context),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _pickTime,
                          child: const Text('اختر الوقت'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('حفظ الموعد'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: _saveAppointment,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
