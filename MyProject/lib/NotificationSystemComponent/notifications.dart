import 'package:flutter/material.dart'; // استيراد مكتبة الواجهة الرسومية في فلاتر

class Notifications {
  String message = ''; // متغير لتخزين الرسالة التي سيتم عرضها داخل مربع الحوار

  Future<bool> showConfirmationDialog(
    BuildContext context, // السياق المطلوب لعرض مربع الحوار
    String message, // الرسالة التي ستظهر داخل مربع التأكيد
  ) async {
    this.message =
        message; // تخزين الرسالة داخل الكائن لاستخدامها مستقبلاً إن لزم ذلك

    // فتح مربع حوار من نوع AlertDialog وإرجاع قيمة منطقية حسب اختيار المستخدم
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible:
          true, // السماح بإغلاق مربع الحوار عند الضغط خارجَه أو بالرجوع
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'هل أنت متأكد؟', // عنوان مربع الحوار
            textAlign: TextAlign.right, // جعل النص بمحاذاة اليمين (العربية)
            style: TextStyle(fontWeight: FontWeight.bold), // جعل الخط عريضًا
          ),
          content: Text(
            message, // عرض الرسالة المرسلة للتابع
            textAlign: TextAlign.right, // محاذاة النص لليمين
            style: TextStyle(color: Colors.redAccent), // لون مميز للرسالة
          ),
          actions: [
            TextButton(
              // زر الإلغاء
              onPressed: () =>
                  Navigator.of(context).pop(false), // إرجاع false عند الإلغاء
              child: const Text('إلغاء'),
            ),
            SizedBox(width: 100), // مسافة بين زري الإلغاء والتأكيد
            TextButton(
              // زر التأكيد
              onPressed: () =>
                  Navigator.of(context).pop(true), // إرجاع true عند التأكيد
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );

    // إذا أغلق المستخدم مربع الحوار بدون اختيار، اعتبر القيمة false
    return result ?? false;
  }
}
