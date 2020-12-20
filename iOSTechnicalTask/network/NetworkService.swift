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
    
    class func requestJSON<T : Mappable>(request: URLRequest, responseType: T.Type) -> Observable<Result<T, NetworkError>> {
        
        return RxAlamofire.request(request)
            .validate(contentType: ["application/json"])
            .responseString()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .mappable(ofType: T.self)
            .asObservable()
    }
}

extension Observable where Element == (HTTPURLResponse, String){
    fileprivate func mappable<T : Mappable>(ofType type: T.Type) -> Observable<Result<T, NetworkError>>{
        return self.map{ (httpURLResponse, string) -> Result<T, NetworkError> in
            
            let apiPath = httpURLResponse.url?.relativePath ?? ""
            switch httpURLResponse.statusCode{
            case 200..<300:
                // is status code is successful we can safely decode to our expected type T
                guard let object = Mapper<T>().map(JSONString: string) else {
                    return .failure(NetworkError.parsingError(apiPath))
                }
                
                return .success(object)
            default:
                // otherwise try
                return .failure(NetworkError.serverError(apiPath))
            }
        }
    }
}
