import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/settings_model.dart';
import 'package:flutter_application_2/pages/settings/widgets/custom_list_tile.dart';
import 'package:flutter_application_2/pages/settings/widgets/single_section.dart';
import 'package:provider/provider.dart';
import "../widgets/slider_widget.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text("Settings"),
      ),
      backgroundColor: const Color(0xfff6f6f6),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              SingleSection(
                title: "General",
                children: [
                  _buildSlider(
                      "Reading Speed (words per minute)", const SimpleSlider(divisions: 13), context),
                  CustomListTile(
                      title: "Dark Mode",
                      icon: CupertinoIcons.moon,
                      trailing:
                          CupertinoSwitch(value: false, onChanged: (value) {})),
                  const CustomListTile(
                      title: "Font", icon: CupertinoIcons.textformat),
                  const CustomListTile(
                      title: "Font Size", icon: CupertinoIcons.text_cursor),
                  const CustomListTile(
                      title: "About us", icon: CupertinoIcons.globe),
                ],
              ),
              SingleSection(
                title: "Network",
                children: [
                  const CustomListTile(
                      title: "SIM Cards and Networks",
                      icon: Icons.sd_card_outlined),
                  CustomListTile(
                    title: "Wi-Fi",
                    icon: CupertinoIcons.wifi,
                    trailing: CupertinoSwitch(value: true, onChanged: (val) {}),
                  ),
                ],
              ),
              const SingleSection(
                title: "Privacy and Security",
                children: [
                  CustomListTile(
                      title: "Sound and Vibration",
                      icon: CupertinoIcons.speaker_2),
                  CustomListTile(
                      title: "Themes", icon: CupertinoIcons.paintbrush)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSlider(String title, Widget child, BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          child,
          Text(title, style: Theme.of(context).textTheme.displaySmall)
        ]),
  );
}
