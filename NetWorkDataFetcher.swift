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
                    let data = try JSONDecoder().decode(FilmsListResponse.self, from:data)
                    responce(data)
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
    
    func imageLoad(posterPath:String?) -> Data {
        var posterPathUrl = "https://vcunited.club/wp-content/uploads/2020/01/No-image-available-2.jpg"
        if let optionlaPosterPath = posterPath   {
            posterPathUrl = "https://image.tmdb.org/t/p/w500/" + optionlaPosterPath
        }
        return try! Data(contentsOf: URL(string: posterPathUrl)! )
    }
}
