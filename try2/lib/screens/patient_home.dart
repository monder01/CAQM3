import 'package:flutter/material.dart';
import '../models/patients.dart';
import '../models/appointment.dart';
import '../services/auth_service.dart';

class PatientHome extends StatefulWidget {
  final Patient user; // تأكد أننا نستقبل Patient مباشرة
  const PatientHome({super.key, required this.user});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final TextEditingController doctorNameC = TextEditingController();
  final TextEditingController notesC = TextEditingController();
  DateTime? selectedDate;

  void _addAppointment() async {
    if (doctorNameC.text.isEmpty || selectedDate == null) return;

    await widget.user.addAppointment(
      doctorNameC.text.trim(),
      selectedDate!,
      notesC.text.trim(),
    );

    doctorNameC.clear();
    notesC.clear();
    setState(() {
      selectedDate = null;
    });
  }

  void _deleteAppointment(String id) async {
    await widget.user.deleteAppointment(id);
  }

  void _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Home'),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Welcome ${widget.user.fullName}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            TextField(
              controller: doctorNameC,
              decoration: InputDecoration(labelText: 'Doctor Name'),
            ),
            TextField(
              controller: notesC,
              decoration: InputDecoration(labelText: 'Notes'),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pickDate(context),
                  child: Text(
                    selectedDate == null
                        ? 'Pick Date'
                        : selectedDate!.toLocal().toString().split(' ')[0],
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addAppointment,
                  child: Text('Add Appointment'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Appointment>>(
                stream: widget.user.getAppointments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Appointments'));
                  }

                  final appointments = snapshot.data!;
                  return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appt = appointments[index];
                      return Card(
                        child: ListTile(
                          title: Text('Dr. ${appt.doctorName}'),
                          subtitle: Text(
                            '${appt.dateTime.toLocal()} \n${appt.notes}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteAppointment(appt.id),
                          ),
                        ),
                      );
                    },
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
