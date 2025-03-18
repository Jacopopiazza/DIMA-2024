# dima_application

A new Flutter project.

## Updating Translations

To update translations in this project, follow these steps:

1. **Add New Strings**:  
    Add a new key/value pair for each string in the appropriate `app_{locale}.arb` file located in the `/lib/l10n/app` folder.

2. **Merge ARB Files**:  
    From the Flutter project root, run the following command to merge all `.arb` files into a single file as required by Flutter:  
    ```bash
    python scripts/merge_arb.py
    ```  
    Ensure there are no duplicate keys. Fix any errors if duplicates are found.

3. **Generate Localization Classes**:  
    From the Flutter project root, run the following command to update the localization classes:  
    ```bash
    flutter gen-l10n
    ```

4. **Use Translated Strings**:  
    Access the translated strings in your code using:  
    ```dart
    AppLocalizations.of(context)!.{newKey}
    ```  
    Flutter will automatically infer the locale at runtime.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
