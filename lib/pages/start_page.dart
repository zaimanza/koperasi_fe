import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_object/components/elevated_card.dart';
import 'package:test_object/pages/parcel_in_page.dart';
import 'package:test_object/pages/parcel_out_page.dart';
import 'package:test_object/providers/store_provider.dart';

class StartPage extends ConsumerStatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends ConsumerState<StartPage> {
  onTapParcelIn() => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const ParcelInPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );

  onTapParcelOut() => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const ParcelOutPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ref.watch(storeProvider).storeName,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                ElevatedCard(
                  title: 'PARCEL IN',
                  onTap: onTapParcelIn,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                ),
                ElevatedCard(
                  title: 'PARCEL OUT',
                  onTap: onTapParcelOut,
                  backgroundColor: Colors.orangeAccent,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
