//
//   LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Truong Thinh on 13/04/2022.
//

import Foundation

struct LibraryAlbumsResponse : Codable{
    let items : [SaveAlbum]
}

struct SaveAlbum : Codable{
    let added_at : String
    let album : Album
}
