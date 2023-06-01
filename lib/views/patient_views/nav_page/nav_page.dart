import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shifaa/constants/appConstants.dart';
import 'package:shifaa/controllers/nav_provider.dart';
import 'package:shifaa/controllers/notification_provider.dart';
import 'package:shifaa/controllers/user_provider.dart';
import 'package:shifaa/views/patient_views/near_me/near_me_page.dart';
import 'package:shifaa/views/patient_views/notifications/notifications_page.dart';
import 'package:shifaa/views/patient_views/settings/settings_page.dart';


import 'package:shifaa/widgets/gradient_background.dart';

class NavPage extends StatelessWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { return Future(() => false,); },
      child: ChangeNotifierProvider<NavProvider>(
        create: (context) => NavProvider(),
        builder: (_, child) =>
            Consumer<NavProvider>(
              builder: (context, prov, child) {
                return AdvancedDrawer(
                  controller: prov.advancedDrawerController,
                  rtlOpening: context.locale.languageCode == "en" ? false : true,
                  backdrop: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppConstants.darkBlue, AppConstants.aquamarine],
                      ),
                    ),
                  ),
                  drawer: SafeArea(
                    child: Container(
                      child: ListTileTheme(
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.contain,
                            ),
                            // ListTile(
                            //   onTap: () {},
                            //   leading: Icon(Icons.home),
                            //   title: Text('Home'),
                            // ),
                            ListTile(
                              onTap: ()async {
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NearMePage(),));
                              },
                              leading: const Icon(Icons.map),
                              title: Text('nearMe'.tr()),
                            ),

                            ListTile(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage(),));
                              },
                              leading: const Icon(Icons.settings),
                              title: Text('settings'.tr()),
                            ),
                            ListTile(
                              onTap: () async {
                                bool? choiceRes =await showDialog<bool>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    title: Text('logoutConfirmationTitle'.tr()),
                                    content: Row(children: [Text('logoutConfirmationBody'.tr())],),
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context,true), child: Text('yes'.tr())),
                                      TextButton(onPressed: () => Navigator.pop(context,false), child: Text('no'.tr())),
                                    ],
                                  ),
                                );
                                if(choiceRes!=null && choiceRes) {
                              var res =
                                  await context.read<UserProvider>().logOut();
                              Navigator.pushReplacementNamed(context, 'login');
                            }
                          },
                              leading: const Icon(Icons.logout),
                              title: Text('logout'.tr()),
                            ),
                            ListTile(
                              onTap: () async {
                                if (context.locale.languageCode == "en") {
                                  context.setLocale(const Locale('ar'));
                                } else {
                                  context.setLocale(const Locale('en'));
                                }

                              },
                              leading: const Icon(Icons.language),
                              title: Text('changeLang'.tr()),
                            ),
                            const Spacer(),
                            DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white54,
                              ),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                child:
                                const Text('Terms of Service | Privacy Policy'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      titleTextStyle: const TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          fontFamily: 'Rubik'),

                      elevation: 0,
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NotificationsPage(),)
                              );
                            },
                            icon: Badge(
                              label: Text(Provider
                                  .of<NotificationProvider>(context)
                                  .notifCount
                                  .toString()),
                              child: const Icon(CupertinoIcons.bell_fill),)),
                        ...prov.actions
                      ],
                    ),
                    extendBodyBehindAppBar: true,
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      child: Image.asset('assets/home.png'),
                      onPressed: () {
                        prov.onHomeTap();
                      },
                      //params
                    ),
                    floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniCenterDocked,
                    bottomNavigationBar: AnimatedBottomNavigationBar(
                      icons: prov.icons,

                      activeIndex: prov.bottomNavIndex,
                      activeColor: AppConstants.aquamarine,

                      gapLocation: GapLocation.center,
                      blurEffect: false,
                      notchSmoothness: NotchSmoothness.verySmoothEdge,
                      leftCornerRadius: 32,
                      elevation: 5,

                      rightCornerRadius: 32,
                      onTap: (index) => prov.onNavTap(index),
                      //other params
                    ),
                    backgroundColor: Colors.white,
                    body: SingleChildScrollView(

                        child: prov.currentPage),
                  ),
                );
              },
            ),
      ),
    );
  }
}
