//
//  Network.swift
//  RxSwiftShoppingList
//
//  Created by 백래훈 on 11/8/23.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

class ItunesAPIManager {
    
    static func fetchData(query: String) -> Observable<SearchAppModel> {
        
        return Observable<SearchAppModel>.create { observer in
            
            let urlString = "https://itunes.apple.com/search?term=\(query)&country=KR&media=software&lang=ko_KR&limit=10"
            
            guard let url = URL(string: urlString) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            print(urlString)
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                print("DataTask Succeed")
                
                if let _ = error {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                
                if let data = data, let appData = try? JSONDecoder().decode(SearchAppModel.self, from: data) {
                    observer.onNext(appData)
                }
            }.resume()
            
            return Disposables.create()
        }
    }
}

