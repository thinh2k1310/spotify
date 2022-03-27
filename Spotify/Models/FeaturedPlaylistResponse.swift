//
//  FeaturedPlaylistResponse.swift
//  Spotify
//
//  Created by Truong Thinh on 21/03/2022.
//

import Foundation

struct FeaturedPlaylistResponse : Codable{
    let playlists : PlaylistResponse
}
struct PlaylistResponse : Codable{
    let items : [Playlist]
}

struct User : Codable{
    let display_name : String
    let external_urls : [String : String]
    let id : String
}


                
