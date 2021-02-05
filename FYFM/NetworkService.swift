//
//  NetworkService.swift
//  FYFM
//
//  Created by Сергей on 10.12.2020.
//
import Foundation

func synchronized(_ lock: AnyObject, closure: () -> Void) {
objc_sync_enter(lock)
closure()
objc_sync_exit(lock)
}

class NetworkService {
//    добавить фунцию для многопоточных запросов
//    https://riptutorial.com/ios/example/28278/dispatch-group
    
    
    func request(urlString: String, completion: @escaping (Result<Data,Error>) -> Void) {
        guard let url = URL(string: urlString) else {return}
            URLSession.shared.dataTask(with: url) {  (data, response,error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    guard let data = data else { return }
                    completion(.success(data))
                }
            }.resume()
    }
    
    

    
    
}
