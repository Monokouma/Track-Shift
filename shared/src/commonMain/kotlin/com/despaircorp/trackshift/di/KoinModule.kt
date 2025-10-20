package com.despaircorp.trackshift.di

import org.koin.core.context.startKoin
import org.koin.dsl.KoinAppDeclaration


fun initKoin(appDeclaration: KoinAppDeclaration = {}) {
    startKoin {
        appDeclaration()
        modules(
            networkModule,
            repositoryModule,
            useCaseModule
        )
    }
}

fun initKoin() = initKoin {}
