import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../tappointment.dart';
import '../services/appointment_service.dart';
import 'add_appointment_page.dart';

class ManageAppointmentsPage extends StatefulWidget {
  const ManageAppointmentsPage({super.key});

  @override
  State<ManageAppointmentsPage> createState() => _ManageAppointmentsPageState();
}

class _ManageAppointmentsPageState extends State<ManageAppointmentsPage> {
  final AppointmentService _appointmentService = AppointmentService();
  List<Appointment> _appointments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  // 🔹 جلب اسم الطبيب من Firestore
  Future<String> _getDoctorName(String doctorId) async {
    final doc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();
    if (doc.exists) {
      return (doc.data()?['fullname'] ?? 'غير معروف');
    }
    return 'غير معروف';
  }

  Future<void> _loadAppointments() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final appointments = await _appointmentService.getAppointmentsByPatient(
      user.uid,
    );

    setState(() {
      _appointments = appointments;
      _loading = false;
    });
  }

  Future<void> _deleteAppointment(String id) async {
    await _appointmentService.deleteAppointment(id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم حذف الموعد بنجاح')));
    _loadAppointments();
  }

  Future<void> _updateAppointment(Appointment appointment) async {
    DateTime? newDate = appointment.appointmentDate;
    TimeOfDay initialTime = TimeOfDay(
      hour: appointment.appointmentDate?.hour ?? 10,
      minute: appointment.appointmentDate?.minute ?? 0,
    );

    TimeOfDay? newTime = initialTime;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الموعد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                newDate == null
                    ? 'اختر تاريخ جديد'
                    : 'التاريخ: ${newDate?.toLocal().toString().split(" ")[0]}',
              ),
              onPressed: () async {
                DateTime now = DateTime.now();
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: newDate ?? now,
                  firstDate: now,
                  lastDate: DateTime(now.year + 1),
                );
                if (picked != null) newDate = picked;
              },
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.access_time),
              label: Text('الوقت: ${newTime?.format(context) ?? 'اختر وقتًا'}'),
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: newTime ?? const TimeOfDay(hour: 10, minute: 0),
                );
                if (picked != null) newTime = picked;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newDate != null && newTime != null) {
                final updatedDateTime = DateTime(
                  newDate!.year,
                  newDate!.month,
                  newDate!.day,
                  newTime!.hour,
                  newTime!.minute,
                );

                appointment.appointmentDate = updatedDateTime;
                appointment.appointmentTime =
                    "${newTime!.hour.toString().padLeft(2, '0')}:${newTime!.minute.toString().padLeft(2, '0')}";

                await _appointmentService.updateAppointment(appointment);
                Navigator.pop(context);
                _loadAppointments();
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المواعيد'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAppointments,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddAppointmentPage()),
        ).then((_) => _loadAppointments()),
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _appointments.isEmpty
          ? const Center(child: Text('لا توجد مواعيد بعد'))
          : ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                final appointment = _appointments[index];
                return FutureBuilder<String>(
                  future: _getDoctorName(appointment.doctorId ?? ''),
                  builder: (context, snapshot) {
                    final doctorName = snapshot.data ?? 'جاري التحميل...';

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                          'الطبيب: $doctorName',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'التاريخ: ${appointment.appointmentDate?.toLocal().toString().split(" ")[0] ?? "غير محدد"}\n'
                          'الوقت: ${appointment.appointmentTime ?? "غير محدد"}\n'
                          'الحالة: ${appointment.status ?? "غير محددة"}',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _updateAppointment(appointment),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteAppointment(
                                appointment.appointmentId!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
