import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pico_sulteng_flutter/app/data/models/article.dart';
import 'package:pico_sulteng_flutter/app/global_widgets/article_card.dart';
import 'package:pico_sulteng_flutter/app/global_widgets/error_placeholder_widget.dart';
import 'package:pico_sulteng_flutter/app/global_widgets/line_container.dart';

import '../controllers/articles_controller.dart';

class ArticlesView extends GetView<ArticlesController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Artikel',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          floatingActionButton: controller.buildFAB(),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Kumpulan artikel terkait COVID-19'),
                    SizedBox(height: 6.0),
                  ],
                ),
              ),
              const LineContainer(),
              Expanded(
                child: Scrollbar(
                  thickness: 6.0,
                  radius: const Radius.circular(10.0),
                  interactive: true,
                  controller: controller.scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: PagedListView.separated(
                      scrollController: controller.scrollController,
                      pagingController: controller.pagingController,
                      shrinkWrap: true,
                      builderDelegate: PagedChildBuilderDelegate(
                        itemBuilder: (_, item, index) {
                          final article = item! as Article;
                          return ArticleCard(article: article);
                        },
                        firstPageErrorIndicatorBuilder: (_) {
                          return ErrorPlaceHolderWidget(
                            label:
                                'Terjadi kesalahan saat memuat data! Harap coba lagi!',
                            onRetry: () {
                              controller.pagingController.refresh();
                            },
                          );
                        },
                        newPageErrorIndicatorBuilder: (_) {
                          return ErrorPlaceHolderWidget(
                            label:
                                'Terjadi kesalahan saat memuat data! Harap coba lagi!',
                            onRetry: () {
                              controller.pagingController
                                  .retryLastFailedRequest();
                            },
                          );
                        },
                        firstPageProgressIndicatorBuilder: (_) {
                          return SizedBox(
                            height: Get.height * 0.8,
                            child: const Center(
                                child: SpinKitFadingCircle(color: Colors.blue)),
                          );
                        },
                        newPageProgressIndicatorBuilder: (_) {
                          return const SpinKitFadingCircle(color: Colors.blue);
                        },
                      ),
                      separatorBuilder: (_, index) {
                        return const SizedBox(height: 8.0);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}