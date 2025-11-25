package com.despaircorp.trackshift.onboard.welcome

import android.view.HapticFeedbackConstants
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.Spring
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.MusicNote
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.despaircorp.trackshift.theme.TrackShiftTheme
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive

@Composable
fun WelcomeScreen(
    modifier: Modifier = Modifier,
    onNavigateToAuth: () -> Unit
) {
    var isVisible by remember { mutableStateOf(false) }
    var isNavigating by remember { mutableStateOf(false) }
    val view by rememberUpdatedState(LocalView.current)


    LaunchedEffect(Unit) {
        delay(100)
        isVisible = true
    }

    Box(modifier = modifier.fillMaxSize()) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(MaterialTheme.colorScheme.primary)
        )

        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(
                    brush = Brush.verticalGradient(
                        colors = listOf(
                            MaterialTheme.colorScheme.background.copy(alpha = 0.6F),
                            MaterialTheme.colorScheme.background,
                            MaterialTheme.colorScheme.background,
                            MaterialTheme.colorScheme.background,
                            MaterialTheme.colorScheme.background,
                        )
                    )
                )
        )

        AnimatedVisibility(
            visible = isVisible,
            enter = fadeIn(
                animationSpec = tween(durationMillis = 1000)
            ) + slideInVertically(
                initialOffsetY = { 50 },
                animationSpec = tween(durationMillis = 1000)
            ),
            exit = fadeOut(
                animationSpec = tween(durationMillis = 1000)
            ) + slideOutVertically(
                targetOffsetY = { 50 },
                animationSpec = tween(durationMillis = 1000)
            )
        ) {
            Column(
                modifier = Modifier.fillMaxSize(),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Spacer(modifier = Modifier.weight(1f))

                MusicIconCard()

                Text(
                    text = "Convertissez vos playlists en un instant",
                    fontSize = 28.sp,
                    textAlign = TextAlign.Center,
                    modifier = Modifier
                        .padding(horizontal = 20.dp)
                        .padding(top = 32.dp, bottom = 20.dp),
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onBackground
                )

                Text(
                    text = "Changez de plateforme sans perdre vos playlists. Spotify, Apple Music, Deezer... Convertissez en quelques taps.",
                    fontSize = 16.sp,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = 20.dp),
                    fontWeight = FontWeight.Normal,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )

                Spacer(modifier = Modifier.weight(1f))
                Spacer(modifier = Modifier.weight(1f))

                AnimatedPressButton(
                    text = "Commencer",
                    enabled = !isNavigating,
                    onClick = {
                        if (!isNavigating) {
                            isNavigating = true

                            view.performHapticFeedback(HapticFeedbackConstants.CONTEXT_CLICK)

                            isVisible = false
                        }
                    },
                    modifier = Modifier.fillMaxWidth()
                )
            }
        }

        LaunchedEffect(isNavigating) {
            if (isNavigating) {
                delay(800)
                if (isActive) {
                    onNavigateToAuth()
                }
            }
        }
    }
}

@Composable
fun AnimatedPressButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
) {
    var isPressed by remember { mutableStateOf(false) }

    Button(
        onClick = onClick,
        enabled = enabled,
        modifier = modifier.padding(vertical = 40.dp, horizontal = 20.dp)
            .scale(if (isPressed) 0.92f else 1f)
            .pointerInput(Unit) {
                detectTapGestures(
                    onPress = {
                        isPressed = true
                        tryAwaitRelease()
                        isPressed = false
                    }
                )
            },
        shape = RoundedCornerShape(32.dp),
        colors = ButtonDefaults.buttonColors(
            containerColor = MaterialTheme.colorScheme.primary
        ),
        elevation = ButtonDefaults.buttonElevation(
            defaultElevation = 0.dp,
            pressedElevation = 2.dp
        )
    ) {
        Text(
            text = text,
            color = MaterialTheme.colorScheme.onBackground,
            fontWeight = FontWeight.Medium,
            modifier = Modifier.padding(4.dp),
            textAlign = TextAlign.Center
        )
    }
}

@Composable
fun MusicIconCard(
) {
    Box(
        modifier = Modifier
            .size(200.dp)
            .clip(RoundedCornerShape(48.dp))
    ) {
        Box(
            modifier = Modifier
                .size(120.dp)
                .align(Alignment.Center)
                .shadow(
                    elevation = 12.dp,
                    shape = RoundedCornerShape(28.dp),
                    spotColor = Color.Black.copy(alpha = 0.4f)
                )
                .clip(RoundedCornerShape(28.dp))
                .background(MaterialTheme.colorScheme.primary.copy(alpha = 0.2F))
                .padding(24.dp),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = Icons.Default.MusicNote,
                contentDescription = "Music",
                tint = MaterialTheme.colorScheme.onBackground,
                modifier = Modifier.fillMaxSize()
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun WelcomeScreenPreview() {
    TrackShiftTheme {
        WelcomeScreen(onNavigateToAuth = {

        })
    }
}