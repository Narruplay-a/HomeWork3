//
//  NetrworkService.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 14.09.2021.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchEarthPhotos() -> Future<[EarthModel], Error>
}

final class NetworkService: NetworkServiceProtocol {
    private let urlSession  : URLSession            = URLSession.shared
    private let jsonDecoder : JSONDecoder           = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        
        return decoder
    }()
    var subcriptions        : Set<AnyCancellable>   = .init()
    
    func fetchEarthPhotos() -> Future<[EarthModel], Error> {
        return Future<[EarthModel], Error> { future in
            guard let requestUrl = self.generateEarthPhotosUrl() else {
                return  future(.failure(APIError.requestFailed))
            }
            
            self.urlSession.dataTaskPublisher(for: requestUrl)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw APIError.requestFailed
                }

                return data
            }
                .decode(type: Array<EarthModel>.self, decoder: self.jsonDecoder)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    future(.failure(APIError.requestFailed))
                }
            }, receiveValue: { data in
                future(.success(data))
            }).store(in: &self.subcriptions)
        }
    }
}

private extension NetworkService {
    func generateEarthPhotosUrl() -> URL? {
        guard var urlComponents = URLComponents(string: "https://api.nasa.gov/EPIC/api/natural/date/2019-05-30") else {
            return nil
        }
        
        let queryItems = [URLQueryItem(name: "api_key", value: QueryFixedParams.apiKey.rawValue)]
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
}


enum QueryFixedParams: String {
    case apiKey = "UzLWLUppiWL3fU0CxGFHs5N4YGZpHC6ZczDXkoTA"
}
 
enum APIError: Error {
    case unsupportedUrl
    case requestFailed
}
