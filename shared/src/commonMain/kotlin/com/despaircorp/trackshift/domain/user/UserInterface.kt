package com.despaircorp.trackshift.domain.user

import io.github.jan.supabase.auth.user.UserInfo

interface UserInterface {
    suspend fun isUserAuth(): UserInfo?
}