package com.despaircorp.trackshift.domain.user

import io.github.jan.supabase.auth.user.UserInfo

interface UserInterface {
    suspend fun isUserAuth(): UserInfo?
    suspend fun authUsingMailPassword(mail: String, password: String): Result<Unit>
    suspend fun authAnonymously(): Result<Unit>
    suspend fun signInWithApple(idToken: String, nonce: String): Result<Unit>
    suspend fun signInWithGoogle(idToken: String): Result<Unit>
}