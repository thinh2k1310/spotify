//
//  APICaller.swift
//  Spotify
//
//  Created by Truong Thinh on 17/03/2022.
//

import Foundation

final class APICaller{
    // MARK: - PROPERTY
    static let shared = APICaller()
    
    private init(){
        
    }
    
    enum HTTPMethod : String{
        case GET = "GET"
        case POST = "POST"
    }
    
    struct Constants{
        static let baseURL = "https://api.spotify.com/v1"
    }
    
    
    // MARK: - ALBUMS
    func getAlbumDetail(album : Album, completion : @escaping  (Result<AlbumDetailResponse,Error>) -> Void){
        createRequest(with:URL(string:Constants.baseURL + "/albums/" + album.id),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    completion(.failure(error!))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(AlbumDetailResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                    
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(json)
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - PLAYLISTS
    func getPlaylistDetail(playlist : Playlist, completion : @escaping (Result<PlaylistDetailResponse,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/playlists/" + playlist.id),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(error!))
                    return
                }
                do {
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(result)
                    let result = try JSONDecoder().decode(PlaylistDetailResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    // MARK: - PROFILE
    private func createRequest( with url : URL? , type : HTTPMethod, completion : @escaping (URLRequest) -> Void ){
        AuthManager.shared.withValidToken{ token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    public func getCurrentUserProfile(completion : @escaping (Result<UserProfile,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/me"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data , error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(UserProfile.self, from: safeData)
                    completion(.success(result))
//                    let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    // MARK: - HOME
    public func getNewReleases(completion : @escaping (Result<NewReleaseResponse,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/browse/new-releases?limit=50"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data , error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(NewReleaseResponse.self, from: safeData)
                    //completion(.success(result))
                    //let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    completion(.success(result))
                    
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    public func getFeaturePlaylist(completion : @escaping (Result<FeaturedPlaylistResponse,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/browse/featured-playlists?limit=50"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data , error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: safeData)
                    //let results = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    //print(results)
                    completion(.success(result))
                    
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    public func getRecommendationGenres(completion : @escaping (Result<RecommendedGenresResponse,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/recommendations/available-genre-seeds"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data , error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: safeData)
                    //let results = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    //print(results)
                    completion(.success(result))
                    
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    public func getRecommendation(genres : Set<String>,completion : @escaping (Result<RecommendationResponse,Error>) -> Void){
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseURL + "/recommendations?limit=40&seed_genres=\(seeds)"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data , error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(RecommendationResponse.self, from: safeData)
                    //let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    completion(.success(result))
                    
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}
