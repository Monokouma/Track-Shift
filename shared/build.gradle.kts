import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import java.io.FileInputStream
import java.util.Properties
import co.touchlab.skie.configuration.FlowInterop
import co.touchlab.skie.configuration.SealedInterop
import co.touchlab.skie.configuration.SuspendInterop

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidLibrary)
    alias(libs.plugins.kotlinSerialization)
    alias(libs.plugins.sqldelight)
    id("com.codingfeline.buildkonfig") version "0.17.1"
    id("co.touchlab.skie") version "0.10.6"

}

kotlin {
    androidTarget {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_17)
        }
    }

    listOf(
        iosArm64(),
        iosSimulatorArm64()
    ).forEach { iosTarget ->
        iosTarget.binaries.framework {
            baseName = "Shared"
            isStatic = false
            export(libs.koin.core)
        }
    }



    sourceSets {
        commonMain.dependencies {
            implementation(libs.postgrest.kt)
            implementation(libs.gotrue.kt)

            // put your Multiplatform dependencies here
            implementation(libs.kotlinx.coroutines.core)
            implementation(libs.kotlinx.serialization.json)
            implementation(libs.kotlinx.datetime)

            // Ktor
            implementation(libs.ktor.client.core)
            implementation(libs.ktor.client.content.negotiation)
            implementation(libs.ktor.serialization.kotlinx.json)
            implementation(libs.ktor.client.logging)

            // Koin
            api(libs.koin.core)


            // SQLDelight
            implementation(libs.sqldelight.coroutines)

            // DataStore
            implementation(libs.androidx.datastore.preferences)

            // Logging
            implementation(libs.napier)

        }

        androidMain.dependencies {
            implementation(libs.kotlinx.coroutines.android)
            implementation(libs.ktor.client.okhttp)
            implementation(libs.sqldelight.driver.android)
            implementation(libs.koin.android)
        }

        iosMain.dependencies {
            implementation(libs.ktor.client.darwin)
            implementation(libs.sqldelight.driver.native)
        }

        commonTest.dependencies {
            implementation(libs.kotlin.test)
        }
    }
}



android {
    namespace = "com.despaircorp.trackshift.shared"
    compileSdk = libs.versions.android.compileSdk.get().toInt()
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    defaultConfig {
        minSdk = libs.versions.android.minSdk.get().toInt()
    }

}

buildkonfig {
    packageName = "com.despaircorp.trackshift.shared"

    defaultConfigs {
        val properties = Properties()
        val localPropertiesFile = rootProject.file("local.properties")
        if (localPropertiesFile.exists()) {
            properties.load(FileInputStream(localPropertiesFile))
        }

        buildConfigField(
            com.codingfeline.buildkonfig.compiler.FieldSpec.Type.STRING,
            "SUPABASE_URL",
            properties.getProperty("supabase.url", "")
        )
        buildConfigField(
            com.codingfeline.buildkonfig.compiler.FieldSpec.Type.STRING,
            "SUPABASE_KEY",
            properties.getProperty("supabase.key", "")
        )
    }
}

skie {
    analytics {
        disableUpload.set(true)
    }

    features {
        group {
            SuspendInterop.Enabled(true)
            SealedInterop.Enabled(true)
            FlowInterop.Enabled(true)
        }
    }
}
