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
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.SupabaseClientBuilder
import org.koin.dsl.module


val useCaseModule = module {

    factory { IsUserAuthUseCase(userInterface = get()) }
    factory { ManageEmailPasswordAuthUseCase(userInterface = get())  }
    factory { ManageAnonymousAuthUseCase(userInterface = get()) }
    factory { ManageAuthWithAppleUseCase(userInterface = get()) }
    factory { ManageAuthWithGoogleUseCase(userInterface = get()) }
    factory { SendConvertRequestUseCase(tracksInterface = get()) }
    factory { GetSpotifyAuthUrlUseCase(get()) }
    factory { IsSpotifyAuthenticatedUseCase(get()) }
    factory { HandleSpotifyCallbackUseCase(get()) }
    factory { CreateSpotifyPlaylistUseCase(get()) }
}