import 'package:chatsen/data/settings/application_appearance.dart';
import 'package:chatsen/data/settings/blocked_message.dart';
import 'package:chatsen/data/settings/blocked_user.dart';
import 'package:chatsen/data/settings/mention_message.dart';
import 'package:chatsen/data/settings/mention_user.dart';
import 'package:chatsen/data/settings/message_appearance.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import '/data/twitch/token_data.dart';
import '/data/twitch/user_data.dart';
import '/data/twitch_account.dart';
import '/data/webview/cookie_data.dart';
import '/app.dart';
import 'data/filesharing/uploaded_media.dart';
import 'tmi/client/client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Wakelock.enable();

  await Hive.initFlutter();

  final adapters = <TypeAdapter>[
    TwitchAccountAdapter(),
    TokenDataAdapter(),
    UserDataAdapter(),
    CookieDataAdapter(),
    UploadedMediaAdapter(),
    MessageAppearanceAdapter(),
    ApplicationAppearanceAdapter(),
    BlockedMessageAdapter(),
    BlockedUserAdapter(),
    MentionMessageAdapter(),
    MentionUserAdapter(),
  ];

  for (final adapter in adapters) {
    Hive.registerAdapter(adapter);
  }

  final twitchAccountsBox = await Hive.openBox('TwitchAccounts');
  final accountSettingsBox = await Hive.openBox('AccountSettings');
  final settingsBox = await Hive.openBox('Settings');
  final blockedMessagesBox = await Hive.openBox('BlockedMessages');
  final blockedUsersBox = await Hive.openBox('BlockedUsers');
  final mentionMessagesBox = await Hive.openBox('MentionMessages');
  final mentionUsersBox = await Hive.openBox('MentionUsers');

  await settingsBox.clear();

  final activeTwitchAccount = twitchAccountsBox.values.firstWhere(
    (element) => accountSettingsBox.get('activeTwitchAccount') == element.tokenData.hash,
    orElse: () => null,
  );

  if (!settingsBox.containsKey('messageAppearance')) await settingsBox.put('messageAppearance', MessageAppearance());

  runApp(
    MultiProvider(
      providers: [
        Provider<Client>(create: (context) => Client(twitchAccount: activeTwitchAccount)),
      ],
      child: const App(),
    ),
  );
}
