import 'package:flutter/material.dart';
import 'package:inisa_app/helper/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/helper/ui_text.dart';
import 'package:qoin_sdk/models/others/contact_data.dart';

class AccountItem extends StatelessWidget {
  final String fullname;
  final String? phone;
  final ContactData? contactDestination;
  final Widget? trailing;
  const AccountItem(
      {Key? key, required this.fullname, this.contactDestination, this.trailing, this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
          border: Border.all(color: ColorUI.border, width: 1),
          color: ColorUI.shape),
      padding: EdgeInsets.all(16.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Image(
          image: AssetImage(Assets.icAvatarBlue),
          width: 40,
          fit: BoxFit.fitWidth,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fullname,
              overflow: TextOverflow.ellipsis,
              style: TextUI.subtitleBlack,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              phone != null
                  ? phone!.toUpperCase()
                  : contactDestination?.phone != null
                      ? contactDestination!.phone.toUpperCase()
                      : '-',
              style: TextUI.bodyText2Black,
            ),
          ],
        ),
        trailing: trailing,
      ),
    );
  }
}
// class AccountItem extends StatefulWidget {
//   final String fullname;
//   final ContactData contactDestination;
//   final Function? onTap;
//   const AccountItem(
//       {Key? key, required this.contactDestination, this.onTap, required this.fullname})
//       : super(key: key);

//   @override
//   State<AccountItem> createState() => _AccountItemState();
// }

// class _AccountItemState extends State<AccountItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(color: ColorUI.border), borderRadius: BorderRadius.circular(4.r)),
//       padding: EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           Image(
//             image: AssetImage(Assets.icAvatarBlue),
//             width: 40.w,
//             fit: BoxFit.fitWidth,
//           ),
//           SizedBox(
//             width: 16,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.fullname,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextUI.subtitleBlack,
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 Text(
//                   widget.contactDestination.phone.toUpperCase(),
//                   style: TextUI.bodyText2Black,
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             width: 16,
//           ),
//           InkWell(
//             onTap: () {
//               var message = '';
//               if (widget.contactDestination.isFav!) {
//                 ContactController.to.contactRemoveFav(widget.contactDestination);
//                 message = WalletLocalization.contactDeleteFavSuccess.tr;
//                 widget.contactDestination.isFav = false;
//               } else {
//                 ContactController.to.contactAddFav(widget.contactDestination);
//                 message = WalletLocalization.contactSavedFavSuccess.tr;
//                 widget.contactDestination.isFav = true;
//               }
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 duration: Duration(seconds: 1),
//                 content: Container(
//                   width: double.infinity,
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.check_circle,
//                         color: Colors.white,
//                       ),
//                       SizedBox(
//                         width: 16.0,
//                       ),
//                       Expanded(
//                         child: Text(message),
//                       ),
//                     ],
//                   ),
//                 ),
//                 behavior: SnackBarBehavior.floating,
//                 backgroundColor: (widget.contactDestination.isFav!) ? Colors.green : Colors.grey,
//                 margin: EdgeInsets.fromLTRB(
//                     16, 16, 16, (MediaQuery.of(context).size.height - (kToolbarHeight * 3))),
//               ));
//               setState(() {});
//             },
//             child: Image(
//               image: AssetImage((widget.contactDestination.isFav!)
//                   ? Assets.icFavoriteContactFill
//                   : Assets.icFavoriteContact),
//               width: 32.w,
//               fit: BoxFit.fitWidth,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
