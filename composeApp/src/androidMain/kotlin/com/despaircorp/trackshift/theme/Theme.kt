package com.despaircorp.trackshift.theme


import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val TrackShiftColorScheme = darkColorScheme(
    primary = PrimaryPurple,
    onPrimary = Text1,
    primaryContainer = PrimaryPurple.copy(alpha = 0.12f),
    onPrimaryContainer = PrimaryPurple,

    secondary = SecondaryPink,
    onSecondary = Text1,
    secondaryContainer = SecondaryPink.copy(alpha = 0.12f),
    onSecondaryContainer = SecondaryPink,

    background = Background1,
    onBackground = Text1,

    surface = Background2,
    onSurface = Text1,
    surfaceVariant = Background3,
    onSurfaceVariant = Text2,

    outline = Text2.copy(alpha = 0.3f),
    outlineVariant = Text2.copy(alpha = 0.12f),

    error = Color(0xFFCF6679),
    onError = Color(0xFF000000),
    errorContainer = Color(0xFFCF6679),
    onErrorContainer = Color(0xFFCF6679),
)

@Composable
fun TrackShiftTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = TrackShiftColorScheme,
        typography = Typography,
        content = content
    )
}