package com.despaircorp.trackshift.di

import com.despaircorp.trackshift.domain.user.IsUserAuthUseCase
import com.despaircorp.trackshift.domain.user.ManageEmailPasswordAuthUseCase
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.SupabaseClientBuilder
import org.koin.dsl.module


val useCaseModule = module {
    // Exemple : Use cases
    // factory { LoginUseCase(get()) }
    // factory { RegisterUseCase(get()) }
    // factory { GetProfileUseCase(get()) }
    // factory { LogoutUseCase(get()) }

    factory { IsUserAuthUseCase(userInterface = get()) }
    factory { ManageEmailPasswordAuthUseCase(userInterface = get())  }
}