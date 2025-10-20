package com.despaircorp.trackshift.di

import org.koin.dsl.module


val repositoryModule = module {

    // Exemple : Repository avec interface
    // single<UserRepository> {
    //     UserRepositoryImpl(
    //         httpClient = get(),
    //         database = get()
    //     )
    // }

    // Exemple : Repository sans interface (classe concrète)
    // single {
    //     AuthRepository(
    //         authApi = get()
    //     )
    // }
}