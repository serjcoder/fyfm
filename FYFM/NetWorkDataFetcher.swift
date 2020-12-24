//
//  NetWorkDataFetcher.swift
//  FYFM
//
//  Created by Сергей on 10.12.2020.
//
import Foundation

class NetWorkDataFetcher {
    let networkService = NetworkService()
    
    func fetchTraks (urlString: String, responce: @escaping (FilmsListResponse?) -> Void) {
        networkService.request(urlString: urlString) { (result) in
            switch result {
                
            case .success(let data):
                do {
                    let traks = try JSONDecoder().decode(FilmsListResponse.self, from:data)
                    responce(traks)
                } catch let jsonError {
                    print("Fail to decode: \(jsonError)")
                    responce(nil)
                }
            case .failure(let error):
                print("recived data error \(error.localizedDescription)")
                responce(nil)
            }
        }
    }
}
