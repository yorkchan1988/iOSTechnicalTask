//
//  GetTransactionList.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 13/12/2020.
//

import Foundation
import Alamofire
import RxSwift

class GetTransactionListApi {
    
    let path = API_PATH_GET_TRANSACTION_LIST
    
    class func requestMappable() -> Observable<GetTransactionListResponse> {
        var request = URLRequest(url: NSURL(string: API_BASE_PATH+API_PATH_GET_TRANSACTION_LIST)! as URL)
        request.httpMethod = Alamofire.HTTPMethod.get.rawValue
        
        return NetworkService.requestJSON(request: request, responseType: GetTransactionListResponse.self)
    }
}
