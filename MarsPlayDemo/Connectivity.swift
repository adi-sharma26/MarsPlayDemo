//
//  Reachability.swift
//  MarsPlayDemo
//
//  Created by Aditya on 12/01/20.
//  Copyright © 2020 Aditya. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
