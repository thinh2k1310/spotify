//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by Truong Thinh on 21/03/2022.
//

import Foundation

struct NewReleaseResponse : Codable{
    let albums : AlbumsResponse
}
struct AlbumsResponse : Codable{
    let items : [Album]
}
struct Album : Codable{
    let album_type : String
    let available_markets : [String]
    let id : String
    var images : [APIImage]
    let name : String
    let release_date : String
    let total_tracks : Int
    let artists : [Artist]
}

