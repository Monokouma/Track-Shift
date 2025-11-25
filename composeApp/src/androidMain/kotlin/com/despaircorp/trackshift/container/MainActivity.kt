package com.despaircorp.trackshift.container

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.Composable
import androidx.compose.ui.tooling.preview.Preview
import com.despaircorp.trackshift.theme.TrackShiftTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)

        setContent {
            TrackShiftTheme {
                TrackShiftApp()
            }
        }
    }
}

@Preview
@Composable
fun TrackShiftAppAndroidPreview() {
    TrackShiftTheme {
        TrackShiftApp()
    }

}