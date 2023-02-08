//
//  APICaller.swift
//  Spotify
//
//  Created by Teenu Abraham on 10/02/23.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init(){}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    // MARK: - Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping(Result<AlbumDetailsResponse, Error>) -> Void){
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
//                    let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
//                    print(json)
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void){
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me/albums"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
                    completion(.success(result.items.compactMap({
                        $0.album
                    })))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func saveAlbum(album: Album, completion: @escaping (Bool) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL+"/me/albums?ids=\(album.id)"),
            type: .PUT
        ) { baseRequest in
            var request = baseRequest
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                      let code = (response as? HTTPURLResponse)?.statusCode,
                      error == nil else {
                    completion(false)
                    return
                }
                print(code)
                completion(code == 200)
            }
            task.resume()
        }
    }
    
    // MARK: - PlayLists
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping(Result<PlaylistDetailsResponse, Error>) -> Void){
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
//                    let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
//                    print(json)
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCurrentUserPlaylists(completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me/playlists/?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data)
                    completion(.success(result.items))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func createPlaylists(with name: String, completion: @escaping (Bool) -> Void) {
        getCurrentUserProfile { [weak self] result in
            switch result{
            case .success(let profile):
                let urlString = Constants.baseAPIURL + "/users/\(profile.id)/playlists"
                self?.createRequest(with: URL(string: urlString), type: .POST){ baseRequest in
                    var request = baseRequest
                    let json = [
                        "name": name
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data = data, error == nil else {
                            completion(false)
                            return
                        }
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let response = result as? [String: Any], response["id"] as? String != nil {
                               completion(true)
                            }
                            else {
                                print("failed to get id")
                                completion(false)
                            }
                           
                        }
                        catch {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                    task.resume()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func addTrackToPlaylists(
        track: AudioTrack,
        playlist: Playlist,
        completion: @escaping (Bool) -> Void
    ) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"), type: .POST) { baseRequest in
            var request = baseRequest
            let json = [
                "uris": ["spotify:track:\(track.id)"]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json,options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                       completion(true)
                    }
                    else{
                        completion(false)
                    }
//                    let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data)
//                    print(result)
//                    completion(.success(result.items))
                }
                catch {
                    print(error)
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    public func removeTrackFromPlaylists(
        track: AudioTrack,
        playlist: Playlist,
        completion: @escaping (Bool) -> Void
    ) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"), type: .DElETE) { baseRequest in
            var request = baseRequest
            let json: [String: Any] = [
                "tracks": [
                    [
                        "uri": "spotify:track:\(track.id)"
                    ]
                ]
               
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json,options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                       completion(true)
                    }
                    else{
                        completion(false)
                    }
//                    let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data)
//                    print(result)
//                    completion(.success(result.items))
                }
                catch {
                    print(error)
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    // MARK: CurrentUserProfile
    
    public func getCurrentUserProfile(completion: @escaping (Result <UserProfile, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET ){
            baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) {
                [weak self] data, _, error in
                guard let data = data,
                        error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    // MARK: BrowseApi/ NewRelease
    
    public func getNewReleases(completion: @escaping (Result<NewReleasesResponse,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=10"), type: .GET)  {
            request in
            let task = URLSession.shared.dataTask(with: request){
                [weak self] data, _, error in
                guard let data = data , error == nil else{
                    completion(.failure(APIError.failedToGetData))
                   return
                }
                do{
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK:  All Featured Playlists
    
    public func getFeaturedPlaylists(completion: @escaping(Result<FeaturedPlaylistResponse,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=10"), type: .GET){
            request in
            let task = URLSession.shared.dataTask(with: request){
                [weak self] data, _, error in
                guard let data = data , error == nil else{
                    completion(.failure(APIError.failedToGetData))
                   return
   
                }
                do{
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Get Reccommendation
    
    public func getRecommendation(genres: Set<String>, completion: @escaping (Result<RecommendationsResponse,Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)?"),
            type: .GET ) {
            request in
            let task = URLSession.shared.dataTask(with: request){
                [weak self] data, _, error in
                guard let data = data , error == nil else{
                    completion(.failure(APIError.failedToGetData))
                   return
   
                }
                do{
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                                print( "\(json)")
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Get Generes Seeds
    public func getRecommendedGeneres(completion: @escaping(Result<RecommendedGenresResponse,Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET){
            request in
            let task = URLSession.shared.dataTask(with: request){
                [weak self] data, _, error in
                guard let data = data , error == nil else{
                    completion(.failure(APIError.failedToGetData))
                   return
   
                }
                do{
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Category
    
    public func getCategories(completion: @escaping(Result<[Category],Error>) -> Void){
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request){
                [weak self] data, _, error in
                guard let data = data , error == nil else{
                    completion(.failure(APIError.failedToGetData))
                   return
   
                }
                do{
                    let results = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(results.categories.items))
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                                print( "\(json)")
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
            }
    }
    public func getCategoryPlaylist(category: Category, completion: @escaping(Result<[Playlist],Error>) -> Void){
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request){
                [weak self] data, _, error in
                guard let data = data , error == nil else{
                    completion(.failure(APIError.failedToGetData))
                   return
   
                }
                do{
                    let result = try JSONDecoder().decode(CategoryPlaylistResponse.self, from: data)
                    completion(.success(result.playlists.items))
//                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                                print( "\(json)")
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
            }
    }
    
    // MARK: - Search
    
    public func search(with query: String, completion: @escaping(Result<[SearchResult],Error>) -> Void){
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
            type: .GET) { request in
                print(request.url?.absoluteString ?? "none")
                let task = URLSession.shared.dataTask(with: request){
                    [weak self] data, _, error in
                    guard let data = data , error == nil else{
                        completion(.failure(APIError.failedToGetData))
                       return
       
                    }
                    do{
                        let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                        
                        var searchResults: [SearchResult] = []
                        searchResults.append(contentsOf:  result.tracks.items.compactMap {
                            .track(model: $0)
                        })
                        searchResults.append(contentsOf:  result.albums.items.compactMap {
                           .album(model: $0)
                        })
                        searchResults.append(contentsOf:  result.artists.items.compactMap {
                           .artist(model: $0)
                        })
                        searchResults.append(contentsOf:  result.playlists.items.compactMap {
                            .playlist(model: $0)
                        })
                        completion(.success(searchResults))
//                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                                    print( "\(json)")
                    }
                    catch{
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    // MARK: - Private
    
    enum HTTPMethod: String {
        case GET
        case POST
        case DElETE
        case PUT
    }
    
    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken{
            [weak self] token in
            guard let apiUrl = url else {
                return
            }
            
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
         
        }
    }
}
