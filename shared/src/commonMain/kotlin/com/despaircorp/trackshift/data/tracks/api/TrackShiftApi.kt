package com.despaircorp.trackshift.data.tracks.api

import com.despaircorp.trackshift.data.tracks.dto.ConvertRequestEntity
import com.despaircorp.trackshift.data.tracks.dto.ConvertedTrack
import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.forms.formData
import io.ktor.client.request.forms.submitFormWithBinaryData
import io.ktor.client.request.header
import io.ktor.http.Headers
import io.ktor.http.HttpHeaders

class TrackShiftApi(
    private val httpClient: HttpClient
) {

    suspend fun convertPlaylist(
        token: String,
        request: ConvertRequestEntity
    ): Result<List<ConvertedTrack>> {
        return try {
            val response = httpClient.submitFormWithBinaryData(
                url = "https://trackshift.fr/analyze",
                formData = formData {
                    append("fromPlatform", "spotify")
                    append("toPlatform", request.toPlatform)
                    append("region", request.region)

                    request.images.forEachIndexed { index, imageBytes ->
                        append(
                            "images[]",
                            imageBytes,
                            Headers.build {
                                append(HttpHeaders.ContentType, "image/png")
                                append(
                                    HttpHeaders.ContentDisposition,
                                    "filename=\"image$index.png\""
                                )
                            }
                        )
                    }
                }
            ) {
                header("Authorization", token)
            }

            val tracks = response.body<List<ConvertedTrack>>()
            println("kotlin = $tracks")
            Result.success(tracks)

        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
