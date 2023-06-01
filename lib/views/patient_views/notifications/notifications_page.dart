



import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shifaa/controllers/nav_provider.dart';
import 'package:shifaa/controllers/notification_provider.dart';
import 'package:shifaa/models/notification.dart';
import 'package:shifaa/widgets/gradient_background.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return   Scaffold(
    extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text('notifications'.tr()),elevation: 0,),
      body: SingleChildScrollView(
        child: GradiantBackGroundWrapper(
          child: Consumer<NotificationProvider>(builder: (_, prov, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100.h,
                  width: 100.w,
                  child: Builder(

                    builder: (_) {


                        return ListView(

                          children: [

                            ...prov.notifications.map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: SwipeActionCell(
                                deleteAnimationDuration: 800,

                                key: Key(e.messageId.toString()),
                                leadingActions: [SwipeAction(

                                  icon: Icon(Icons.delete),
                                  performsFirstActionWithFullSwipe: true,
                                  title: 'delete'.tr(),
                                  color: Colors.red,
                                  onTap: (handler)async {
                                    await  prov.removeNotif(e);

                                  },)],
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Container(
                                      height: 95,
                                      width: 90.w,
                                      padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.h),
                                      child: Row(
                                        children: [
                                          CircleAvatar(radius: 35,
                                            foregroundImage:e.imageUrl!=null?CachedNetworkImageProvider(  e.imageUrl!): AssetImage('assets/images/avatar.png') as ImageProvider,
                                          ),
                                          const SizedBox(width: 10,),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(e.title?? "no title"),
                                            ],
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ))],);




                    },),
                ),
              ],
            );
          },),
        ),
      ),

    );
  }
}
