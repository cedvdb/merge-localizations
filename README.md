

# merge_localizations

Merges multiple nested `.arb` files into one.

# Usage

Given the following file structure
```
/screens
  /screen1
    screen1.dart
    screen1.arb
  /screen2
    screen2.dart
    screen2.arb
/language
merge_localizations.yaml
```

and the following `merge_localizations.yaml` (all properties are optional)
```yaml
inputs-directories:
  - /screens
output-directory: /language
output-filename: language_en.arb
should-add-context: true
should-run-flutter-gen: false
```



running `dart run merge_localizations` will combine `screen1.arb` and `screen2.arb` into a single  `/language/language_en.arb` file.

