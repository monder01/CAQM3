class AppointmentFactory {
  static double getCost(String type) {
    switch (type) {
      case 'إستشارة':
        return 30.0;
      case 'متابعة':
        return 70.0;
      case 'فحص دوري':
        return 50.0;
      default:
        return 0.0;
    }
  }
}
