import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "br.com.dariomatias.music_app"
    // Deliberately just the Flutter-provided value: permission_handler_android
    // 14.0.0 previously forced a floor of 37 here, an SDK platform Google
    // hasn't published yet, which broke CI's APK build. Pinned back to
    // 13.0.1 in pubspec.yaml's dependency_overrides instead, which only
    // needs an already-published compileSdk (35).
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "br.com.dariomatias.music_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// The `compilerOptions` DSL rather than `kotlinOptions`: the latter's
// `jvmTarget: String` is an error from Kotlin 2.2 on, which blocked the
// Kotlin Gradle plugin bump. Supported since 2.0, so it builds under the
// currently pinned 2.1.0 too.
kotlin {
    compilerOptions {
        jvmTarget = JvmTarget.JVM_11
    }
}

flutter {
    source = "../.."
}
