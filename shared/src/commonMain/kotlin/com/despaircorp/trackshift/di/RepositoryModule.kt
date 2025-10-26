package com.despaircorp.trackshift.di

import com.despaircorp.trackshift.data.user.UserRepository
import com.despaircorp.trackshift.domain.user.UserInterface
import org.koin.dsl.module


val repositoryModule = module {

    single<UserInterface> {
        UserRepository(
            supabaseClient = get()
        )
    }
}