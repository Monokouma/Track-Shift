package com.despaircorp.trackshift.domain.tracks

import com.despaircorp.trackshift.data.tracks.dto.ConvertRequestEntity
import com.despaircorp.trackshift.data.tracks.dto.ConvertedTrack

interface TracksInterface {
    suspend fun convertPlaylist(
        token: String,
        request: ConvertRequestEntity
    ): Result<List<ConvertedTrack>>
}