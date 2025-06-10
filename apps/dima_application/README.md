# dima_application

A new Flutter project.

## Updating AppSync Models

1. **Download updated schema**:
    Run the following command from Flutter porject root folder:
    ```bash
    aws appsync get-introspection-schema --api-id 4oytcqqiovd6rfde5k5hp3lxvi --region us-west-2 --format SDL ./lib/graphql/schema.graphql 
    ```

2. **Re run model gen command**:
    Run the following command from Flutter porject root folder:
    ```bash
    npx @aws-amplify/cli codegen models --model-schema ./lib/graphql/schema.graphql --target flutter --output-dir ./lib/generated/flutter-models/
    ```

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

## 🛠️ Generate Isar Models

To generate the Isar models, run the following command from the root of your Flutter project:
```bash
flutter pub run build_runner build
```

💡 Tip: If you run into issues with conflicting files, try this instead:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
