//
//  TestUtils.swift
//  iOSTechnicalTaskTests
//
//  Created by YORK CHAN on 18/12/2020.
//

import Foundation
import ObjectMapper

@testable
import iOSTechnicalTask

func loadJson(testClass: AnyClass, fileName: String, ext: String) -> [String: Any]? {
    guard let path = Bundle(for: testClass).path(forResource: fileName, ofType: ext) else {
        return nil
    }
        
    do {
        let text = try String(contentsOfFile: path, encoding: .utf8)
        guard let dict = try JSONSerialization.jsonObject(with: text.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
            return nil
        }
        
        return dict
    } catch {
        return nil
    }
}
