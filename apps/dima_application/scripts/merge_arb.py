import json
import os

def merge_arb_files(input_dir, locale):
    """Merges only ARB files with the _{locale}.arb suffix. Output file is app_{locale}.arb and is overwritten.
       Now tracks the original file source of each key for debugging duplicates.
    """

    merged_data = {"@@locale": locale}
    output_file = os.path.join(input_dir, f"app_{locale}.arb")
    key_sources = {}  # Dictionary to store the source file for each key

    for root, _, files in os.walk(input_dir):
        for filename in files:
            if filename.endswith(f"_{locale}.arb") and os.path.join(root, filename) != output_file:
                filepath = os.path.join(root, filename)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        data = json.load(f)

                        file_locale = data.get("@@locale")
                        if file_locale and file_locale != locale:
                            print(f"Warning: File {filepath} has locale '{file_locale}', expected '{locale}'. Skipping.")
                            continue

                        for key, value in data.items():
                            if key == "@@context":
                                continue

                            if key not in merged_data:
                                merged_data[key] = value
                                key_sources[key] = filepath  # Store the source file
                            elif key != "@@locale":
                                original_source = key_sources.get(key)
                                print(f"Warning: Duplicate key '{key}' found in {filepath}. Original value from: {original_source}. Keeping the original value.")

                except json.JSONDecodeError as e:
                    print(f"Error decoding JSON in {filepath}: {e}")
                    return False
                except FileNotFoundError as e:
                    print(f"Error file not found {filepath}: {e}")
                    return False

    try:
        with open(output_file, 'w', encoding='utf-8') as outfile:
            json.dump(merged_data, outfile, indent=2, ensure_ascii=False)
        print(f"Merged ARB files for {locale} into {output_file}")
        return True
    except Exception as e:
        print(f"Error writing output file: {e}")
        return False

if __name__ == "__main__":
    locales = ["en", "it"]
    input_dir = "lib/l10n"

    for locale in locales:
        print(f"Merge ARB files with _{locale}.arb suffix. Output is app_{locale}.arb.")
        if not merge_arb_files(input_dir, locale):
            exit(1)