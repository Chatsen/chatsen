import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../components/modal.dart';
import '../data/webview/cookie_data.dart';
import 'verify_token.dart';

class OAuthWebViewModal extends StatefulWidget {
  const OAuthWebViewModal({
    Key? key,
  }) : super(key: key);

  @override
  State<OAuthWebViewModal> createState() => _OAuthWebViewModalState();
}

class _OAuthWebViewModalState extends State<OAuthWebViewModal> {
  late WebViewController controller;

  @override
  void initState() {
    CookieManager().clearCookies();
    // CookieManager().setCookie(WebViewCookie());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          WebView(
            onPageFinished: (url) async {
              if (!url.contains('access_token')) return;

              final fragmentParameters = {
                for (var fragment in Uri.parse(url).fragment.split('&').map((x) => x.split('='))) fragment.first: fragment.last,
              };

              final accessToken = fragmentParameters['access_token'];
              if (accessToken == null) return;

              final cookies = await WebviewCookieManager().getCookies('https://twitch.tv');

              Navigator.of(context).pop();

              Modal.show(
                context: context,
                child: VerifyTokenModal(
                  token: accessToken,
                  cookies: [
                    for (var cookie in cookies)
                      CookieData.fromCookie(
                        cookie,
                      ),
                  ],
                ),
              );
            },
            onWebViewCreated: (webViewController) {
              controller = webViewController;
            },
            initialUrl: 'https://id.twitch.tv/oauth2/authorize?client_id=vvxbprk8sfufgzd7k9wwr1478znf7b&redirect_uri=https://chatsen.app/oauth&response_type=token&scope=' +
                [
                  // Chat
                  'chat:edit',
                  'chat:read',
                  'channel:moderate',
                  'channel:read:redemptions',
                  'moderator:manage:automod',
                  'channel:manage:broadcast',

                  // Whispers
                  'whispers:read',
                  'whispers:edit',

                  // Sub emotes
                  'user_subscriptions',

                  // Blocked users
                  'user_blocks_edit',
                  'user_blocks_read',
                  'user:read:blocked_users',
                  'user:manage:blocked_users',

                  // Raid
                  'channel_editor', // Raids

                  // Run ads
                  // 'channel_commercial',
                  // 'channel:edit:commercial',

                  // To create clips
                  // 'clips:edit',

                  // Follows, no longer working
                  // 'user_follows_edit',
                  // 'user:edit:follows',
                ].join('%20'),
            // initialUrl: 'https://google.com',
            javascriptMode: JavascriptMode.unrestricted,
            userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(24.0),
                  clipBehavior: Clip.antiAlias,
                  color: Theme.of(context).colorScheme.background,
                  child: InkWell(
                    onTap: () async => Navigator.of(context).pop(),
                    child: const SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: Icon(Icons.close),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}