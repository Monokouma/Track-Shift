package com.despaircorp.trackshift.data.tracks

import com.despaircorp.trackshift.data.tracks.api.TrackShiftApi
import com.despaircorp.trackshift.data.tracks.dto.ConvertRequestEntity
import com.despaircorp.trackshift.data.tracks.dto.ConvertedTrack
import com.despaircorp.trackshift.domain.tracks.TracksInterface
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import kotlinx.coroutines.withContext

class TracksRepository(
    private val api: TrackShiftApi
): TracksInterface {

    override suspend fun convertPlaylist(
        token: String,
        request: ConvertRequestEntity
    ): Result<List<ConvertedTrack>> = withContext(Dispatchers.IO) {
        try {
            api.convertPlaylist(token, request)
        } catch (e: Exception) {
            println(e.stackTraceToString())
            Result.failure(e)
        }
    }
}