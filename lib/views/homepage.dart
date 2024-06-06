import 'package:demo_nfc/config/colors.dart';
import 'package:demo_nfc/config/images.dart';
import 'package:demo_nfc/nearpay_services/nearpay_services.dart';
import 'package:demo_nfc/widgets/card_home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo_nfc/views/success_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 243, 243),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Text(
              'Your ',
              style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Logo',
              style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // Add  functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Add  functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                customHomeCard(
                    context: context,
                    color: AppColors.primaryColor,
                    svgImagePath: DefaultImages.product,
                    title: "Machiato",
                    subtitle: "SAR 30.00",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewScreen()),
                      );
                    }),
                customHomeCard(
                    context: context,
                    color: AppColors.primaryColor,
                    svgImagePath: DefaultImages.product,
                    title: "Machiato",
                    subtitle: "SAR 30.00",
                    onTap: () => NearpayService().makePurchase(100, '123')),
                customHomeCard(
                    context: context,
                    color: AppColors.primaryColor,
                    svgImagePath: DefaultImages.product,
                    title: "Machiato",
                    subtitle: "SAR 30.00",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewScreen()),
                      );
                    }),
                customHomeCard(
                    context: context,
                    color: AppColors.primaryColor,
                    svgImagePath: DefaultImages.product,
                    title: "Machiato",
                    subtitle: "SAR 30.00",
                    onTap: () => NearpayService().makePurchase(100, '123')),
                customHomeCard(
                    context: context,
                    color: AppColors.primaryColor,
                    svgImagePath: DefaultImages.product,
                    title: "Machiato",
                    subtitle: "SAR 30.00",
                    onTap: () => NearpayService().makePurchase(100, '123')),
                customHomeCard(
                    context: context,
                    color: AppColors.primaryColor,
                    svgImagePath: DefaultImages.product,
                    title: "Machiato",
                    subtitle: "SAR 30.00",
                    onTap: () => NearpayService().makePurchase(100, '123')),
                customHomeCard(
                    context: context,
                    color: AppColors.primaryColor,
                    svgImagePath: DefaultImages.product,
                    title: "Machiato",
                    subtitle: "SAR 30.00",
                    onTap: () => NearpayService().makePurchase(100, '123')),
                customHomeCard(
                    context: context,
                    color: AppColors.primaryColor,
                    svgImagePath: DefaultImages.product,
                    title: "Machiato",
                    subtitle: "SAR 30.00",
                    onTap: () => NearpayService().makePurchase(100, '123')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
