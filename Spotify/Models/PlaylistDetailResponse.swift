//
//  PlaylistDetailResponse.swift
//  Spotify
//
//  Created by Truong Thinh on 30/03/2022.
//

import Foundation

struct PlaylistDetailResponse : Codable{
    let description : String
    let external_urls : [String : String]
    let id : String
    let images : [APIImage]
    let name : String
    let tracks : TracksPlaylistResponse
}
struct TracksPlaylistResponse : Codable{
    let items : [TrackResponse]
}
struct TrackResponse : Codable {
    let track : AudioTrack
}
