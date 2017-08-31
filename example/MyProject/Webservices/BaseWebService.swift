//
//  BaseWebService.swift
//  MyProject
//
//  Created by Akhilraj on 28/08/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import Foundation
import Alamofire

public class BaseWebService {
    
    private var baseURL: String = ""
    public var requestMethod: Alamofire.HTTPMethod = .get
    public var urlString:String?
    public var parameters:[String: Any]?
    public var headers: HTTPHeaders = [:]
    
    public func startWebService(success: @escaping (Any) -> Void, failure: @escaping (Error?) -> Void) {
        let finalURL = baseURL + urlString!
        Alamofire.request(finalURL, method: requestMethod, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    success(JSON)
                } else {
                    failure(NSError(domain: "Some error", code: 0, userInfo: nil))
                }
            } else {
                failure(response.result.error)
            }
        }
    }
}
