package com.despaircorp.trackshift.container

sealed class AuthState {
    data object Loading : AuthState()
    data object Authenticated : AuthState()
    data object NotAuthenticated : AuthState()
}