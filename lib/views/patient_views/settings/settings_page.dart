import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/settings_provider.dart';
import 'package:shifaa/controllers/user_provider.dart';

import 'package:shifaa/views/patient_views/faq/faq_page.dart';
import 'package:shifaa/views/patient_views/profile/profile_page.dart';
import 'package:shifaa/widgets/gradient_background.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('settings').tr(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: GradiantBackGroundWrapper(
          child: Stack(
        children: [
          Image.asset(
            'assets/ui/settings_bg.png',
            fit: BoxFit.fill,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Card(
                elevation: 10,
                margin: EdgeInsets.only(top: 25.h, bottom: 5.h),
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                    child: ChangeNotifierProvider<SettingsProvider>(
                      create: (context) => SettingsProvider(),
                      builder: (_, child) => Consumer<SettingsProvider>(
                        builder: (_, prov, child) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    foregroundImage:
                                        AssetImage('assets/logoc.png'),
                                    radius: 36,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(context
                                      .read<UserProvider>()
                                      .getCurrentUser()
                                      .user
                                      .getName(context)),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 0.2,
                                color: Colors.blueGrey,
                                width: 100.w,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'accountSettings'.tr(),
                                    style: const TextStyle(
                                        color: AppConstants.textBlueGrey,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                    /*          ListTile(
                                title: Text(
                                  'editProfile'.tr(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                   //   Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),));
                                    },
                                    icon: const Icon(Icons.navigate_next)),
                              ),*/
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'enableNotifications'.tr(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    FlutterSwitch(
                                      value: prov.notificationsEnabled,
                                      onToggle: (value) {
                                        EasyDebounce.debounce(
                                            'notif', const Duration(seconds: 1),
                                            () {
                                          prov.toggleNotifications(value,context);
                                        });
                                      },
                                      showOnOff: true,
                                      activeText: 'on'.tr(),
                                      inactiveText: 'off'.tr(),
                                      activeColor: AppConstants.aquamarine,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 0.2,
                                color: Colors.blueGrey,
                                width: 100.w,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'more'.tr(),
                                    style: const TextStyle(
                                        color: AppConstants.textBlueGrey,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              ListTile(

                                title: Text(
                                  'freqQuestions'.tr(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>   FaqPage(),
                                      ));
                                    },
                                    icon: const Icon(Icons.navigate_next)),
                              ),
                              ListTile(
                                title: Text(
                                  'termsOfService'.tr(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      launchUrlString('https://app.enzuzo.com/policies/tos/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJDdXN0b21lcklEIjoyMTgxNCwiQ3VzdG9tZXJOYW1lIjoiY3VzdC14eXBmUjJ4QiIsIkN1c3RvbWVyTG9nb1VSTCI6IiIsIlJvbGVzIjpbInJlZmVycmFsIl0sIlByb2R1Y3QiOiJlbnRlcnByaXNlIiwiaXNzIjoiRW56dXpvIEluYy4iLCJuYmYiOjE2ODQ2MTk3NjZ9.ExSqR9cN7YzWuQ_td6GJmRmhPADg2oug2JDuibQ3aVc',
                                      mode: LaunchMode.externalApplication);
                                    },
                                    icon: const Icon(Icons.navigate_next)),
                              ),
                              ListTile(
                                title: Text(
                                  'privacyPolicy'.tr(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      launchUrlString('https://app.enzuzo.com/policies/privacy/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJDdXN0b21lcklEIjoyMTgxNCwiQ3VzdG9tZXJOYW1lIjoiY3VzdC14eXBmUjJ4QiIsIkN1c3RvbWVyTG9nb1VSTCI6IiIsIlJvbGVzIjpbInJlZmVycmFsIl0sIlByb2R1Y3QiOiJlbnRlcnByaXNlIiwiaXNzIjoiRW56dXpvIEluYy4iLCJuYmYiOjE2ODQ2MTk2Njd9.Q9jU-NvuiWulxtfiqskR0ISnnuhASkICmAnK9ZG40QM',
                                          mode: LaunchMode.externalApplication);
                                    },
                                    icon: const Icon(Icons.navigate_next)),
                              ),
                            ],
                          );
                        },
                      ),
                    )),
              ),
            ),
          )
        ],
      )),
    );
  }
}
