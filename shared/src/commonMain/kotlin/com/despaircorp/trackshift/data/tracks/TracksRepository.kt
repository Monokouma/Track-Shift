package com.despaircorp.trackshift.data.tracks

import com.despaircorp.trackshift.data.tracks.api.TrackShiftApi
import com.despaircorp.trackshift.data.tracks.dto.ConvertRequestEntity
import com.despaircorp.trackshift.data.tracks.dto.ConvertedTrack
import com.despaircorp.trackshift.domain.tracks.TracksInterface

class TracksRepository(
    private val api: TrackShiftApi
): TracksInterface {

    override suspend fun convertPlaylist(
        token: String,
        request: ConvertRequestEntity
    ): Result<List<ConvertedTrack>> {
        return api.convertPlaylist(token, request)
    }
}