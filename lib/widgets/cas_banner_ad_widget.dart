import 'package:clever_ads_solutions/clever_ads_solutions.dart';
import 'package:flutter/material.dart';
import '../core/ads/cas_ad_service.dart';

class CasBannerAdWidget extends StatelessWidget {
  const CasBannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final banner = CasAdService.instance.banner;
    if (banner == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      color: Colors.black26,
      child: CASWidget(ad: banner),
    );
  }
}
