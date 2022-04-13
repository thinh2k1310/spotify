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
        case PUT = "PUT"
        case DELETE = "DELETE"
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
    func getCurrentUserAlbums(completion : @escaping (Result<[Album],Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/me/albums"),
                      type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data , error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: safeData)
                    //let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    //print(result)
                    completion(.success(result.items.compactMap({$0.album })))
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    func saveAlbum(album : Album, completion : @escaping (Bool)->Void ){
        createRequest(with: URL(string: Constants.baseURL + "/me/albums?ids=\(album.id)"),
                      type: .PUT
        ) { baseRequest in
            var request = baseRequest

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let code = (response as? HTTPURLResponse)?.statusCode,
                        error == nil else {
                    completion(false)
                    return
                }
                completion(code == 200)
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
    // MARK: - CATEGORY
    public func getCategories(completion : @escaping (Result<[Category],Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/browse/categories?locale=en_US&limit=50"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data , error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(CategoriesResponse.self, from: safeData)
                    //let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    completion(.success(result.categories.items))
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylist(category : Category, completion : @escaping (Result<[Playlist],Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/browse/categories/\(category.id)/playlists?limit=50"),
                      type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data , error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(CategoryPlaylistResponse .self, from: safeData)
                    //let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    completion(.success(result.playlists.items))
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - SEARCH
    public func search(with query : String, completion: @escaping (Result<[SearchResult],Error>) -> Void){
        createRequest(with: URL(
            string: Constants.baseURL + "/search?type=album,track,playlist,artist&limit=10&q=\(query.addingPercentEncoding(withAllowedCharacters : .urlQueryAllowed) ?? "")"),
            type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data , error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(SearchResultsResponse.self, from: safeData)
                    //let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    var searchResults : [SearchResult] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap({.track(model: $0)}))
                    searchResults.append(contentsOf: result.albums.items.compactMap({.album(model: $0)}))
                    searchResults.append(contentsOf: result.artists.items.compactMap({.artist(model: $0)}))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({.playlist(model: $0)}))
                    completion(.success(searchResults))
                    //print(result)
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - LIBRARY
    
    func getCurrentUserPlaylist(completion : @escaping (Result<[Playlist],Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL + "/me/playlists"),
                      type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data , error == nil else {
                    return
                }
                do{
                    let result = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: safeData)
                    //let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    completion(.success(result.items))
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    func createPlaylist(with name : String, completion : @escaping (Bool)->Void){
        getCurrentUserProfile{ [weak self] result in
            switch result{
            case .success(let profile):
                let url = URL(string: Constants.baseURL + "/users/\(profile.id)/playlists")
                
                self?.createRequest(with: url, type: .POST) { baseRequest in
                    var request = baseRequest
                    let json = [
                        "name" : name
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let safeData = data , error == nil else {
                            completion(false)
                            return
                        }
                        do{
                            //let result = try JSONDecoder().decode(CategoryPlaylistResponse .self, from: safeData)
                            let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                            if let response = result as? [String : Any], response["id"] != nil {
                                completion(true)
                            }
                            else {
                                completion(false)
                            }
                        }catch{
                            print(error)
                            completion(false)
                        }
                    }
                    task.resume()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addTrackToPlaylist(track : AudioTrack, playlist : Playlist,completion : @escaping (Bool)->Void ){
        createRequest(with: URL(string: Constants.baseURL + "/playlists/\(playlist.id)/tracks"), type: .POST) { baseRequest in
            var request = baseRequest
            let json = [
                "uris" : ["spotify:track:\(track.id)"]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data , error == nil else {
                    completion(false)
                    return
                }
                do{
                    let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    if let response = result as? [String : Any], response["snapshot_id"] as? String != nil{
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                }catch{
                    print(error)
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    func removeTrackFromPlaylist(track : AudioTrack, playlist : Playlist,completion : @escaping (Bool)->Void ){
        createRequest(with: URL(string: Constants.baseURL + "/playlists/\(playlist.id)/tracks"), type: .DELETE ) { baseRequest in
            var request = baseRequest
            let json : [String : Any] = [
                "tracks" : [
                    [
                        "uri" : "spotify:track:\(track.id)"
                        
                    ]
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let safeData = data , error == nil else {
                    completion(false)
                    return
                }
                do{
                    let result = try JSONSerialization.jsonObject(with: safeData, options: .allowFragments)
                    print(result)
                    if let response = result as? [String : Any], response["snapshot_id"] as? String != nil{
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                }catch{
                    print(error)
                    completion(false)
                }
            }
            task.resume()
        }
    }
}
