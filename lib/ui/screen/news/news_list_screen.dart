import 'package:flutter/material.dart';
import 'package:inisa_app/helper/ui_color.dart';
import 'package:inisa_app/localization/localization.dart';
import 'package:inisa_app/ui/widget/appbar_widget.dart';
import 'package:inisa_app/ui/widget/news_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qoin_sdk/qoin_sdk.dart' as qoin;

class NewsListScreen extends StatelessWidget {
  NewsListScreen({Key? key}) : super(key: key);

  final RefreshController? _refreshController = RefreshController(initialRefresh: false);
  final ScrollController? _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUI.shape,
      appBar: AppBarWidget.light(
        title: Localization.newsList.tr,
      ),
      body: SmartRefresher(
        controller: _refreshController!,
        scrollController: _scrollController!,
        onRefresh: () async {
          await qoin.RssFeedInisaController.to
              .loadFeed(isUseBackupUrl: qoin.RssFeedInisaController.to.isUseBackup);
          _refreshController!.refreshCompleted();
        },
        child: qoin.GetBuilder<qoin.RssFeedInisaController>(
          init: qoin.RssFeedInisaController(),
          builder: (controller) {
            return ListView.builder(
                itemCount: controller.rssItems.length,
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return NewsWidget(rssItem: controller.rssItems[index]);
                });
          },
        ),
      ),
    );
  }
}
