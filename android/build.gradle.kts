allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Some plugins (e.g. on_audio_query_android) predate AGP 8's requirement
// that every Android library declare a `namespace`, and only set a
// `package` in their AndroidManifest.xml instead. Backfill it from their
// Gradle `group`, which for these older plugins matches their manifest
// package, so the build doesn't fail waiting on an upstream fix.
//
// The same old-style plugins also never set a Kotlin `jvmTarget`, so the
// Kotlin Gradle plugin defaults it to whatever JDK is running Gradle
// (e.g. 21), while their own Java sources still compile against 1.8 —
// backfill it to 1.8 too, to match, rather than the Kotlin default.
//
// Must be registered before `evaluationDependsOn(":app")` below forces
// early evaluation of these subprojects, since `afterEvaluate` can't be
// added to a project that has already evaluated.
subprojects {
    afterEvaluate {
        val android = extensions.findByType(com.android.build.gradle.BaseExtension::class.java)
        if (android != null && android.namespace == null) {
            android.namespace = group.toString()

            tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                compilerOptions.jvmTarget.set(
                    org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8,
                )
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
