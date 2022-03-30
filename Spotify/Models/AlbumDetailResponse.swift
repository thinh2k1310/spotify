//
//  AlbumDetailResponse.swift
//  Spotify
//
//  Created by Truong Thinh on 30/03/2022.
//

import Foundation

struct AlbumDetailResponse : Codable{
    let album_type : String
    let artist : [Artist]?
    let external_urls : [String : String]
    let id : String
    let images : [APIImage]
    let label : String
    let name : String
    let tracks : TracksResponse
}

struct TracksResponse : Codable{
    let items : [AudioTrack]
}
