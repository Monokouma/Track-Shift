package com.despaircorp.trackshift.data.user

import com.despaircorp.trackshift.domain.user.UserInterface
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.auth.auth
import io.github.jan.supabase.auth.providers.builtin.Email
import io.github.jan.supabase.auth.user.UserInfo
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import kotlinx.coroutines.ensureActive
import kotlinx.coroutines.withContext

class UserRepository(
    private val supabaseClient: SupabaseClient
): UserInterface {

    override suspend fun isUserAuth(): UserInfo? = withContext(Dispatchers.IO) {
        supabaseClient.auth.currentUserOrNull()
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
}