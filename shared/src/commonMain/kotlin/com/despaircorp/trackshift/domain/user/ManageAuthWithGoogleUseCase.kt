package com.despaircorp.trackshift.domain.user

class ManageAuthWithGoogleUseCase(
    private val userInterface: UserInterface
) {
    suspend fun invoke(idToken: String): Boolean = userInterface.signInWithGoogle(idToken).isSuccess
}