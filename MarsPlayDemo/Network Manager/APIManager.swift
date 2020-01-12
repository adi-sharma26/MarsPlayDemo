//
//  APIManager.swift
//  MarsPlayDemo
//
//  Created by Aditya on 10/01/20.
//  Copyright © 2020 Aditya. All rights reserved.
//

import UIKit
import Alamofire

enum ErrorReason: Error {
    case internetNotReachable
    case couldNotSerializeData
    case couldNotParseJSON
    case noData
    case noSuccessStatusCode(statusCode: Int)
    case fromServer(NSError)
    case other(NSError?)
}

typealias APIServiceCompletionCallback = (([String:Any]) -> ())
typealias APIServiceFailureCallback = ((Error) -> ())

class APIManager: NSObject {
    
    static func getMoviesList(with url: URL, failure: @escaping
    APIServiceFailureCallback, completion: @escaping APIServiceCompletionCallback) {
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate().responseString { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    completion(json ?? ["":""])
                } catch let err {
                    print("Err", err)
                }
                break
            case .failure(let error):
                failure(error)
                break
            }
        }
    }

}
