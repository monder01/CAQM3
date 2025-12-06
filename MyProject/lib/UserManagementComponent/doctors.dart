import '/UserManagementComponent/users.dart';

class Doctors extends UserC {
  String?
  doctorId; // معرف الطبيب والذي يمكن ربطه بمعرف المستخدم في FirebaseAuth
  List<String> workingDays = []; // قائمة الأيام التي يعمل فيها الطبيب
  List<String> workingHours = []; // قائمة الساعات المتاحة للطبيب خلال اليوم
  String? specialization; // تخصص الطبيب (مثل قلب، عظام، أطفال... إلخ)
}
