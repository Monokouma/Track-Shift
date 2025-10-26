package com.despaircorp.trackshift.data.user

import com.despaircorp.trackshift.domain.user.UserInterface
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.auth.auth
import io.github.jan.supabase.auth.user.UserInfo
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import kotlinx.coroutines.withContext

class UserRepository(
    private val supabaseClient: SupabaseClient
): UserInterface {

    override suspend fun isUserAuth(): UserInfo? = withContext(Dispatchers.IO) {
        supabaseClient.auth.currentUserOrNull()
    }
}