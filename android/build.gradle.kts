
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

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Diretório dos APKs gerados pelo Flutter
val appApkDir = project(":app")
    .layout.buildDirectory
    .dir("outputs/flutter-apk")

// Exportar APK Debug
tasks.register<Copy>("exportDebugApk") {
    from(appApkDir) {
        include("app-debug.apk")
    }

    into(rootProject.file("../apks"))

    rename { "malha+_debug.apk" }

    doLast {
        val arquivo = rootProject.file("../apks/malha+_debug.apk")

        println("================================")
        println("APK DEBUG EXPORTADO: ${arquivo.absolutePath}")
        println("ARQUIVO EXISTE: ${arquivo.exists()}")
        println("================================")
    }
}

// Exportar APK Release
tasks.register<Copy>("exportReleaseApk") {
    from(appApkDir) {
        include("app-release.apk")
    }

    into(rootProject.file("../apks"))

    rename { "malha+.apk" }

    doLast {
        val arquivo = rootProject.file("../apks/malha+.apk")

        println("================================")
        println("APK RELEASE EXPORTADO: ${arquivo.absolutePath}")
        println("ARQUIVO EXISTE: ${arquivo.exists()}")
        println("================================")
    }
}

// Exportar automaticamente após a compilação
project(":app") {
    tasks.named("assembleDebug") {
        finalizedBy(rootProject.tasks.named("exportDebugApk"))
    }

    tasks.named("assembleRelease") {
        finalizedBy(rootProject.tasks.named("exportReleaseApk"))
    }
}
