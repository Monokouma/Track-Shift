package com.despaircorp.trackshift.domain.user

class ManageAuthWithAppleUseCase(
    private val userInterface: UserInterface
) {
    suspend fun invoke(idToken: String, nonce: String): Boolean =  userInterface.signInWithApple(idToken, nonce).isSuccess
}