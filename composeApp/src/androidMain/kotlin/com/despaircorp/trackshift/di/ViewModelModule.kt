package com.despaircorp.trackshift.di

import com.despaircorp.trackshift.container.TrackShiftViewModel
import org.koin.core.module.dsl.viewModel
import org.koin.dsl.module

val viewModelModule = module {
    viewModel { TrackShiftViewModel(isUserAuthUseCase = get()) }
}