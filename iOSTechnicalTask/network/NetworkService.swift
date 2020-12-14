//
//  NetworkService.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 13/12/2020.
//

import Foundation
import RxAlamofire
import RxSwift
import ObjectMapper

class NetworkService {
    
    class func requestJSON<T : Mappable>(request: URLRequest, responseType: T.Type) -> Observable<T> {
        
        return RxAlamofire.request(request)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .string()
            .map({ (jsonString) -> T in
                if let object = Mapper<T>().map(JSONString: jsonString) {
                    return object
                }
                else {
                    throw NetworkError.parsingError(request.url?.relativePath ?? "")
                }
            })
            .asObservable()
    }
}
