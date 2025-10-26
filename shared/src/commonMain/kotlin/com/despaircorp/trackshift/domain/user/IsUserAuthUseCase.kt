package com.despaircorp.trackshift.domain.user

class IsUserAuthUseCase(
    private val userInterface: UserInterface
) {
    suspend fun invoke(): Boolean = userInterface.isUserAuth().let {
        return@let it != null
    }
}