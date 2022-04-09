//
//  SearchResultResponse.swift
//  Spotify
//
//  Created by Truong Thinh on 09/04/2022.
//

import Foundation

struct SearchResultsResponse : Codable {
    let albums : SearchAlbumsResponse
    let playlists : SearchPlaylistsResponse
    let artists : SearchArtistsResponse
    let tracks : SearchTracksResponse
}

struct SearchAlbumsResponse : Codable {
    let items : [Album]
}

struct SearchPlaylistsResponse : Codable {
    let items : [Playlist]
}

struct SearchArtistsResponse : Codable {
    let items : [Artist]
}

struct SearchTracksResponse : Codable {
    let items : [AudioTrack]
}
