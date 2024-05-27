# Project IDX Learning Management System (LMS)

Project IDX LMS is a comprehensive and user-friendly learning management system designed to enhance the teaching and learning experience. Built on the powerful Project IDX platform, our LMS offers a range of features and functionalities to support effective online learning.

## Features

- **Course Creation and Management:**
  - Create and manage courses with ease, including adding modules, lessons, and assessments.
  - Organize course content into logical units for better navigation and understanding.
  - Control access to courses and manage student enrollment.

- **User Management:**
  - Create and manage user accounts for students, instructors, and administrators.
  - Assign roles and permissions to different user groups.
  - Track user progress and engagement within the LMS.

- **Content Delivery:**
  - Upload and share a variety of content formats, including videos, presentations, documents, and interactive simulations.
  - Create and deliver engaging learning experiences that cater to different learning styles.
  - Provide students with access to course materials and resources 24/7.

- **Assessment and Evaluation:**
  - Design and administer quizzes, tests, and assignments to assess student learning.
  - Provide automated grading and feedback to students.
  - Track student performance and progress over time.

- **Communication and Collaboration:**
  - Foster communication and collaboration among students and instructors through discussion forums, chat rooms, and video conferencing.
  - Enable peer-to-peer learning and knowledge sharing.
  - Create a sense of community within the LMS.

- **Reporting and Analytics:**
  - Generate detailed reports on student progress, course completion rates, and overall LMS usage.
  - Analyze data to identify areas for improvement and make informed decisions.
  - Provide instructors with insights into student performance and engagement.

## Benefits

- **Enhanced Learning Experience:**
  - Project IDX LMS offers a user-friendly interface and intuitive navigation, making it easy for students and instructors to access and use the platform.
  - The LMS supports various learning styles and preferences, ensuring that all learners can engage with the content effectively.

- **Improved Efficiency and Productivity:**
  - Streamline administrative tasks and reduce manual workload with Project IDX LMS.
  - Automate processes such as grading, tracking student progress, and generating reports.
  - Free up time for instructors to focus on teaching and student support.

- **Scalability and Flexibility:**

![Flutter Gallery](https://user-images.githubusercontent.com/6655696/73928238-0d7fcc80-48d3-11ea-8a7e-ea7dc5d6e713.png)

## Features

- Showcase for `material`, `cupertino`, and other widgets
- [Adaptive layout](lib/layout/adaptive.dart) for mobile and desktop
- State restoration support
- Settings to text scaling, text direction, locale, theme, and more...
- Demo for `animations`
- Foldable support and demo for `dual_screen`
- Deferred loading
- CI/CD
- ...and much more!

## Supported Platforms

Flutter Gallery has been built to support multiple platforms.
These include:

- Android ([Google Play Store](https://play.google.com/store/apps/details?id=io.flutter.demo.gallery), [.apk][latest release])
- iOS (locally)
- web ([gallery.flutter.dev](https://gallery.flutter.dev/))
- macOS ([.zip][latest release])
- Linux ([.tar.gz][latest release])
- Windows ([.zip][latest release])

## Running

One can run the gallery locally for any of these platforms. For desktop platforms,
please see the [Flutter docs](https://docs.flutter.dev/desktop) for the latest
requirements.

```bash
cd gallery/
flutter pub get
flutter run
```

<details>
<summary>Troubleshooting</summary>

### Flutter `master` channel

The Flutter Gallery targets Flutter's `master` channel. As such, it can take advantage
of new SDK features that haven't landed in the stable channel.

If you'd like to run the Flutter Gallery, you may have to switch to the `master` channel
first:

```bash
flutter channel master
flutter upgrade
```

When you're done, use this command to return to the safety of the `stable`
channel:

```bash
flutter channel stable
flutter upgrade
```

</details>

## Development

<details>
  <summary>Generating localizations</summary>

If this is the first time building the Flutter Gallery, the localized
code will not be present in the project directory. However, after running
the application for the first time, a synthetic package will be generated
containing the app's localizations through importing
`package:flutter_gen/gen_l10n/`.

```bash
flutter pub get
flutter pub run grinder l10n
```

See separate [README](lib/l10n/README.md) for more details.

</details>

<details>
  <summary>Generating highlighted code segments</summary>

```bash
flutter pub get
flutter pub run grinder update-code-segments
```

See separate [README](tool/codeviewer_cli/README.md) for
more details.

</details>

<details>
  <summary>Including a new splash animation</summary>

1. Convert your animation to a `.gif` file.
   Ideally, use a background color of `0xFF030303` to ensure the animation
   blends into the background of the app.

2. Add your new `.gif` file to the assets directory under
   `assets/splash_effects`. Ensure the name follows the format
   `splash_effect_$num.gif`. The number should be the next number after the
   current largest number in the repository.

3. Update the map `_effectDurations` in
[splash.dart](lib/pages/splash.dart) to include the number of the
new `.gif` as well as its estimated duration. The duration is used to
determine how long to display the splash animation at launch.
</details>

## Releasing

<details>
  <summary>for flutter-hackers members</summary>

The process is largely automated and easy to set in motion.

First things first, bump the `pubspec.yaml` version number. This can be in a PR making a change or a separate PR.
Use [semantic versioning](https://semver.org/) to determine
which part to increment. The version number after the `+` should also be incremented. For example `1.2.3+010203`
with a patch should become `1.2.4+010204`.

Then, use the following workflows. It is strongly recommended to use the staging/beta environments when available, before deploying to production.

- [Deploy to Play Store](https://github.com/flutter/gallery/actions/workflows/release_deploy_play_store.yml): Uses Fastlane to create a [beta](https://play.google.com/console/u/0/developers/7661132837216938445/app/4974617875198505129/tracks/open-testing) (freely available on the [Play Store](https://play.google.com/apps/testing/io.flutter.demo.gallery)), promote an existing beta to production, or publish straight to [production](https://play.google.com/console/u/0/developers/7661132837216938445/app/4974617875198505129/tracks/production) ([Play Store](https://play.google.com/store/apps/details?id=io.flutter.demo.gallery)).
  > **Note**
  > Once an .aab is released with a particular version number, it can't be replaced. The version number must be incremented again.
- [Deploy to web](https://github.com/flutter/gallery/actions/workflows/release_deploy_web.yml): Deploys a web build to the Firebase-hosted [staging](https://gallery-flutter-staging.web.app) or [production](https://gallery.flutter.dev) site.
- [Draft GitHub release](https://github.com/flutter/gallery/actions/workflows/release_draft_github_release.yml): Drafts a GitHub release, including automatically generated release notes and packaged builds for Android, macOS, Linux, and Windows.
  > **Note**
  > The release draft is private until published. Upon being published, the specified version tag will be created.

For posterity, information about doing these things locally is available at [go/flutter-gallery-manual-deployment](http://go/flutter-gallery-manual-deployment).

</details>

## Tests

The gallery has its own set of unit, golden, and integration tests.

In addition, Flutter itself uses the gallery in tests. To enable breaking changes, the gallery version is pinned in two places:

- `flutter analyze`: https://github.com/flutter/tests/blob/master/registry/flutter_gallery.test
- DeviceLab tests: https://github.com/flutter/flutter/blob/master/dev/devicelab/lib/versions/gallery.dart

[latest release]: https://github.com/flutter/gallery/releases/latest
