package com.despaircorp.trackshift

import android.app.Application
import com.despaircorp.trackshift.di.initKoin
import com.despaircorp.trackshift.di.networkModule
import com.despaircorp.trackshift.di.repositoryModule
import com.despaircorp.trackshift.di.useCaseModule
import com.despaircorp.trackshift.di.viewModelModule

import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.startKoin
import org.koin.core.logger.Level

class TrackShiftApplication: Application() {
    override fun onCreate() {
        super.onCreate()

        initKoin {
            androidLogger(Level.DEBUG)
            androidContext(this@TrackShiftApplication)
            modules(
                networkModule,
                repositoryModule,
                useCaseModule,
                viewModelModule
            )
        }
    }
}