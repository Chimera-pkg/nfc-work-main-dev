import 'package:demo_nfc/config/colors.dart';
import 'package:demo_nfc/config/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget customCard({
  Key? key,
  Color color = Colors.amber,
  required String title,
  required String subtitle,
  required String svgImagePath,
  required Function onTap,
}) {
  return Container(
      height: Dimensions.height230,
      width: Dimensions.width180,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgImagePath,
            height: Dimensions.height100,
            width: Dimensions.width100,
            color: Colors.white,
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimensions.font26,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimensions.font26,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onTap(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'Order Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

