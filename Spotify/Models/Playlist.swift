//
//  Playlist.swift
//  Spotify
//
//  Created by Truong Thinh on 17/03/2022.
//

import Foundation

struct Playlist : Codable{
    let description : String
    let id : String
    let external_urls : [String : String]
    let images : [APIImage]
    let name : String
    let owner : User
}
