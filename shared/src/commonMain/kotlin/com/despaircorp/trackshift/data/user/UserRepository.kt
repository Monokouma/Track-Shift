package com.despaircorp.trackshift.data.user

import com.despaircorp.trackshift.domain.user.UserInterface
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.auth.auth
import io.github.jan.supabase.auth.providers.Apple
import io.github.jan.supabase.auth.providers.Google
import io.github.jan.supabase.auth.providers.builtin.Email
import io.github.jan.supabase.auth.providers.builtin.IDToken
import io.github.jan.supabase.auth.user.UserInfo
import io.github.jan.supabase.gotrue.SessionStatus
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import kotlinx.coroutines.delay
import kotlinx.coroutines.ensureActive
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.withContext
import kotlinx.coroutines.withTimeoutOrNull

class UserRepository(
    private val supabaseClient: SupabaseClient
): UserInterface {

    override suspend fun isUserAuth(): UserInfo? = withContext(Dispatchers.IO) {
        try {
            val status = withTimeoutOrNull(10_000L) {
                supabaseClient.auth.sessionStatus.first { sessionStatus ->
                    println("Session status: $sessionStatus")

                    sessionStatus.toString().contains("Authenticated") ||
                            sessionStatus.toString().contains("NotAuthenticated")
                }
            }

            println("Final status: $status")
            supabaseClient.auth.currentUserOrNull()
        } catch (e: Exception) {
            println("Auth error: ${e.message}")
            null
        }

    }


    override suspend fun authUsingMailPassword(
        mail: String,
        password: String
    ): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            supabaseClient.auth.signUpWith(Email) {
                this.email = mail
                this.password = password
            }
            Result.success(Unit)
        } catch (e: Exception) {
            print(e.stackTraceToString())
            ensureActive()
            Result.failure(e)
        }
    }

    override suspend fun authAnonymously(): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            supabaseClient.auth.signInAnonymously()
            Result.success(Unit)
        } catch (e: Exception) {
            print(e.stackTraceToString())
            ensureActive()
            Result.failure(e)
        }
    }

    override suspend fun signInWithApple(
        idToken: String,
        nonce: String
    ): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            supabaseClient.auth.signInWith(IDToken) {
                this.idToken = idToken
                this.nonce = nonce
                provider = Apple
            }
            Result.success(Unit)
        } catch (e: Exception) {
            print(e.stackTraceToString())
            ensureActive()
            Result.failure(e)
        }
    }

    override suspend fun signInWithGoogle(idToken: String): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            supabaseClient.auth.signInWith(IDToken) {
                this.idToken = idToken
                provider = Google
            }
            Result.success(Unit)
        } catch (e: Exception) {
            print(e.stackTraceToString())
            ensureActive()
            Result.failure(e)
        }
    }
}