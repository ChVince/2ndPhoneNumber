//
//  DataManager.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 15.10.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//
import Foundation

class DataManager {
    static func fetchData(service: Service, completeion: @escaping (_ result: Data) -> Void) {
        let url = service.url!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                //self.handleServerError(response)
                return
            }
            DispatchQueue.main.async {
                completeion(data!)
            }
        }
        task.resume()
    }
}
