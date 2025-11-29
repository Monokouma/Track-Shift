package com.despaircorp.trackshift.di

import com.despaircorp.trackshift.domain.spotify.CreateSpotifyPlaylistUseCase
import com.despaircorp.trackshift.domain.spotify.GetSpotifyAuthUrlUseCase
import com.despaircorp.trackshift.domain.spotify.HandleSpotifyCallbackUseCase
import com.despaircorp.trackshift.domain.spotify.IsSpotifyAuthenticatedUseCase
import com.despaircorp.trackshift.domain.tracks.SendConvertRequestUseCase
import com.despaircorp.trackshift.domain.user.IsUserAuthUseCase
import com.despaircorp.trackshift.domain.user.ManageAnonymousAuthUseCase
import com.despaircorp.trackshift.domain.user.ManageAuthWithAppleUseCase
import com.despaircorp.trackshift.domain.user.ManageAuthWithGoogleUseCase
import com.despaircorp.trackshift.domain.user.ManageEmailPasswordAuthUseCase
import org.koin.core.component.KoinComponent
import org.koin.core.component.get

class KoinHelper : KoinComponent {
    fun isUserAuthUseCase(): IsUserAuthUseCase = get()

    fun manageEmailPasswordAuthUseCase(): ManageEmailPasswordAuthUseCase = get()

    fun manageAnonymousAuthUseCase(): ManageAnonymousAuthUseCase = get()

    fun manageAuthWithAppleUseCase(): ManageAuthWithAppleUseCase = get()

    fun manageAuthWithGoogleUseCase(): ManageAuthWithGoogleUseCase = get()

    fun sendConvertRequestUseCase(): SendConvertRequestUseCase = get()

    fun getSpotifyAuthUrlUseCase(): GetSpotifyAuthUrlUseCase = get()

    fun isSpotifyAuthenticatedUseCase(): IsSpotifyAuthenticatedUseCase = get()

    fun handleSpotifyCallbackUseCase(): HandleSpotifyCallbackUseCase = get()

    fun createSpotifyPlaylistUseCase(): CreateSpotifyPlaylistUseCase = get()
}