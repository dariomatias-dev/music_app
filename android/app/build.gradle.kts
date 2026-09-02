import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "br.com.dariomatias.music_app"
    // Above the Flutter-provided value (36) because permission_handler_android
    // 14.0.0 compiles against 37. Compiling against a higher SDK is backward
    // compatible, and targetSdk below is what actually decides the runtime
    // behaviour the app opts into.
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    defaultConfig {
        applicationId = "br.com.dariomatias.music_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Deliberate: this app ships no production signing config, and
            // the release build exists to be installed from the CI artifact
            // rather than published to a store. See docs/contributing.md.
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
