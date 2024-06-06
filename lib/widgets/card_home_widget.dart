import 'package:demo_nfc/config/colors.dart';
import 'package:demo_nfc/nearpay_services/nearpay_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget customHomeCard({
  Key? key,
  required BuildContext context,
  required Color color,
  required String title,
  required String subtitle,
  required String svgImagePath,
  required Function()? onTap,
  // required Function onTap,
}) {
  return Container(
    width: MediaQuery.sizeOf(context).width * 0.43,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            svgImagePath,
            color: color,
            height: MediaQuery.sizeOf(context).height * 0.2,
            width: MediaQuery.sizeOf(context).width * 0.10,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
