//
//  Webservice.swift
//  RAWG-Assessment
//
//  Created by cleanmac on 14/08/23.
//

import Foundation

struct WebserviceDependencyKey: DependencyKey {
    static var currentValue: Webservice = Webservice()
}

enum WebserviceError: Error {
    case invalidURL
    case responseError
}

final class Webservice {
    private let API_KEY = "5a32bbcf0b3246d88db60c0fe4432fbb"
    private let ENDPOINT = "https://api.rawg.io/api/games"
    
    func request<T: Decodable>(gameId: Int = 0, page: Int = 0, searchQuery: String? = nil, responseType: T.Type) async throws -> T {
        let fullEndpoint = gameId != 0 ? ENDPOINT + "/\(gameId)" : ENDPOINT
        
        var pageQueryItems = [URLQueryItem(name: "key", value: API_KEY)]
        
        if let searchQuery {
            pageQueryItems.append(URLQueryItem(name: "search", value: searchQuery))
        }
        
        if page != 0 {
            pageQueryItems.append(URLQueryItem(name: "page", value: String(page)))
            pageQueryItems.append(URLQueryItem(name: "page_size", value: String(15)))
        }
        
        if var urlComponents = URLComponents(string: fullEndpoint) {
            urlComponents.queryItems = pageQueryItems
            
            if let url = urlComponents.url {
                print("URL String: \(url.absoluteString)")
                let request = URLRequest(url: url)
                let task = try await URLSession.shared.data(for: request)
                
                // FIXME: This JSON Serialization is for debugging purposes only
                //let json = try JSONSerialization.jsonObject(with: task.0, options: []) as? [String : Any]
                //dump(json)
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: task.0)
                    return decodedData
                } catch {
                    throw WebserviceError.responseError
                }
            } else {
                throw WebserviceError.invalidURL
            }
        } else {
            throw WebserviceError.invalidURL
        }
    }
}
