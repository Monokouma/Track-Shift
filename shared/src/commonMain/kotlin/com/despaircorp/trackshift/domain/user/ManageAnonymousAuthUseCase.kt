package com.despaircorp.trackshift.domain.user

class ManageAnonymousAuthUseCase(
    private val userInterface: UserInterface
) {
    suspend fun invoke(): Boolean = userInterface.authAnonymously().isSuccess

}