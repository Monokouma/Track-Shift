package com.despaircorp.trackshift.domain.user

class ManageEmailPasswordAuthUseCase(
    private val userInterface: UserInterface
) {
    suspend fun invoke(mail: String, password: String): Boolean =
        userInterface.authUsingMailPassword(mail, password).isSuccess
}