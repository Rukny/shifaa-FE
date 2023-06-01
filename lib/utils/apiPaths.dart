/// Defines all api paths available.
///
/// https://cgfyraknvt.eu08.qoddiapp.com/customers/registration
class ApiPaths {
//  static const base = kReleaseMode ? "cgfyraknvt.eu08.qoddiapp.com" : "swcjghopym.eu11.qoddiapp.com";
  static const base = "shifaa.api.zutch.dev";
  // static const base = "localhost:3000";
  static const _customers = '/customers';
  static const _specialties='/specialties';
  static const _questions ="/questions";
  static const _medicalCenters="/medicalCenters";
  static const _city="/city";
  static const _auth="/auth";
  static const _patients="/patients";
  static const _doctors="/doctors";
  static const _appointment="/appointment";
  static const _user="/user";


  ///user
  static const updateUserFcm="$_user/updateFcmToken";


  ///auth
  static const login="$_auth/login";
  ///city
  static const availableCity="$_city/available";

  ///appointments
  static const createAppointment="$_appointment/create";
  static   getPatientAppointments(int pid)=>"$_appointment/patientAppointments/$pid";
  static   getDoctorAppointments(int did)=>"$_appointment/doctorAppointments/$did";
  static   cancelAppointment(String cancelledBy,int apid)=>"$_appointment/$cancelledBy/cancelAppointment/$apid";
  ///specialty
  static const getSpecialities="$_specialties/available";
  static const getSpecialitiesWithSubs="$_specialties/withSub-specialties";

  ///questions
  static const getQuestions="$_questions/available";
  static const postQuestion="$_questions";

  ///patients
  static const patients=_patients;
  static String patientsRegister="$_patients";
  static const getPatient="$_patients/getPatient";

  ///answers
  static   getAnswers(int id)=>"$_questions/$id/answers";
  static   postAnswer(int id)=>"$_questions/$id/answers";
  ///medicalCenters
  static const availableMedicalCentres="$_medicalCenters/available";
  static getMedicalCentersByCityId(id) => "$_medicalCenters/byCity/$id";
  static getMedicalCenterByCenterId(id) => "$_medicalCenters/byMedicalCenter/$id";
  static const searchMedicalCenters='$_medicalCenters/search';


  ///doctors
  static   getDoctors(id)=> "$_doctors$_medicalCenters/$id";
  static   addDoctors(id)=> "$_medicalCenters/$id/doctors";
  static   getDoctor(id,did)=> "$_doctors/$did";
  static   getDoctorDetails(String doctorId)=> "$_doctors/$doctorId";
  static   patchDoctor(id,did)=> "$_medicalCenters/$id/doctor/$did";
  static   getDoctorTimeSlots(id,did)=> "$_medicalCenters/$id/doctors/findAvailableTimeSlots/$did";



  static const getCustomerUID = "$_customers";



}
