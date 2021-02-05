//
//  NetWorkDataFetcher.swift
//  FYFM
//
//  Created by Сергей on 10.12.2020.
//
import Foundation

class NetWorkDataFetcher {
    let networkService = NetworkService()
    let lock = NSObject() //Object to lock on.
    let dispatchGroup = DispatchGroup()
    let session: URLSession = URLSession.shared
    
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

    func loadAllImages(images:[String])->Array<Data?> {
        var counter = 0
        var responseArray = Array<Data?>() //Array of responses.
        print("loadAll in")
        for image in images {
            responseArray.append(nil)
            dispatchGroup.enter()
            session.dataTask(with: URLRequest(url: URL(string: image)!)) { (data, response, error) in
                //Process Response..
                synchronized(self.lock, closure: { () -> Void in
                    responseArray[counter] = data ?? nil
                })
                self.dispatchGroup.leave() //Leave the group for the item task.
                counter+=1
            }.resume()
        }
        dispatchGroup.wait()
        return responseArray
    }
}
