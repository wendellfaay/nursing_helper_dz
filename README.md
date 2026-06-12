# Nursing Helper DZ — Local Notes

هذا الملف يشرح أوامر سريعة لتشغيل، اختبار، ورفع المشروع من بيئة التطوير المحلية.

أساسيات تطوير محلي:

- تثبيت الحزم:
```bash
flutter pub get
```

- تشغيل التحليل الثابت:
```bash
flutter analyze
```

- تشغيل اختبارات الوحدة والواجهات:
```bash
flutter test
```

اختبارات التكامل (integration tests):

- تشغيل محليًا على سطح المكتب ليس دائمًا مدعومًا؛ لتشغيل على ويندوز تأكد من تفعيل دعم سطح المكتب في `flutter` أو استخدم محاكي Android.
- لتشغيل على Android emulator محليًا:
  1. ثبت Android SDK وAndroid Studio.
  2. أنشئ AVD عبر Android Studio أو `avdmanager`.
  3. شغّل المحاكي ثم:
```bash
flutter test integration_test/app_test.dart -d android
```

- إذا كنت تريد تشغيل اختبارات التكامل في بيئة CI (GitHub Actions)، أضفت عمل `integration_tests` إلى
  `.github/workflows/flutter.yml` الذي يحاول إنشاء AVD وتشغيل الاختبارات — لكن GitHub-hosted runners
  قد تحتاج إعداد خاص أو استخدام Firebase Test Lab.

رفع التغييرات إلى GitHub:

- إذا تود رفع التغييرات تلقائيًا، زوّدني بعنوان الـremote (مثال):
  - `git@github.com:you/repo.git` أو
  - `https://github.com/you/repo.git`

- أو يمكنك تنفيذ محليًا:
```bash
git remote add origin <REMOTE_URL>
git branch -M main
git push -u origin main
```

ماذا أريد منك الآن: إذا ترغب أن أدفع التغييرات إلى GitHub تلقائيًا، أرسل رابط الـremote أو قل "ادفع" إذا قمت بإضافته محليًا.
# nursing_helper_dz

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
