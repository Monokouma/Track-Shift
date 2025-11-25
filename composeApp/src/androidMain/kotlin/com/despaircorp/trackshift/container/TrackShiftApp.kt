package com.despaircorp.trackshift.container

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeContentPadding
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.navigation
import androidx.navigation.compose.rememberNavController
import com.despaircorp.trackshift.onboard.login.LoginView
import com.despaircorp.trackshift.onboard.welcome.WelcomeScreen
import org.jetbrains.compose.ui.tooling.preview.Preview
import org.koin.androidx.compose.koinViewModel

@Composable
fun TrackShiftApp(
    viewModel: TrackShiftViewModel = koinViewModel()
) {
    val authState by viewModel.authState.collectAsStateWithLifecycle()

    if (authState is AuthState.Loading) {
        Box(
            modifier = Modifier.fillMaxSize().background(MaterialTheme.colorScheme.background),
            contentAlignment = Alignment.Center
        ) {
            CircularProgressIndicator()
        }
        return
    }

    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = when (authState) {
            is AuthState.Authenticated -> "main"
            is AuthState.NotAuthenticated -> "auth"
            else -> "auth" },
        ) {
            navigation(
                startDestination = "welcome",
                route = "auth"
            ) {
                composable("welcome") {
                    WelcomeScreen(onNavigateToAuth = {
                        navController.navigate("login")
                    })
                }
                composable("login") {
                    LoginView()
                }
                composable("tutorial") {
                    /*
                    TutorialScreen(
                        onFinish = {
                            navController.navigate("main") {
                                popUpTo("auth") { inclusive = true }
                            }
                        }
                    )

                     */
                }
            }

            navigation(
                startDestination = "home",
                route = "main"
            ) {
                composable("home") {
                    /*
                    HomeScreen(
                        onLogout = {
                            navController.navigate("auth") {
                                popUpTo("main") { inclusive = true }
                            }
                        }
                    )

                     */
                }
            }
        }


}

@Preview
@Composable
fun TrackShiftAppPreview() {
    TrackShiftApp()
}