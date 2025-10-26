package com.despaircorp.trackshift.di

import com.despaircorp.trackshift.domain.user.IsUserAuthUseCase
import org.koin.core.component.KoinComponent
import org.koin.core.component.get

class KoinHelper : KoinComponent {
    fun isUserAuthUseCase(): IsUserAuthUseCase = get()
}