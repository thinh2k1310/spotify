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
    
    
    // MARK: - FUNCTION
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
}
