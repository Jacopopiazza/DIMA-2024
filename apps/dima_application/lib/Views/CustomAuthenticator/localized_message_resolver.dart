
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:dima_application/generated/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

class LocalizedMessageResolver extends MessageResolver {
  const LocalizedMessageResolver();

  @override
  String resolve(BuildContext context, MessageResolverKey key) {
    switch (key.type) {
      case MessageResolverKeyType.codeSent:
        final destination = key.destination;
        if (destination != null) {
          return codeSent(context, destination);
        }
        return codeSentUnknown(context);
      case MessageResolverKeyType.copySucceeded:
        return copySucceeded(context);
      case MessageResolverKeyType.copyFailed:
        return copyFailed(context);
    }
  }

  @override
  String codeSent(BuildContext context, String destination) {
    return AppLocalizations.of(context)!.codeSent(destination);
  }

  /// The message that is displayed after a new confirmation code is sent via
  /// an unknown delivery medium.
  @override
  String codeSentUnknown(BuildContext context) {
    return AppLocalizations.of(context)!.codeSentUnknown;
  }

  /// The message that is displayed after a TOTP Key was copied to the clipboard
  @override
  String copySucceeded(BuildContext context) {
    return AppLocalizations.of(context)!.copySucceeded;
  }

  /// The message that is displayed after a TOTP Key failed to copy to the clipboard
  @override
  String copyFailed(BuildContext context) {
    return AppLocalizations.of(context)!.copyFailed;
  }
}