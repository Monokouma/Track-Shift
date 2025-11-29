package com.despaircorp.trackshift.di

import com.despaircorp.trackshift.data.spotify.SpotifyRepository
import com.despaircorp.trackshift.data.tracks.TracksRepository
import com.despaircorp.trackshift.data.user.UserRepository
import com.despaircorp.trackshift.domain.spotify.SpotifyInterface
import com.despaircorp.trackshift.domain.tracks.TracksInterface
import com.despaircorp.trackshift.domain.user.UserInterface
import org.koin.dsl.module


val repositoryModule = module {

    single<UserInterface> {
        UserRepository(
            supabaseClient = get()
        )
    }

    single<TracksInterface> {
        TracksRepository(get())
    }

    single<SpotifyInterface> {
        SpotifyRepository(get())
    }

}