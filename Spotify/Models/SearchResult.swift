//
//  SearchResult.swift
//  Spotify
//
//  Created by Truong Thinh on 09/04/2022.
//

import Foundation

enum SearchResult{
    case artist(model : Artist)
    case playlist(model : Playlist)
    case track(model : AudioTrack)
    case album(model : Album)
}
