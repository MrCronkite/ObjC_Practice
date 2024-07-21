//
//  ModerChild.swift
//  testObjc-C
//
//  Created by Admin on 21.07.24.
//

import Foundation

@objc
final class ModerChild: NSObject {
    @objc func sayString() -> String {
        return "New Something"
    }
    
    deinit {
        print("phel nah")
    }
}
