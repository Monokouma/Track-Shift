package com.despaircorp.trackshift.container

import androidx.compose.runtime.Stable
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.despaircorp.trackshift.domain.user.IsUserAuthUseCase
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

@Stable
class TrackShiftViewModel(
    private val isUserAuthUseCase: IsUserAuthUseCase
): ViewModel() {

    private val _authState = MutableStateFlow<AuthState>(AuthState.Loading)
    val authState: StateFlow<AuthState> = _authState.asStateFlow()

    init {
        checkAuth()
    }

    private fun checkAuth() {
        viewModelScope.launch {
            val isAuth = isUserAuthUseCase.invoke()

            _authState.value = if (isAuth) {
                AuthState.Authenticated
            } else {
                AuthState.NotAuthenticated
            }
        }
    }
}